import 'dart:convert';
import 'dart:io';
import 'package:core/data/data.dart';
import 'package:drift/drift.dart';

/// Repository for managing private mentoring doubts.
/// Handles syncing between [DataSource] and local [AppDatabase].
class DoubtRepository {
  final DataSource _dataSource;
  final AppDatabase _db;

  DoubtRepository({required DataSource dataSource, required AppDatabase db})
    : _dataSource = dataSource,
      _db = db;

  /// Watch personal doubts for the current user.
  Stream<List<DoubtDto>> watchDoubts() {
    return (_db.select(_db.doubtsTable)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch()
        .map((rows) => rows.map((row) => _mapToDto(row)).toList());
  }

  /// Sync doubts from the remote source for a given page.
  Future<PaginatedResponseDto<DoubtDto>> syncDoubts({
    int page = 1,
    String? searchQuery,
  }) async {
    final response = await _dataSource.getDoubts(
      page: page,
      searchQuery: searchQuery,
    );
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
        _db.doubtsTable,
        response.results.map((dto) => _mapToCompanion(dto)).toList(),
      );
    });
    return response;
  }

  /// Create a new doubt on the server and cache it locally.
  Future<String> createDoubt({
    required String title,
    required String description,
    int? topicId,
    int? chapterContentId,
    int? questionId,
    DoubtQueryType? queryType,
  }) async {
    final response = await _dataSource.createDoubt(
      title: title,
      description: description,
      topicId: topicId,
      chapterContentId: chapterContentId,
      questionId: questionId,
      queryType: queryType == DoubtQueryType.ai ? 2 : 1,
    );
    await _db
        .into(_db.doubtsTable)
        .insertOnConflictUpdate(_mapToCompanion(response));
    return response.id;
  }

  /// Watch replies for a specific doubt thread.
  Stream<List<DoubtReplyDto>> watchReplies(String doubtId) {
    return _db.watchRepliesForDoubt(doubtId).map((rows) {
      return rows.map((row) => _mapReplyToDto(row)).toList();
    });
  }

  /// Sync replies for a specific doubt thread.
  ///
  /// Also upserts the doubt itself from the detail response using a smart merge:
  /// fields like [status], [title], and [content] are updated, but [replyCount]
  /// (which is only available from the list endpoint) is preserved.
  Future<void> syncReplies(String doubtId) async {
    final result = await _dataSource.getDoubtReplies(doubtId);

    // Smart merge: update mutable fields but preserve replyCount from the list endpoint.
    final companion = _mapToCompanion(result.doubt);
    await _db
        .into(_db.doubtsTable)
        .insert(
          companion,
          onConflict: DoUpdate(
            (old) => companion.copyWith(
              replyCount: const Value.absent(),
              createdAt: const Value.absent(),
            ),
            target: [_db.doubtsTable.id],
          ),
        );

    await _db.upsertDoubtReplies(
      result.replies.map((dto) => _mapReplyToCompanion(dto)).toList(),
    );
  }

  /// Fetch replies for a specific doubt thread.
  Future<List<DoubtReplyDto>> getDoubtReplies(String doubtId) async {
    final cached =
        await (_db.select(_db.doubtRepliesTable)
              ..where((t) => t.doubtId.equals(doubtId))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();

    if (cached.isNotEmpty) {
      syncReplies(doubtId).ignore();
      return cached.map((row) => _mapReplyToDto(row)).toList();
    }

    await syncReplies(doubtId);
    return watchReplies(doubtId).first;
  }

  /// Post a new reply comment and update doubt status locally.
  Future<void> postDoubtReply({
    required String doubtId,
    String? comment,
    bool? shouldResolve,
    bool? shouldClose,
  }) async {
    final response = await _dataSource.postDoubtReply(
      doubtId: doubtId,
      comment: comment,
      shouldResolve: shouldResolve,
      shouldClose: shouldClose,
    );

    if (response.id != 'null') {
      await _db
          .into(_db.doubtRepliesTable)
          .insertOnConflictUpdate(_mapReplyToCompanion(response));
    }

    // Update local doubt status/replyCount
    final existing = await (_db.select(
      _db.doubtsTable,
    )..where((t) => t.id.equals(doubtId))).getSingleOrNull();
    if (existing != null) {
      var updatedStatus = existing.status;
      if (shouldResolve == true) {
        updatedStatus = DoubtStatus.resolved.name;
      } else if (shouldClose == true) {
        updatedStatus = DoubtStatus.closed.name;
      }
      await (_db.update(
        _db.doubtsTable,
      )..where((t) => t.id.equals(doubtId))).write(
        DoubtsTableCompanion(
          status: Value(updatedStatus),
          replyCount: Value(
            existing.replyCount != null
                ? existing.replyCount! + (comment != null ? 1 : 0)
                : null,
          ),
        ),
      );
    }

    // Refresh the single doubt thread to pick up backend state changes (e.g., reverting to Active)
    syncReplies(doubtId).ignore();
  }

  /// Watch local topics cache for a parentId.
  Stream<List<DoubtTopicDto>> watchTopics({int? parentId}) {
    final query = _db.select(_db.doubtTopicsTable);
    if (parentId != null) {
      query.where((t) => t.parentId.equals(parentId));
    } else {
      query.where((t) => t.parentId.isNull());
    }
    return query.watch().map((rows) {
      return rows
          .map(
            (row) => DoubtTopicDto(
              id: row.id,
              title: row.title,
              parentId: row.parentId,
              hasChildren: row.hasChildren,
            ),
          )
          .toList();
    });
  }

  /// Fetch and cache doubt topics (categories).
  Future<void> syncTopics({int? parentId}) async {
    final results = await _dataSource.getDoubtTopics();
    await _db.upsertDoubtTopics(
      results
          .map(
            (dto) => DoubtTopicsTableCompanion(
              id: Value(dto.id),
              title: Value(dto.title),
              parentId: Value(dto.parentId),
              hasChildren: Value(dto.hasChildren),
            ),
          )
          .toList(),
    );
  }

  /// Upload an attachment image file for doubts.
  Future<String> uploadDoubtImage(String path, {int? ticketId}) async {
    return _dataSource.uploadDoubtImage(File(path), ticketId: ticketId);
  }

  // --- Mappers ---

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
      createdHumanized: row.createdHumanized,
      source: row.source,
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
      createdHumanized: Value(dto.createdHumanized),
      source: Value(dto.source),
    );
  }

  DoubtDto _mapToDto(DoubtsTableData row) {
    return DoubtDto(
      id: row.id,
      topicId: row.topicId,
      topicName: row.topicName,
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
      createdHumanized: row.createdHumanized,
    );
  }

  DoubtsTableCompanion _mapToCompanion(DoubtDto dto) {
    return DoubtsTableCompanion(
      id: Value(dto.id),
      topicId: Value(dto.topicId),
      topicName: Value(dto.topicName),
      lessonId: Value(dto.lessonId),
      title: Value(dto.title),
      content: Value(dto.content),
      studentName: Value(dto.studentName),
      studentAvatar: Value(dto.studentAvatar),
      replyCount: Value(dto.replyCount),
      status: Value(dto.status.name),
      attachments: Value(jsonEncode(dto.attachmentUrls)),
      createdAt: Value(dto.createdAt),
      createdHumanized: Value(dto.createdHumanized),
    );
  }
}
