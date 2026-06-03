import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/download_item.dart';
import '../../network/file_downloader.dart';

part 'downloads_service.g.dart';

/// Pure worker layer responsible for executing downloads via different SDKs.
/// This class has NO knowledge of the database or DownloadsRepository.
/// All DB writes are coordinated by DownloadsRepository via callbacks.
class DownloadsService {
  final FileDownloader _fileDownloader;

  DownloadsService(this._fileDownloader);

  /// Downloads an attachment file and reports progress via [onProgress].
  /// Returns the local file path on success, or null on failure.
  Future<String?> downloadAttachment(
    String url, {
    void Function(int progressPercent)? onProgress,
  }) async {
    int lastProgress = 0;
    return await _fileDownloader.download(
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
      requireAuth: false, // Signed URLs often fail with Auth headers
    );
  }

  /// Returns the deterministic file path if the file physically exists on disk,
  /// or null if it does not exist.
  Future<String?> getExistingAttachmentPath(String url) async {
    try {
      final path = await _fileDownloader.getLocalPath(url, StorageType.publicDownload);
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
    // Simulate a short IO delay to show the skeleton loader
    await Future.delayed(const Duration(seconds: 2));
    return [..._mockVideoDownloads];
  }

  /// Pauses a video download via the TPStreams SDK.
  /// Replace with real TPStreamsDownloadManager.pauseDownload()
  Future<void> pauseVideoDownload(String id) async {
    // No-op (mock)
  }

  /// Resumes a video download via the TPStreams SDK.
  /// Replace with real TPStreamsDownloadManager.resumeDownload()
  Future<void> resumeVideoDownload(String id) async {
    // No-op (mock)
  }

  /// Deletes a video download via the TPStreams SDK.
  /// Replace with real TPStreamsDownloadManager.deleteDownload()
  Future<void> deleteVideoDownload(String id) async {
    // No-op (mock)
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

  // --- Mock Data ---

  static const _mockVideoDownloads = [
    DownloadItem(
      id: "v1",
      title: "Introduction to Calculus",
      course: "Mathematics - Class 12",
      chapter: "Chapter 5: Continuity and Differentiability",
      sizeInBytes: 130023424,
      downloadedDate: "2 days ago",
      type: DownloadType.video,
      status: DownloadStatus.completed,
      progress: 100,
      duration: "45:20",
      thumbnailUrl: "https://d1j3vi2u94ebt0.cloudfront.net/institute/brilliantpalalms/banners/31e51268d5404650850dbc6d6495867b.jpg",
    ),
    DownloadItem(
      id: "v2",
      title: "Limits and Derivatives",
      course: "Mathematics - Class 11",
      chapter: "Chapter 13: Limits and Derivatives",
      sizeInBytes: 89128960,
      downloadedDate: "Downloading...",
      type: DownloadType.video,
      status: DownloadStatus.downloading,
      progress: 45,
      duration: "32:15",
      thumbnailUrl: "https://d1j3vi2u94ebt0.cloudfront.net/institute/brilliantpalalms/banners/1efd1311adca4dd78c18f18813148ab0.jpg",
    ),
  ];
}

@Riverpod(keepAlive: true)
DownloadsService downloadsService(DownloadsServiceRef ref) {
  final fileDownloader = ref.watch(fileDownloaderProvider);
  return DownloadsService(fileDownloader);
}
