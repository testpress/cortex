import 'package:drift/drift.dart';

/// Table to track persistent downloads and their statuses.
class DownloadsTable extends Table {
  /// Unique identifier for the download item (e.g. video_id or attachment_id).
  TextColumn get id => text()();

  /// Title of the content.
  TextColumn get title => text()();

  /// Course title this download belongs to.
  TextColumn get course => text()();

  /// Chapter title this download belongs to.
  TextColumn get chapter => text()();

  /// Local file path on the device.
  TextColumn get filePath => text().nullable()();

  /// Total size of the file in bytes.
  Int64Column get sizeInBytes => int64()();

  /// Date the download was initiated/completed.
  TextColumn get downloadedDate => text()();

  /// Type of download (e.g. video, attachment).
  /// Stored as index of DownloadType enum.
  IntColumn get typeIndex => integer()();

  /// Current status (e.g. completed, downloading, paused, error).
  /// Stored as index of DownloadStatus enum.
  IntColumn get statusIndex => integer()();

  /// Download progress (0-100).
  IntColumn get progress => integer().withDefault(const Constant(0))();

  /// Optional thumbnail URL for the content.
  TextColumn get thumbnailUrl => text().nullable()();

  /// Optional duration (for videos).
  TextColumn get duration => text().nullable()();

  /// Optional file extension (e.g. "PDF", "DOC").
  TextColumn get fileType => text().nullable()();

  /// Original download URL, required to safely manage physical file paths.
  TextColumn get contentUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
