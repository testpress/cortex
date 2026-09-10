import 'dart:async';
import 'dart:io';
import 'package:background_downloader/background_downloader.dart' as bg;
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../models/download_item.dart';
import '../services/downloads_service.dart';
import '../providers/user_provider.dart';
import 'user_repository.dart';
import '../services/sentry_service.dart';
part 'downloads_repository.g.dart';

/// Orchestrates all download-related operations.
/// Coordinates between [DownloadsService] (network/SDK worker) and
/// [AppDatabase] (local persistence). Mirrors the [AuthRepository] pattern.
class DownloadsRepository {
  final AppDatabase _db;
  final DownloadsService _service;
  final UserRepository _userRepo;
  final SentryService _sentryService;
  final Map<String, DownloadItem> _lastKnownState = {};
  final Set<String> _deletedIds = {};
  StreamSubscription<List<DownloadItem>>? _subscription;
  StreamSubscription<bg.TaskUpdate>? _attachmentSubscription;

  DownloadsRepository(
    this._db,
    this._service,
    this._userRepo,
    this._sentryService,
  ) {
    _initStream();
  }

  void dispose() {
    _subscription?.cancel();
    _attachmentSubscription?.cancel();
  }

  void _initStream() {
    // 1. Video downloads stream from TPStreams SDK
    _subscription = _service.downloadsStream.listen(
      (items) {
        final currentIds = items.map((e) => e.id).toSet();
        _deletedIds.removeWhere((id) => !currentIds.contains(id));

        for (final item in items) {
          if (_deletedIds.contains(item.id)) continue;

          final existing = _lastKnownState[item.id];
          if (existing == null ||
              existing.progress != item.progress ||
              existing.status != item.status ||
              existing.sizeInBytes != item.sizeInBytes ||
              existing.thumbnailUrl != item.thumbnailUrl) {
            final itemToSave = existing != null
                ? item.copyWith(
                    downloadedDate: existing.downloadedDate,
                    thumbnailUrl: item.thumbnailUrl ?? existing.thumbnailUrl,
                  )
                : item;

            _lastKnownState[item.id] = itemToSave;
            upsertDownload(itemToSave).catchError((Object e, StackTrace st) {
              // Ignore or log error without crashing the stream
            });
          }
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        // Handle underlying stream errors safely
      },
    );

    // 2. Attachment & PDF background_downloader updates stream
    _attachmentSubscription = _service.attachmentUpdates.listen((update) async {
      final taskId = update.task.taskId;
      final row = await (_db.select(
        _db.downloadsTable,
      )..where((t) => t.taskId.equals(taskId))).getSingleOrNull();
      if (row == null) return;
      if (_deletedIds.contains(row.id)) return;

      if (update is bg.TaskProgressUpdate) {
        if (update.progress < 0 || update.progress.isNaN) return;

        final currentStatus = DownloadStatus.values[row.statusIndex];
        // If user paused the download, do NOT overwrite the paused state
        if (currentStatus == DownloadStatus.paused) return;

        final percent = (update.progress * 100).toInt().clamp(0, 99);
        if (percent < row.progress) return;

        final expectedSize = update.expectedFileSize > 0
            ? BigInt.from(update.expectedFileSize)
            : row.sizeInBytes;

        await (_db.update(
          _db.downloadsTable,
        )..where((t) => t.id.equals(row.id))).write(
          DownloadsTableCompanion(
            progress: Value(percent),
            sizeInBytes: Value(expectedSize),
          ),
        );
      } else if (update is bg.TaskStatusUpdate) {
        DownloadStatus? newStatus;
        int? finalProgress;
        BigInt? finalSize;
        String? finalFilePath;

        switch (update.status) {
          case bg.TaskStatus.running:
          case bg.TaskStatus.enqueued:
            final currentStatus = DownloadStatus.values[row.statusIndex];
            if (currentStatus != DownloadStatus.paused) {
              newStatus = DownloadStatus.downloading;
            }
            break;
          case bg.TaskStatus.paused:
            newStatus = DownloadStatus.paused;
            break;
          case bg.TaskStatus.complete:
            final isPdf =
                row.fileType?.toUpperCase() == 'PDF' || row.isWatermarked;
            if (isPdf) break;
            newStatus = DownloadStatus.completed;
            finalProgress = 100;
            try {
              final savePath = await update.task.filePath();
              final file = File(savePath);
              if (await file.exists()) {
                finalSize = BigInt.from(await file.length());
                finalFilePath = savePath;
              }
            } catch (e, stackTrace) {
              _sentryService.captureException(
                e,
                stackTrace: stackTrace,
                contexts: {
                  'action': {'name': 'attachmentUpdates.complete'},
                  'task': {'taskId': taskId, 'rowId': row.id},
                },
              );
            }
            break;
          case bg.TaskStatus.failed:
          case bg.TaskStatus.notFound:
            newStatus = DownloadStatus.error;
            break;
          default:
            break;
        }

        if (newStatus != null) {
          await (_db.update(
            _db.downloadsTable,
          )..where((t) => t.id.equals(row.id))).write(
            DownloadsTableCompanion(
              statusIndex: Value(newStatus.index),
              taskId: newStatus == DownloadStatus.completed
                  ? const Value(null)
                  : const Value.absent(),
              progress: finalProgress != null
                  ? Value(finalProgress)
                  : const Value.absent(),
              sizeInBytes: finalSize != null
                  ? Value(finalSize)
                  : const Value.absent(),
              filePath: finalFilePath != null
                  ? Value(finalFilePath)
                  : const Value.absent(),
            ),
          );
        }
      }
    });
  }

  /// Watch all persistent downloads from the DB, mapped to domain models.
  Stream<List<DownloadItem>> watchAllDownloads() {
    return _db.select(_db.downloadsTable).watch().map((rows) {
      return rows
          .map(
            (row) => DownloadItem(
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
              filePath: row.filePath,
              isWatermarked: row.isWatermarked,
              taskId: row.taskId,
            ),
          )
          .toList();
    });
  }

  /// Get a specific download from the DB by ID, mapped to a domain model.
  Future<DownloadItem?> getDownload(String id) async {
    final row = await (_db.select(
      _db.downloadsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return DownloadItem(
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
      filePath: row.filePath,
      isWatermarked: row.isWatermarked,
      taskId: row.taskId,
    );
  }

  /// Watch a specific download from the DB by ID, mapped to a domain model.
  Stream<DownloadItem?> watchDownload(String id) {
    return (_db.select(
      _db.downloadsTable,
    )..where((tbl) => tbl.id.equals(id))).watchSingleOrNull().map((row) {
      if (row == null) return null;
      return DownloadItem(
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
        filePath: row.filePath,
        isWatermarked: row.isWatermarked,
        taskId: row.taskId,
      );
    });
  }

  /// Starts an attachment download and owns the full lifecycle:
  /// insert "downloading" → receive progress updates → write "completed" or "error".
  Future<void> startAttachmentDownload(DownloadItem item, String url) async {
    try {
      await _service.requestNotificationPermission();

      // 0. Check if the file already exists physically on the device.
      final existingSize = await _service.getExistingAttachmentSize(url);
      if (existingSize != null) {
        await upsertDownload(
          item.copyWith(
            status: DownloadStatus.completed,
            progress: 100,
            sizeInBytes: existingSize,
          ),
        );
        return;
      }

      // 1. Assign taskId upfront and persist the initial "downloading" state immediately
      final taskId = item.taskId ?? 'att_${item.id}';
      final itemWithTaskId = item.copyWith(
        taskId: taskId,
        status: DownloadStatus.downloading,
        progress: 0,
      );
      await upsertDownload(itemWithTaskId);

      // Start thumbnail download concurrently with attachment download
      final thumbnailFuture = _downloadThumbnailSafely(item.thumbnailUrl);

      // 2. Delegate download to background_downloader via service
      final enqueued = await _service.downloadAttachment(url, taskId: taskId);

      final localThumbnailPath = await thumbnailFuture;
      if (localThumbnailPath != null) {
        await (_db.update(
          _db.downloadsTable,
        )..where((t) => t.id.equals(item.id))).write(
          DownloadsTableCompanion(thumbnailUrl: Value(localThumbnailPath)),
        );
      }

      if (!enqueued) {
        final currentRow = await (_db.select(
          _db.downloadsTable,
        )..where((t) => t.id.equals(item.id))).getSingleOrNull();
        if (currentRow != null &&
            currentRow.statusIndex != DownloadStatus.paused.index) {
          await upsertDownload(
            item.copyWith(status: DownloadStatus.error, progress: 0),
          );
        }
      }
    } catch (e, stackTrace) {
      _sentryService.captureException(
        e,
        stackTrace: stackTrace,
        contexts: {
          'action': {'name': 'startAttachmentDownload'},
          'item': {'id': item.id, 'title': item.title},
        },
      );
      final currentRow = await (_db.select(
        _db.downloadsTable,
      )..where((t) => t.id.equals(item.id))).getSingleOrNull();
      if (currentRow != null &&
          currentRow.statusIndex != DownloadStatus.paused.index) {
        await upsertDownload(
          item.copyWith(status: DownloadStatus.error, progress: 0),
        );
      }
    }
  }

  /// Starts a PDF download, optionally applying a watermark if enabled.
  Future<void> startWatermarkedPdfDownload(
    DownloadItem item,
    String url, {
    required bool applyWatermark,
  }) async {
    try {
      await _service.requestNotificationPermission();

      final taskId = item.taskId ?? 'pdf_${item.id}';
      final itemWithTaskId = item.copyWith(
        taskId: taskId,
        isWatermarked: applyWatermark,
        fileType: item.fileType ?? 'PDF',
      );
      await upsertDownload(itemWithTaskId);

      // Start thumbnail download concurrently with PDF download
      final thumbnailFuture = _downloadThumbnailSafely(item.thumbnailUrl);

      String? watermarkText;
      if (applyWatermark) {
        final currentUser = await _userRepo.getCurrentProfile();
        watermarkText = currentUser?.username;
        if (watermarkText == null || watermarkText.isEmpty) {
          watermarkText = 'Downloaded';
        }
      }

      final downloadFuture = _service.downloadWatermarkedPdf(
        url: url,
        title: item.title,
        applyWatermark: applyWatermark,
        taskId: taskId,
        watermarkText: watermarkText,
        onProgress: (progressPercent) async {
          final currentRow = await (_db.select(
            _db.downloadsTable,
          )..where((t) => t.id.equals(item.id))).getSingleOrNull();
          if (currentRow != null &&
              currentRow.statusIndex != DownloadStatus.paused.index &&
              progressPercent >= currentRow.progress) {
            await (_db.update(
              _db.downloadsTable,
            )..where((t) => t.id.equals(item.id))).write(
              DownloadsTableCompanion(progress: Value(progressPercent)),
            );
          }
        },
      );

      final results = await Future.wait([downloadFuture, thumbnailFuture]);
      final result = results[0] as (String, int, String);
      final localThumbnailPath = results[1] as String?;
      await upsertDownload(
        itemWithTaskId.copyWith(
          status: DownloadStatus.completed,
          progress: 100,
          sizeInBytes: result.$2,
          filePath: result.$3,
          taskId: null,
          isWatermarked: applyWatermark,
          thumbnailUrl: localThumbnailPath ?? item.thumbnailUrl,
          downloadedDate: DateTime.now().toIso8601String(),
        ),
      );
    } catch (e, stackTrace) {
      await upsertDownload(item.copyWith(status: DownloadStatus.error));
      _sentryService.captureException(
        e,
        stackTrace: stackTrace,
        contexts: {
          'action': {'name': 'startWatermarkedPdfDownload'},
          'downloadItem': {'id': item.id, 'title': item.title},
        },
      );
    }
  }

  Future<String?> _downloadThumbnailSafely(String? url) async {
    if (url == null ||
        (!url.startsWith('http://') && !url.startsWith('https://'))) {
      return null;
    }
    try {
      return await _service.downloadThumbnail(url);
    } catch (e, stackTrace) {
      _sentryService.captureException(
        e,
        stackTrace: stackTrace,
        contexts: {
          'action': {'name': '_downloadThumbnailSafely'},
          'url': {'url': url},
        },
      );
      return null;
    }
  }

  /// Initial synchronization between SDKs and Database.
  Future<void> synchronize() async {
    final activeVideoDownloads = await _service.getActiveVideoDownloads();
    final activeVideoIds = activeVideoDownloads.map((e) => e.id).toList();
    final activeTaskIds = await _service.getActiveAttachmentTaskIds();

    // Verify attachment and PDF files exist on disk
    final dbFiles = await (_db.select(
      _db.downloadsTable,
    )..where((t) => t.typeIndex.equals(DownloadType.attachment.index))).get();

    final activeFileIds = <String>[];
    for (final file in dbFiles) {
      if (file.statusIndex == DownloadStatus.completed.index) {
        bool exists = false;
        if (file.filePath != null) {
          exists = await File(file.filePath!).exists();
        }
        if (!exists && file.contentUrl != null) {
          exists = await _service.verifyAttachmentExists(file.contentUrl!);
        }
        if (exists) {
          activeFileIds.add(file.id);
        }
      } else {
        activeFileIds.add(file.id);

        // If the row was left in downloading state but the background task is no longer
        // running in the OS, reconcile it to paused so the user can tap Resume.
        if (file.statusIndex == DownloadStatus.downloading.index &&
            (file.taskId == null || !activeTaskIds.contains(file.taskId))) {
          await (_db.update(
            _db.downloadsTable,
          )..where((t) => t.id.equals(file.id))).write(
            DownloadsTableCompanion(
              statusIndex: Value(DownloadStatus.paused.index),
            ),
          );
        }
      }
    }

    final activeIds = [...activeVideoIds, ...activeFileIds];

    await _db.batch((batch) {
      // 1. Remove stale records that are no longer active.
      batch.deleteWhere(_db.downloadsTable, (tbl) => tbl.id.isNotIn(activeIds));

      // 2. Sync/Update active video records (attachments are managed directly).
      if (activeVideoDownloads.isNotEmpty) {
        batch.insertAllOnConflictUpdate(
          _db.downloadsTable,
          activeVideoDownloads.map(
            (item) => DownloadsTableCompanion(
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
              filePath: Value(item.filePath),
            ),
          ),
        );
      }
    });
  }

  /// Upserts a [DownloadItem] into the database.
  Future<void> upsertDownload(DownloadItem item) async {
    await _db
        .into(_db.downloadsTable)
        .insertOnConflictUpdate(
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
            filePath: Value(item.filePath),
            isWatermarked: Value(item.isWatermarked),
            taskId: Value(item.taskId),
          ),
        );
  }

  // --- Actions delegated to the service worker then persisted ---

  Future<void> pauseDownload(String id) async {
    final item = await getDownload(id);
    if (item == null) return;

    if (item.type == DownloadType.video) {
      await _service.pauseVideoDownload(id);
    } else if (item.taskId != null) {
      await _service.pauseAttachmentDownload(item.taskId!);
    }

    await (_db.update(
      _db.downloadsTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      DownloadsTableCompanion(statusIndex: Value(DownloadStatus.paused.index)),
    );
  }

  Future<void> resumeDownload(String id) async {
    final item = await getDownload(id);
    if (item == null) return;

    final isPdf = item.fileType?.toUpperCase() == 'PDF' || item.isWatermarked;
    if (item.type == DownloadType.video) {
      await _service.resumeVideoDownload(id);
    } else if (isPdf && item.contentUrl != null) {
      await startWatermarkedPdfDownload(
        item,
        item.contentUrl!,
        applyWatermark: item.isWatermarked,
      );
      return;
    } else if (item.taskId != null && item.contentUrl != null) {
      await _service.resumeAttachmentDownload(item.taskId!, item.contentUrl!);
    }

    await (_db.update(
      _db.downloadsTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      DownloadsTableCompanion(
        statusIndex: Value(DownloadStatus.downloading.index),
      ),
    );
  }

  Future<void> deleteDownload(DownloadItem item) async {
    _deletedIds.add(item.id);
    _lastKnownState.remove(item.id);
    await _service.deleteDownloadItem(item);
    await (_db.delete(
      _db.downloadsTable,
    )..where((tbl) => tbl.id.equals(item.id))).go();
  }

  Future<void> purgeAllDownloads() async {
    final downloads = await _db.select(_db.downloadsTable).get();

    // Guard the stream from re-inserting items while we're deleting them.
    _deletedIds.addAll(downloads.map((r) => r.id));
    _lastKnownState.clear();

    // Service cleanup still needs per-item data to delete the physical files.
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
        filePath: row.filePath,
      );
      await _service.deleteDownloadItem(item);
    }

    // Single bulk DELETE instead of N individual statements.
    await _db.delete(_db.downloadsTable).go();
  }
}

@Riverpod(keepAlive: true)
Future<DownloadsRepository> downloadsRepository(
  DownloadsRepositoryRef ref,
) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final service = ref.watch(downloadsServiceProvider);
  final userRepo = await ref.watch(userRepositoryProvider.future);
  final sentryService = ref.watch(sentryServiceProvider);
  final repo = DownloadsRepository(db, service, userRepo, sentryService);
  ref.onDispose(() => repo.dispose());
  return repo;
}

@riverpod
Stream<DownloadItem?> watchDownloadItem(
  WatchDownloadItemRef ref,
  String id,
) async* {
  final repo = await ref.watch(downloadsRepositoryProvider.future);
  yield* repo.watchDownload(id);
}
