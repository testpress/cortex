import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../models/download_item.dart';
import '../services/downloads_service.dart';

part 'downloads_repository.g.dart';

/// Orchestrates all download-related operations.
/// Coordinates between [DownloadsService] (network/SDK worker) and
/// [AppDatabase] (local persistence). Mirrors the [AuthRepository] pattern.
class DownloadsRepository {
  final AppDatabase _db;
  final DownloadsService _service;
  final Map<String, DownloadItem> _lastKnownState = {};
  final Set<String> _deletedIds = {};

  DownloadsRepository(this._db, this._service) {
    _initStream();
  }

  void _initStream() {
    _service.downloadsStream.listen((items) {
      final currentIds = items.map((e) => e.id).toSet();
      _deletedIds.removeWhere((id) => !currentIds.contains(id));

      for (final item in items) {
        if (_deletedIds.contains(item.id)) continue;

        final existing = _lastKnownState[item.id];
        if (existing == null || 
            existing.progress != item.progress || 
            existing.status != item.status) {
          _lastKnownState[item.id] = item;
          upsertDownload(item);
        }
      }
    });
  }

  /// Watch all persistent downloads from the DB, mapped to domain models.
  Stream<List<DownloadItem>> watchAllDownloads() {
    return _db.select(_db.downloadsTable).watch().map((rows) {
      return rows.map((row) => DownloadItem(
        id: row.id,
        title: row.title,
        course: row.course,
        chapter: row.chapter,
        sizeInBytes: row.sizeInBytes.toInt(),
        downloadedDate: row.downloadedDate,
        type: DownloadType.values[row.typeIndex],
        status: DownloadStatus.values[row.statusIndex],
        progress: row.progress,
        thumbnailUrl: row.thumbnailUrl,
        duration: row.duration,
        fileType: row.fileType,
        contentUrl: row.contentUrl,
      )).toList();
    });
  }

  /// Starts an attachment download and owns the full lifecycle:
  /// insert "downloading" → receive progress updates → write "completed" or "error".
  Future<void> startAttachmentDownload(DownloadItem item, String url) async {
    try {
      // 0. Check if the file already exists physically on the device.
      // If it does (e.g. downloaded before DB clear), adopt it instead of overwriting.
      // This prevents Android 14 Scoped Storage Permission Denied errors.
      final existingSize = await _service.getExistingAttachmentSize(url);
      if (existingSize != null) {
        await upsertDownload(item.copyWith(
          status: DownloadStatus.completed,
          progress: 100,
          sizeInBytes: existingSize,
        ));
        return;
      }

      // 1. Persist the initial "downloading" state immediately
      await upsertDownload(item);

      // 2. Delegate the actual HTTP download to the service worker
      final downloadedSize = await _service.downloadAttachment(
        url,
        onProgress: (progressPercent) {
          // 3. Persist progress updates as they arrive
          upsertDownload(item.copyWith(progress: progressPercent));
        },
      );

      // 4. Persist the final "completed" state with actual file size
      if (downloadedSize != null) {
        await upsertDownload(item.copyWith(
          status: DownloadStatus.completed,
          progress: 100,
          sizeInBytes: downloadedSize,
        ));
      } else {
        await upsertDownload(item.copyWith(status: DownloadStatus.error, progress: 0));
      }
    } catch (e) {
      await upsertDownload(item.copyWith(status: DownloadStatus.error, progress: 0));
    }
  }

  /// Initial synchronization between SDKs and Database.
  Future<void> synchronize() async {
    final activeVideoDownloads = await _service.getActiveVideoDownloads();
    final activeVideoIds = activeVideoDownloads.map((e) => e.id).toList();

    // Verify attachment files exist on disk
    final dbAttachments = await (_db.select(_db.downloadsTable)
          ..where((t) => t.typeIndex.equals(DownloadType.attachment.index)))
        .get();

    final activeAttachmentIds = <String>[];
    for (final attachment in dbAttachments) {
      if (attachment.statusIndex != DownloadStatus.completed.index) {
        activeAttachmentIds.add(attachment.id);
      } else if (attachment.contentUrl != null) {
        if (await _service.verifyAttachmentExists(attachment.contentUrl!)) {
          activeAttachmentIds.add(attachment.id);
        }
      }
    }

    final activeIds = [...activeVideoIds, ...activeAttachmentIds];

    await _db.batch((batch) {
      // 1. Remove stale records that are no longer active.
      batch.deleteWhere(
        _db.downloadsTable,
        (tbl) => tbl.id.isNotIn(activeIds),
      );

      // 2. Sync/Update active video records (attachments are managed directly).
      if (activeVideoDownloads.isNotEmpty) {
        batch.insertAllOnConflictUpdate(
          _db.downloadsTable,
          activeVideoDownloads.map((item) => DownloadsTableCompanion(
                id: Value(item.id),
                title: Value(item.title),
                course: Value(item.course),
                chapter: Value(item.chapter),
                sizeInBytes: Value(BigInt.from(item.sizeInBytes)),
                downloadedDate: Value(item.downloadedDate),
                typeIndex: Value(item.type.index),
                statusIndex: Value(item.status.index),
                progress: Value(item.progress),
                thumbnailUrl: Value(item.thumbnailUrl),
                duration: Value(item.duration),
                fileType: Value(item.fileType),
                contentUrl: Value(item.contentUrl),
              )),
        );
      }
    });
  }

  /// Upserts a [DownloadItem] into the database.
  Future<void> upsertDownload(DownloadItem item) async {
    await _db.into(_db.downloadsTable).insertOnConflictUpdate(
      DownloadsTableCompanion(
        id: Value(item.id),
        title: Value(item.title),
        course: Value(item.course),
        chapter: Value(item.chapter),
        sizeInBytes: Value(BigInt.from(item.sizeInBytes)),
        downloadedDate: Value(item.downloadedDate),
        typeIndex: Value(item.type.index),
        statusIndex: Value(item.status.index),
        progress: Value(item.progress),
        thumbnailUrl: Value(item.thumbnailUrl),
        duration: Value(item.duration),
        fileType: Value(item.fileType),
        contentUrl: Value(item.contentUrl),
      ),
    );
  }

  // --- Actions delegated to the service worker then persisted ---

  Future<void> pauseDownload(String id) async {
    await _service.pauseVideoDownload(id);
    await (_db.update(_db.downloadsTable)..where((tbl) => tbl.id.equals(id))).write(
      DownloadsTableCompanion(statusIndex: Value(DownloadStatus.paused.index)),
    );
  }

  Future<void> resumeDownload(String id) async {
    await _service.resumeVideoDownload(id);
    await (_db.update(_db.downloadsTable)..where((tbl) => tbl.id.equals(id))).write(
      DownloadsTableCompanion(statusIndex: Value(DownloadStatus.downloading.index)),
    );
  }

  Future<void> deleteDownload(DownloadItem item) async {
    _deletedIds.add(item.id);
    _lastKnownState.remove(item.id);
    await _service.deleteDownloadItem(item);
    await (_db.delete(_db.downloadsTable)..where((tbl) => tbl.id.equals(item.id))).go();
  }

  Future<void> purgeAllDownloads() async {
    final downloads = await _db.select(_db.downloadsTable).get();
    for (final row in downloads) {
      final item = DownloadItem(
        id: row.id,
        title: row.title,
        course: row.course,
        chapter: row.chapter,
        sizeInBytes: row.sizeInBytes.toInt(),
        downloadedDate: row.downloadedDate,
        type: DownloadType.values[row.typeIndex],
        status: DownloadStatus.values[row.statusIndex],
        progress: row.progress,
        thumbnailUrl: row.thumbnailUrl,
        duration: row.duration,
        fileType: row.fileType,
        contentUrl: row.contentUrl,
      );
      await deleteDownload(item);
    }
  }
}

@Riverpod(keepAlive: true)
Future<DownloadsRepository> downloadsRepository(DownloadsRepositoryRef ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final service = ref.watch(downloadsServiceProvider);
  return DownloadsRepository(db, service);
}

@riverpod
Stream<DownloadItem?> watchDownloadItem(WatchDownloadItemRef ref, String id) async* {
  final repo = await ref.watch(downloadsRepositoryProvider.future);
  yield* repo.watchAllDownloads().map((list) {
    for (var item in list) {
      if (item.id == id) return item;
    }
    return null;
  });
}
