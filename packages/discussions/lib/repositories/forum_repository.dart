import 'dart:io';

import 'package:drift/drift.dart';
import 'package:core/data/data.dart';

/// Repository for forum thread data.
class ForumRepository {
  final AppDatabase _db;
  final DataSource _source;

  ForumRepository(this._db, this._source);

  // ── Categories ───────────────────────────────────────────────────────────

  Future<List<ForumCategoryDto>> fetchCategories() {
    return _source.getForumCategories();
  }

  // ── Threads ──────────────────────────────────────────────────────────────

  Future<PaginatedResponseDto<ForumThreadDto>> fetchThreads({int page = 1, int? categoryId, String? searchQuery}) async {
    final response = await _source.getForumThreads(page: page, categoryId: categoryId, searchQuery: searchQuery);
    final companions = response.results.map(_dtoToCompanion).toList();
    await _db.upsertForumThreads(companions);
    return response;
  }

  Stream<List<ForumThreadDto>> watchAllThreads() {
    return _db.watchAllThreads().map((rows) => rows.map(_rowToDto).toList());
  }

  Stream<ForumThreadDto?> watchThreadBySlug(String slug) {
    return _db.watchThreadBySlug(slug).map((row) => row != null ? _rowToDto(row) : null);
  }

  @Deprecated('Use watchAllThreads instead')
  Stream<List<ForumThreadDto>> watchThreads(String courseId) {
    return _db
        .watchThreadsForCourse(courseId)
        .map((rows) => rows.map(_rowToDto).toList());
  }

  @Deprecated('Use watchThreadBySlug instead')
  Stream<ForumThreadDto?> watchThread(String threadId) {
    return _db
        .watchThreadById(threadId)
        .map((row) => row != null ? _rowToDto(row) : null);
  }

  // ── Comments ─────────────────────────────────────────────────────────────

  Future<PaginatedResponseDto<ForumCommentDto>> fetchComments({required int threadId, int page = 1}) async {
    final response = await _source.getForumComments(threadId: threadId, page: page);
    final companions = response.results.map(_commentDtoToCompanion).toList();
    await _db.upsertForumComments(companions);
    return response;
  }

  Stream<List<ForumCommentDto>> watchComments(int threadId) {
    return _db
        .watchCommentsForThread(threadId)
        .map((rows) => rows.map(_commentRowToDto).toList());
  }

  Future<ForumCommentDto> postComment({required int threadId, required String content}) async {
    final commentDto = await _source.postForumComment(threadId: threadId, content: content);
    final companion = _commentDtoToCompanion(commentDto);
    await _db.upsertForumComments([companion]);
    return commentDto;
  }

  Future<String> uploadImage(File file) {
    return _source.uploadImage(file);
  }

  Future<ForumThreadDto> createThread({
    required String title,
    required String html,
    required String categorySlug,
    String? courseId,
  }) async {
    final threadDto = await _source.postForumThread(
      title: title,
      contentHtml: html,
      categorySlug: categorySlug,
      courseId: courseId,
    );
    await _db.upsertForumThreads([_dtoToCompanion(threadDto)]);
    return threadDto;
  }

  // ── Mappers ──────────────────────────────────────────────────────────────

  ForumThreadDto _rowToDto(ForumThreadsTableData row) => ForumThreadDto(
        threadId: row.threadId ?? 0,
        slug: row.id,
        courseId: row.courseId,
        categoryId: null,
        categorySlug: row.categorySlug,
        title: row.title,
        summary: row.description,
        authorName: row.authorName,
        authorAvatar: row.authorAvatar,
        createdAt: row.createdAt,
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
        id: dto.slug,
        courseId: Value(dto.courseId),
        threadId: Value(dto.threadId),
        title: dto.title,
        description: dto.summary,
        authorName: dto.authorName,
        authorAvatar: Value(dto.authorAvatar),
        createdAt: dto.createdAt,
        replyCount: Value(dto.replyCount),
        upvotes: Value(dto.upvotes),
        downvotes: Value(dto.downvotes),
        status: dto.status.name,
        imageUrl: Value(dto.imageUrl),
        categorySlug: Value(dto.categorySlug),
      );

  ForumCommentDto _commentRowToDto(ForumCommentsTableData row) => ForumCommentDto(
        id: row.id,
        threadId: row.threadId,
        authorName: row.authorName,
        authorAvatar: row.authorAvatar,
        content: row.content,
        createdAt: row.createdAt,
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
        createdAt: dto.createdAt,
        upvotes: Value(dto.upvotes),
        downvotes: Value(dto.downvotes),
        isInstructor: Value(dto.isInstructor),
      );
}
