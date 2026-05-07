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

  /// Fetch replies for a specific doubt thread.
  Future<List<DoubtReplyDto>> getDoubtReplies(String doubtId) async {
    return _dataSource.getDoubtReplies(doubtId);
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
      timeAgo: row.timeAgo,
      replyCount: row.replyCount,
      status: DoubtStatus.values.firstWhere(
        (s) => s.name == row.status,
        orElse: () => DoubtStatus.pending,
      ),
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
      timeAgo: Value(dto.timeAgo),
      replyCount: Value(dto.replyCount),
      status: Value(dto.status.name),
      createdAt: Value(dto.createdAt),
    );
  }
}
