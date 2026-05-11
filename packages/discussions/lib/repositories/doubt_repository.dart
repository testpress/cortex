import 'dart:convert';
import 'package:core/data/data.dart';
import 'package:drift/drift.dart';

/// Repository for managing private mentoring doubts.
/// Handles syncing between [DataSource] and local [AppDatabase].
class DoubtRepository {
  final DataSource _dataSource;
  final AppDatabase _db;

  DoubtRepository({
    required DataSource dataSource,
    required AppDatabase db,
  })  : _dataSource = dataSource,
        _db = db;

  /// Watch personal doubts for the current user.
  Stream<List<DoubtDto>> watchDoubts() {
    return _db.select(_db.doubtsTable).watch().map((rows) {
      return rows.map((row) => _mapToDto(row)).toList();
    });
  }

  /// Sync doubts from the remote source.
  Future<void> syncDoubts() async {
    final results = await _dataSource.getDoubts();
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
        _db.doubtsTable,
        results.map((dto) => _mapToCompanion(dto)).toList(),
      );
    });
  }

  /// Create a new doubt locally.
  Future<void> createDoubt(DoubtDto doubt) async {
    // Mock network delay
    await Future.delayed(const Duration(seconds: 1));
    
    await _db.into(_db.doubtsTable).insert(_mapToCompanion(doubt));
  }

  /// Watch replies for a specific doubt thread.
  Stream<List<DoubtReplyDto>> watchReplies(String doubtId) {
    return _db.watchRepliesForDoubt(doubtId).map((rows) {
      return rows.map((row) => _mapReplyToDto(row)).toList();
    });
  }

  /// Sync replies for a specific doubt thread.
  Future<void> syncReplies(String doubtId) async {
    final results = await _dataSource.getDoubtReplies(doubtId);
    await _db.upsertDoubtReplies(
      results.map((dto) => _mapReplyToCompanion(dto)).toList(),
    );
  }

  /// Fetch replies for a specific doubt thread.
  Future<List<DoubtReplyDto>> getDoubtReplies(String doubtId) async {
    // Return cached data if available, while syncing in the background
    final cached = await (_db.select(_db.doubtRepliesTable)
          ..where((t) => t.doubtId.equals(doubtId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();

    if (cached.isNotEmpty) {
      // Background sync
      syncReplies(doubtId).ignore();
      return cached.map((row) => _mapReplyToDto(row)).toList();
    }

    await syncReplies(doubtId);
    return watchReplies(doubtId).first;
  }

  DoubtReplyDto _mapReplyToDto(DoubtRepliesTableData row) {
    return DoubtReplyDto(
      id: row.id,
      doubtId: row.doubtId,
      content: row.content,
      authorName: row.authorName,
      authorAvatar: row.authorAvatar,
      isMentor: row.isMentor,
      attachmentUrls: row.attachments != null
          ? List<String>.from(jsonDecode(row.attachments!))
          : [],
      createdAt: row.createdAt,
    );
  }

  DoubtRepliesTableCompanion _mapReplyToCompanion(DoubtReplyDto dto) {
    return DoubtRepliesTableCompanion(
      id: Value(dto.id),
      doubtId: Value(dto.doubtId),
      content: Value(dto.content),
      authorName: Value(dto.authorName),
      authorAvatar: Value(dto.authorAvatar),
      isMentor: Value(dto.isMentor),
      attachments: Value(jsonEncode(dto.attachmentUrls)),
      createdAt: Value(dto.createdAt),
    );
  }

  DoubtDto _mapToDto(DoubtsTableData row) {
    return DoubtDto(
      id: row.id,
      courseId: row.courseId,
      courseName: row.courseName,
      lessonId: row.lessonId,
      title: row.title,
      content: row.content,
      studentName: row.studentName,
      studentAvatar: row.studentAvatar,
      replyCount: row.replyCount,
      status: DoubtStatus.values.firstWhere(
        (s) => s.name == row.status,
        orElse: () => DoubtStatus.pending,
      ),
      attachmentUrls: row.attachments != null
          ? List<String>.from(jsonDecode(row.attachments!))
          : [],
      createdAt: row.createdAt,
    );
  }

  DoubtsTableCompanion _mapToCompanion(DoubtDto dto) {
    return DoubtsTableCompanion(
      id: Value(dto.id),
      courseId: Value(dto.courseId),
      courseName: Value(dto.courseName),
      lessonId: Value(dto.lessonId),
      title: Value(dto.title),
      content: Value(dto.content),
      studentName: Value(dto.studentName),
      studentAvatar: Value(dto.studentAvatar),
      replyCount: Value(dto.replyCount),
      status: Value(dto.status.name),
      attachments: Value(jsonEncode(dto.attachmentUrls)),
      createdAt: Value(dto.createdAt),
    );
  }
}
