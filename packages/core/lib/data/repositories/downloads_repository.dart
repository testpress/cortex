import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../models/download_item.dart';
import '../services/downloads_service.dart';

part 'downloads_repository.g.dart';

class DownloadsRepository {
  final AppDatabase _db;
  final DownloadsService _service;

  DownloadsRepository(this._db, this._service);

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
      )).toList();
    });
  }

  /// Initial synchronization between SDKs and Database.
  Future<void> synchronize() async {
    final activeDownloads = await _service.getActiveDownloads();

    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.downloadsTable,
        activeDownloads.map((item) => DownloadsTableCompanion(
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
            )),
      );
    });
  }

  /// Map and save a unified DownloadItem into the Database.
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
      ),
    );
  }

  // --- Actions (Delegated to Service) ---

  Future<void> pauseDownload(String id) => _service.pauseDownload(id);
  Future<void> resumeDownload(String id) => _service.resumeDownload(id);
  Future<void> deleteDownload(String id) => _service.deleteDownload(id);
}

@Riverpod(keepAlive: true)
Future<DownloadsRepository> downloadsRepository(DownloadsRepositoryRef ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final service = ref.watch(downloadsServiceProvider);
  return DownloadsRepository(db, service);
}
