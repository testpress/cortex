import 'dart:async';
import 'dart:io';
import 'package:background_downloader/background_downloader.dart' as bg;
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import '../models/download_item.dart';
import '../../network/file_downloader.dart';
import 'sentry_service.dart';
import 'pdf_downloader.dart';

part 'downloads_service.g.dart';

/// Pure worker layer responsible for executing downloads via different SDKs.
/// This class has NO knowledge of the database or DownloadsRepository.
/// All DB writes are coordinated by DownloadsRepository via callbacks.
///
/// Download engines:
///   • Video  — TPStreamsDownloadManager (ExoPlayer / AVAssetDownloadTask)
///   • Attachment / PDF fetch — BackgroundDownloader (WorkManager / URLSession)
///   • Thumbnails / internal cache — FileDownloader (Dio, unchanged)
class DownloadsService {
  final FileDownloader _fileDownloader;
  final TPStreamsDownloadManager _downloadManager = TPStreamsDownloadManager();
  final SentryService _sentryService;
  late final PdfDownloader _pdfDownloader;
  late final Stream<bg.TaskUpdate> attachmentUpdates;

  DownloadsService(this._fileDownloader, this._sentryService) {
    _initBackgroundDownloader();
    attachmentUpdates = bg.FileDownloader().updates.asBroadcastStream();
    _pdfDownloader = PdfDownloader(_fileDownloader, attachmentUpdates);
  }

  /// Initialise the background_downloader plugin with notification configuration.
  void _initBackgroundDownloader() {
    bg.FileDownloader().configureNotification(
      running: const bg.TaskNotification(
        'Downloading',
        '{filename} • {progress}',
      ),
      paused: const bg.TaskNotification(
        'Download paused',
        '{filename} • {progress}',
      ),
      complete: const bg.TaskNotification(
        'Download complete',
        '{filename} downloaded',
      ),
      error: const bg.TaskNotification('Download failed', '{filename}'),
      progressBar: true,
      tapOpensFile: true,
    );
  }

  /// Requests notification permission on Android 13+ (POST_NOTIFICATIONS) and iOS.
  Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        final status = await Permission.notification.status;
        if (!status.isGranted) {
          await Permission.notification.request();
        }
      } catch (e, st) {
        _sentryService.captureException(
          e,
          stackTrace: st,
          level: AppErrorLevel.warning,
          contexts: {
            'DownloadsService': {'action': 'requestNotificationPermission'},
          },
        );
      }
    }
  }

  // ── Attachment downloads (background_downloader) ──────────────────────────

  /// Enqueues an attachment download using background_downloader for
  /// pause/resume support.
  Future<bool> downloadAttachment(String url, {required String taskId}) async {
    final savePath = await _fileDownloader.getLocalPath(
      url,
      StorageType.publicDownload,
    );
    final filename = savePath.split('/').last;

    final task = bg.DownloadTask(
      taskId: taskId,
      url: url,
      filename: filename,
      baseDirectory: bg.BaseDirectory.applicationDocuments,
      updates: bg.Updates.statusAndProgress,
      allowPause: true,
      retries: 0,
    );

    try {
      return await bg.FileDownloader().enqueue(task);
    } catch (e, st) {
      _sentryService.captureException(
        e,
        stackTrace: st,
        contexts: {
          'BackgroundDownloader Error': {'url': url, 'taskId': taskId},
        },
      );
      return false;
    }
  }

  /// Pauses an in-progress attachment download by its [taskId].
  Future<void> pauseAttachmentDownload(String taskId) async {
    final tasks = (await bg.FileDownloader().allTasks())
        .whereType<bg.DownloadTask>();
    final task = tasks.where((t) => t.taskId == taskId).firstOrNull;
    if (task != null) {
      try {
        await bg.FileDownloader().pause(task);
      } catch (e, st) {
        _sentryService.captureException(
          e,
          stackTrace: st,
          level: AppErrorLevel.warning,
          tags: {'action': 'pauseAttachment', 'taskId': taskId},
        );
      }
    }
  }

  /// Resumes a paused attachment download.
  ///
  /// Reconstructs the task from [taskId] + [url] and re-enqueues it so
  /// background_downloader can issue a Range request from the saved offset.
  Future<void> resumeAttachmentDownload(String taskId, String url) async {
    // First try to resume via the plugin's stored pause data
    final tasks = (await bg.FileDownloader().allTasks())
        .whereType<bg.DownloadTask>();
    final existingTask = tasks.where((t) => t.taskId == taskId).firstOrNull;

    try {
      if (existingTask != null) {
        await bg.FileDownloader().resume(existingTask);
      } else {
        final savePath = await _fileDownloader.getLocalPath(
          url,
          StorageType.publicDownload,
        );
        final filename = savePath.split('/').last;

        final task = bg.DownloadTask(
          taskId: taskId,
          url: url,
          filename: filename,
          baseDirectory: bg.BaseDirectory.applicationDocuments,
          updates: bg.Updates.statusAndProgress,
          allowPause: true,
          retries: 0,
        );
        await bg.FileDownloader().resume(task);
      }
    } catch (e, st) {
      _sentryService.captureException(
        e,
        stackTrace: st,
        level: AppErrorLevel.warning,
        tags: {'action': 'resumeAttachment', 'taskId': taskId},
      );
    }
  }

  /// Returns the set of active task IDs currently tracked by background_downloader.
  Future<Set<String>> getActiveAttachmentTaskIds() async {
    try {
      final tasks = await bg.FileDownloader().allTasks();
      return tasks.map((t) => t.taskId).toSet();
    } catch (e, st) {
      _sentryService.captureException(
        e,
        stackTrace: st,
        level: AppErrorLevel.warning,
        contexts: {
          'DownloadsService': {'action': 'getActiveAttachmentTaskIds'},
        },
      );
      return {};
    }
  }

  // ── PDF downloads ─────────────────────────────────────────────────────────

  /// Delegates PDF downloading and watermarking to the PdfDownloader service.
  /// Saves the watermarked PDF in app documents storage.
  Future<(String, int, String)> downloadWatermarkedPdf({
    required String url,
    required String title,
    required bool applyWatermark,
    String? taskId,
    String? watermarkText,
    void Function(int progressPercent)? onProgress,
  }) async {
    return await _pdfDownloader.downloadAndWatermark(
      url: url,
      title: title,
      applyWatermark: applyWatermark,
      taskId: taskId,
      watermarkText: watermarkText,
      onProgress: onProgress,
    );
  }

  // ── Video downloads (TPStreams SDK) ───────────────────────────────────────

  /// Exposes the live stream of download progress and states mapped to DownloadItem.
  Stream<List<DownloadItem>> get downloadsStream {
    return _downloadManager.downloadsStream.map(
      (assets) => assets.map((a) => _mapAssetToDownloadItem(a)).toList(),
    );
  }

  /// Fetches all active video downloads from the TPStreams SDK.
  Future<List<DownloadItem>> getActiveVideoDownloads() async {
    final assets = await _downloadManager.getAllDownloads();
    return assets.map((asset) => _mapAssetToDownloadItem(asset)).toList();
  }

  DownloadItem _mapAssetToDownloadItem(DownloadAsset asset) {
    return DownloadItem(
      id: asset.assetId,
      title: asset.title ?? 'Untitled Video',
      course: asset.metadata?['course'] ?? '',
      chapter: asset.metadata?['chapter'] ?? '',
      thumbnailUrl: asset.thumbnailUrl ?? asset.metadata?['thumbnail_url'],
      sizeInBytes: asset.totalSize > 0 ? asset.totalSize : asset.downloadedSize,
      downloadedDate: DateTime.now().toIso8601String(),
      type: DownloadType.video,
      status: _mapDownloadState(asset.state),
      progress: asset.progress.toInt(),
    );
  }

  DownloadStatus _mapDownloadState(DownloadState state) {
    switch (state) {
      case DownloadState.notDownloaded:
        return DownloadStatus.error;
      case DownloadState.downloading:
        return DownloadStatus.downloading;
      case DownloadState.paused:
        return DownloadStatus.paused;
      case DownloadState.completed:
        return DownloadStatus.completed;
      case DownloadState.failed:
        return DownloadStatus.error;
    }
  }

  /// Pauses a video download via the TPStreams SDK.
  Future<void> pauseVideoDownload(String id) async {
    final assets = await _downloadManager.getAllDownloads();
    final asset = assets.where((a) => a.assetId == id).firstOrNull;
    if (asset != null) {
      try {
        await _downloadManager.pauseDownload(asset);
      } catch (e, stackTrace) {
        _sentryService.captureException(
          e,
          stackTrace: stackTrace,
          level: AppErrorLevel.warning,
          tags: {'action': 'pause'},
        );
      }
    }
  }

  /// Resumes a video download via the TPStreams SDK.
  Future<void> resumeVideoDownload(String id) async {
    final assets = await _downloadManager.getAllDownloads();
    final asset = assets.where((a) => a.assetId == id).firstOrNull;
    if (asset != null) {
      try {
        await _downloadManager.resumeDownload(asset);
      } catch (e, stackTrace) {
        _sentryService.captureException(
          e,
          stackTrace: stackTrace,
          level: AppErrorLevel.warning,
          tags: {'action': 'resume'},
        );
      }
    }
  }

  /// Deletes a video download via the TPStreams SDK.
  Future<void> deleteVideoDownload(String id) async {
    final assets = await _downloadManager.getAllDownloads();
    final asset = assets.where((a) => a.assetId == id).firstOrNull;
    if (asset != null) {
      await _downloadManager.deleteDownload(asset);
    }
  }

  Future<void> deleteDownloadItem(DownloadItem item) async {
    if (item.type == DownloadType.attachment) {
      if (item.filePath != null) {
        try {
          final file = File(item.filePath!);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e, st) {
          _sentryService.captureException(
            e,
            stackTrace: st,
            level: AppErrorLevel.error,
            contexts: {
              'DownloadService': {
                'action': 'deleteDownloadItem',
                'filePath': item.filePath,
              },
            },
          );
        }
      } else if (item.contentUrl != null) {
        final existingPath = await getExistingAttachmentPath(item.contentUrl!);
        if (existingPath != null) {
          try {
            await File(existingPath).delete();
          } catch (_) {}
        }
      }

      // Cancel any in-flight background_downloader task for this item
      if (item.taskId != null) {
        try {
          await bg.FileDownloader().cancelTaskWithId(item.taskId!);
        } catch (_) {}
      }
    } else {
      await deleteVideoDownload(item.id);
    }
  }

  // ── Thumbnails & path helpers (Dio — unchanged) ───────────────────────────

  /// Downloads a thumbnail image to internal app cache so it is accessible offline.
  Future<String?> downloadThumbnail(String url) async {
    try {
      return await _fileDownloader.download(
        url: url,
        type: StorageType.internalCache,
        requireAuth: false,
      );
    } catch (e, stackTrace) {
      _sentryService.captureException(
        e,
        stackTrace: stackTrace,
        level: AppErrorLevel.warning,
        contexts: {
          'Thumbnail Download Error': {'url': url},
        },
      );
      return null;
    }
  }

  /// Checks if the attachment exists and returns its size in bytes.
  /// Returns null if missing.
  Future<int?> getExistingAttachmentSize(String url) async {
    final path = await getExistingAttachmentPath(url);
    if (path != null) {
      return await File(path).length();
    }
    return null;
  }

  /// Returns the deterministic file path if the file physically exists on disk,
  /// or null if it does not exist.
  Future<String?> getExistingAttachmentPath(String url) async {
    try {
      final path = await _fileDownloader.getLocalPath(
        url,
        StorageType.publicDownload,
      );
      if (await File(path).exists()) return path;
    } catch (_) {}
    return null;
  }

  /// Verifies if an attachment file physically exists on the device.
  Future<bool> verifyAttachmentExists(String url) async {
    return (await getExistingAttachmentPath(url)) != null;
  }
}

@Riverpod(keepAlive: true)
DownloadsService downloadsService(DownloadsServiceRef ref) {
  final fileDownloader = ref.watch(fileDownloaderProvider);
  final sentryService = ref.watch(sentryServiceProvider);
  return DownloadsService(fileDownloader, sentryService);
}
