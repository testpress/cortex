enum DownloadStatus {
  downloading,
  paused,
  completed,
  error,
}

enum DownloadType {
  video,
  attachment,
}

class DownloadItem {
  final String id;
  final String title;
  final String course;
  final String chapter;
  final int sizeInBytes;
  final String downloadedDate;
  final DownloadType type;
  final DownloadStatus status;
  final int progress;
  final String? thumbnailUrl;
  final String? duration;
  final String? fileType;

  const DownloadItem({
    required this.id,
    required this.title,
    required this.course,
    required this.chapter,
    required this.sizeInBytes,
    required this.downloadedDate,
    required this.type,
    required this.status,
    required this.progress,
    this.thumbnailUrl,
    this.duration,
    this.fileType,
  });
}
