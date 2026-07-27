import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import '../models/download_item.dart';
import '../../network/file_downloader.dart';
import 'sentry_service.dart';
import 'pdf_downloader.dart';

part 'downloads_service.g.dart';

/// Pure worker layer responsible for executing downloads via different SDKs.
/// This class has NO knowledge of the database or DownloadsRepository.
/// All DB writes are coordinated by DownloadsRepository via callbacks.
class DownloadsService {
  final FileDownloader _fileDownloader;
  final TPStreamsDownloadManager _downloadManager = TPStreamsDownloadManager();
  final SentryService _sentryService;
  final PdfDownloader _pdfDownloader;

  DownloadsService(
    this._fileDownloader,
    this._sentryService,
    this._pdfDownloader,
  );

  /// Delegates PDF downloading and watermarking to the PdfDownloader service.
  /// Also triggers MediaScanner so the file shows up in the public Downloads directory.
  Future<(int, String)> downloadWatermarkedPdf({
    required String url,
    required String title,
    required bool applyWatermark,
    String? watermarkText,
    void Function(int progressPercent)? onProgress,
  }) async {
    final result = await _pdfDownloader.downloadAndWatermark(
      url: url,
      title: title,
      applyWatermark: applyWatermark,
      watermarkText: watermarkText,
      onProgress: onProgress,
    );

    // Scan it so it shows in the Android File Manager immediately
    await scanMediaIfAndroid(result.$2);

    return result;
  }

  /// Exposes the live stream of download progress and states mapped to DownloadItem.
  Stream<List<DownloadItem>> get downloadsStream {
    return _downloadManager.downloadsStream.map(
      (assets) => assets.map((a) => _mapAssetToDownloadItem(a)).toList(),
    );
  }

  /// Scans a file with the Android MediaScanner so it appears in public galleries/downloads.
  Future<void> scanMediaIfAndroid(String path) async {
    if (!Platform.isAndroid) return;

    try {
      await MediaScanner.loadMedia(path: path);
    } catch (e, stackTrace) {
      _sentryService.captureException(
        e,
        stackTrace: stackTrace,
        level: AppErrorLevel.warning,
        contexts: {
          'MediaScanner Error': {'savePath': path},
        },
      );
    }
  }

  /// Downloads an attachment file and reports progress via [onProgress].
  /// Returns the final file size in bytes and path on success, or null on failure.
  Future<(int, String)?> downloadAttachment(
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
        await scanMediaIfAndroid(savePath);
        return (await File(savePath).length(), savePath);
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
      await scanMediaIfAndroid(path);
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

  /// Checks if a watermarked PDF exists on disk using the title-based path
  /// that [PdfDownloader] uses to save files (i.e. `$title.pdf`).
  /// Returns the file size in bytes if found, or null if the file is missing.
  Future<int?> getExistingPdfSize(String title) async {
    try {
      final dir = await _fileDownloader.getDirectory(
        StorageType.publicDownload,
      );
      final path = '${dir.path}/${PdfDownloader.safeTitle(title)}.pdf';
      final file = File(path);
      if (await file.exists()) return await file.length();
    } catch (_) {}
    return null;
  }

  /// Deletes a cached PDF file based on its title if it exists.
  Future<void> deleteExistingPdf(String title) async {
    try {
      final dir = await _fileDownloader.getDirectory(
        StorageType.publicDownload,
      );
      final path = '${dir.path}/${PdfDownloader.safeTitle(title)}.pdf';
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
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
      // For both normal attachments and PDFs, the type is now attachment.
      // If it's a PDF, we might have a direct filePath in the item.
      if (item.filePath != null) {
        try {
          final file = File(item.filePath!);
          if (await file.exists()) {
            await file.delete();
            await scanMediaIfAndroid(item.filePath!);
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
            await scanMediaIfAndroid(existingPath);
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
  final pdfDownloader = PdfDownloader(fileDownloader);
  return DownloadsService(fileDownloader, sentryService, pdfDownloader);
}
