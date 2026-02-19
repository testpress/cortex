import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../models/forum_thread_dto.dart';
import '../sources/data_source.dart';

/// Repository for forum thread data.
class ForumRepository {
  final AppDatabase _db;
  final DataSource _source;

  ForumRepository(this._db, this._source);

  Stream<List<ForumThreadDto>> watchThreads(String courseId) {
    return _db
        .watchThreadsForCourse(courseId)
        .map((rows) => rows.map(_rowToDto).toList());
  }

  Future<void> refreshThreads(String courseId) async {
    final threads = await _source.getForumThreads(courseId);
    final companions = threads.map(_dtoToCompanion).toList();
    await _db.upsertForumThreads(companions);
  }

  ForumThreadDto _rowToDto(ForumThreadsTableData row) => ForumThreadDto(
    id: row.id,
    courseId: row.courseId,
    title: row.title,
    description: row.description,
    studentName: row.studentName,
    timeAgo: row.timeAgo,
    replyCount: row.replyCount,
    status: row.status == 'answered'
        ? ForumThreadStatus.answered
        : ForumThreadStatus.unanswered,
  );

  ForumThreadsTableCompanion _dtoToCompanion(ForumThreadDto dto) =>
      ForumThreadsTableCompanion.insert(
        id: dto.id,
        courseId: dto.courseId,
        title: dto.title,
        description: dto.description,
        studentName: dto.studentName,
        timeAgo: dto.timeAgo,
        replyCount: Value(dto.replyCount),
        status: dto.status.name,
      );
}
