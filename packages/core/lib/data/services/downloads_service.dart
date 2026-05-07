import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/download_item.dart';

part 'downloads_service.g.dart';

/// Single integration layer responsible for coordinating between different SDKs
/// (Player SDK, Attachment Manager) and the rest of the app.
class DownloadsService {
  /// Fetches all active downloads from the various SDKs.
  Future<List<DownloadItem>> getActiveDownloads() async {
    // Simulate a short network/IO delay to show the skeleton loader
    await Future.delayed(const Duration(seconds: 2));
    // Return mock data directly from the service
    return [..._mockVideoDownloads, ..._mockAttachmentDownloads];
  }

  /// Starts a new download.
  Future<void> startDownload(DownloadItem item) async {
    // No-op
  }

  /// Pauses an active download.
  Future<void> pauseDownload(String id) async {
    // No-op
  }

  /// Resumes a paused download.
  Future<void> resumeDownload(String id) async {
    // No-op
  }

  /// Deletes a download from the SDK and disk.
  Future<void> deleteDownload(String id) async {
    // No-op
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

  static const _mockAttachmentDownloads = [
    DownloadItem(
      id: "a1",
      title: "Formula Sheet - Calculus",
      course: "Mathematics - Class 12",
      chapter: "Chapter 5: Continuity and Differentiability",
      sizeInBytes: 1572864,
      downloadedDate: "3 days ago",
      type: DownloadType.attachment,
      fileType: "PDF",
      status: DownloadStatus.completed,
      progress: 100,
      thumbnailUrl: "https://d1j3vi2u94ebt0.cloudfront.net/institute/brilliantpalalms/banners/ffd05ad8baad4f4c96d08825536f9e24.jpeg",
    ),
  ];
}

@Riverpod(keepAlive: true)
DownloadsService downloadsService(DownloadsServiceRef ref) {
  return DownloadsService();
}
