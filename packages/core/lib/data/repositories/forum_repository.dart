import 'package:drift/drift.dart';
import 'package:core/data/data.dart';

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

  Future<int> getThreadsCount(String courseId) async {
    final results = await _db.watchThreadsForCourse(courseId).first;
    return results.length;
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
        authorName: row.authorName,
        authorAvatar: row.authorAvatar,
        timeAgo: row.timeAgo,
        replyCount: row.replyCount,
        upvotes: row.upvotes,
        downvotes: row.downvotes,
        status: row.status == 'answered'
            ? ForumThreadStatus.answered
            : ForumThreadStatus.unanswered,
        imageUrl: row.imageUrl,
      );

  ForumThreadsTableCompanion _dtoToCompanion(ForumThreadDto dto) =>
      ForumThreadsTableCompanion.insert(
        id: dto.id,
        courseId: dto.courseId,
        title: dto.title,
        description: dto.description,
        authorName: dto.authorName,
        authorAvatar: Value(dto.authorAvatar),
        timeAgo: dto.timeAgo,
        replyCount: Value(dto.replyCount),
        upvotes: Value(dto.upvotes),
        downvotes: Value(dto.downvotes),
        status: dto.status.name,
        imageUrl: Value(dto.imageUrl),
      );

  // ── Comments ─────────────────────────────────────────────────────────────

  Stream<List<ForumCommentDto>> watchComments(String threadId) {
    return _db
        .watchCommentsForThread(threadId)
        .map((rows) => rows.map(_commentRowToDto).toList());
  }

  Future<void> refreshComments(String threadId) async {
    final comments = await _source.getForumComments(threadId);
    final companions = comments.map(_commentDtoToCompanion).toList();
    await _db.upsertForumComments(companions);
  }

  ForumCommentDto _commentRowToDto(ForumCommentsTableData row) => ForumCommentDto(
        id: row.id,
        threadId: row.threadId,
        authorName: row.authorName,
        authorAvatar: row.authorAvatar,
        content: row.content,
        timeAgo: row.timeAgo,
        upvotes: row.upvotes,
        downvotes: row.downvotes,
        isInstructor: row.isInstructor,
      );

  ForumCommentsTableCompanion _commentDtoToCompanion(ForumCommentDto dto) =>
      ForumCommentsTableCompanion.insert(
        id: dto.id,
        threadId: dto.threadId,
        authorName: dto.authorName,
        authorAvatar: Value(dto.authorAvatar),
        content: dto.content,
        timeAgo: dto.timeAgo,
        upvotes: Value(dto.upvotes),
        downvotes: Value(dto.downvotes),
        isInstructor: Value(dto.isInstructor),
      );
}
