enum DownloadStatus { downloading, paused, completed, error }

enum DownloadType { video, attachment }

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
  final String? contentUrl;

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
    this.contentUrl,
  });

  DownloadItem copyWith({
    String? id,
    String? title,
    String? course,
    String? chapter,
    int? sizeInBytes,
    String? downloadedDate,
    DownloadType? type,
    DownloadStatus? status,
    int? progress,
    String? thumbnailUrl,
    String? duration,
    String? fileType,
    String? contentUrl,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      chapter: chapter ?? this.chapter,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      downloadedDate: downloadedDate ?? this.downloadedDate,
      type: type ?? this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      fileType: fileType ?? this.fileType,
      contentUrl: contentUrl ?? this.contentUrl,
    );
  }
}
