import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../models/download_item.dart';
import '../../network/file_downloader.dart';
import 'sentry_service.dart';

part 'downloads_service.g.dart';

/// Pure worker layer responsible for executing downloads via different SDKs.
/// This class has NO knowledge of the database or DownloadsRepository.
/// All DB writes are coordinated by DownloadsRepository via callbacks.
class DownloadsService {
  final FileDownloader _fileDownloader;
  final TPStreamsDownloadManager _downloadManager = TPStreamsDownloadManager();
  final SentryService _sentryService;

  DownloadsService(this._fileDownloader, this._sentryService);

  /// Exposes the live stream of download progress and states mapped to DownloadItem.
  Stream<List<DownloadItem>> get downloadsStream {
    return _downloadManager.downloadsStream.map(
      (assets) => assets.map((a) => _mapAssetToDownloadItem(a)).toList(),
    );
  }

  /// Downloads an attachment file and reports progress via [onProgress].
  /// Returns the final file size in bytes on success, or null on failure.
  Future<int?> downloadAttachment(
    String url, {
    void Function(int progressPercent)? onProgress,
  }) async {
    try {
      int lastProgress = 0;
      final savePath = await _fileDownloader.download(
        url: url,
        type: StorageType.publicDownload,
        onReceiveProgress: (count, total) {
          if (total > 0) {
            final percent = ((count / total) * 100).toInt();
            if (percent != lastProgress) {
              lastProgress = percent;
              onProgress?.call(percent);
            }
          }
        },
        requireAuth: false,
      );

      if (savePath != null) {
        if (Platform.isAndroid) {
          try {
            await MediaScanner.loadMedia(path: savePath);
          } catch (e, stackTrace) {
            _sentryService.captureException(
              e,
              stackTrace: stackTrace,
              level: SentryLevel.warning,
              contexts: {
                'MediaScanner Error': {'savePath': savePath},
              },
            );
          }
        }
        return await File(savePath).length();
      }
      return null;
    } catch (e, stackTrace) {
      _sentryService.captureException(
        e,
        stackTrace: stackTrace,
        contexts: {
          'FileDownloader Error': {'url': url},
        },
      );
      return null;
    }
  }

  /// Checks if the attachment exists and returns its size in bytes.
  /// Triggers MediaScanner if it does. Returns null if missing.
  Future<int?> getExistingAttachmentSize(String url) async {
    final path = await getExistingAttachmentPath(url);
    if (path != null) {
      if (Platform.isAndroid) {
        try {
          await MediaScanner.loadMedia(path: path);
        } catch (e, stackTrace) {
          _sentryService.captureException(
            e,
            stackTrace: stackTrace,
            level: SentryLevel.warning,
            contexts: {
              'MediaScanner Error': {'savePath': path},
            },
          );
        }
      }
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

  /// Fetches all active video downloads from the TPStreams SDK.
  /// Replace mock with real TPStreamsDownloadManager.getAllDownloads()
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
      thumbnailUrl: asset.metadata?['thumbnail_url'],
      sizeInBytes:
          0, // TPStreams does not currently expose total size easily here, we just use 0
      downloadedDate: DateTime.now()
          .toIso8601String(), // Mocked or handled if needed
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
          level: SentryLevel.warning,
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
          level: SentryLevel.warning,
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
      if (item.contentUrl != null) {
        final existingPath = await getExistingAttachmentPath(item.contentUrl!);
        if (existingPath != null) {
          try {
            await File(existingPath).delete();
          } catch (_) {}
        }
      }
    } else {
      await deleteVideoDownload(item.id);
    }
  }
}

@Riverpod(keepAlive: true)
DownloadsService downloadsService(DownloadsServiceRef ref) {
  final fileDownloader = ref.watch(fileDownloaderProvider);
  final sentryService = ref.watch(sentryServiceProvider);
  return DownloadsService(fileDownloader, sentryService);
}
