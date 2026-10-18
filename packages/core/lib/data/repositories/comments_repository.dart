import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment_dto.dart';
import '../models/paginated_response_dto.dart';
import '../services/sentry_service.dart';
import '../sources/data_source.dart';
import '../sources/data_source_provider.dart';

/// Repository for managing lesson and content comments.
class CommentsRepository {
  final DataSource _source;
  final SentryService _sentryService;

  CommentsRepository(this._source, this._sentryService);

  /// Fetch paginated comments for a content item.
  Future<PaginatedResponseDto<CommentDto>> fetchComments({
    required String commentsUrl,
    int page = 1,
    String order = '-created',
  }) async {
    try {
      return await _source.getComments(
        commentsUrl: commentsUrl,
        page: page,
        order: order,
      );
    } catch (e, st) {
      _sentryService.captureException(e, stackTrace: st);
      rethrow;
    }
  }

  /// Post a new comment or reply.
  Future<CommentDto> postComment({
    required String commentsUrl,
    required String comment,
    int? parentId,
  }) async {
    try {
      return await _source.createComment(
        commentsUrl: commentsUrl,
        comment: comment,
        parentId: parentId,
      );
    } catch (e, st) {
      _sentryService.captureException(e, stackTrace: st);
      rethrow;
    }
  }

  /// Delete a comment by ID.
  Future<void> deleteComment(int commentId) async {
    try {
      await _source.deleteComment(commentId);
    } catch (e, st) {
      _sentryService.captureException(e, stackTrace: st);
      rethrow;
    }
  }
}

/// Provider for [CommentsRepository].
final commentsRepositoryProvider = Provider<CommentsRepository>((ref) {
  final source = ref.watch(dataSourceProvider);
  final sentryService = ref.watch(sentryServiceProvider);
  return CommentsRepository(source, sentryService);
});
