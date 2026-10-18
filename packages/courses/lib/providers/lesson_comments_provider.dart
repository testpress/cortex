import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/data/data.dart';

/// State of comments for a specific lesson content item.
@immutable
class LessonCommentsState {
  final List<CommentDto> flatComments;
  final List<CommentDto> treeComments;
  final int totalCount;
  final PaginationState paginationState;
  final CommentDto? replyingToTarget;
  final bool isSubmitting;
  final bool isLoadingMore;

  const LessonCommentsState({
    this.flatComments = const [],
    this.treeComments = const [],
    this.totalCount = 0,
    this.paginationState = const PaginationState(),
    this.replyingToTarget,
    this.isSubmitting = false,
    this.isLoadingMore = false,
  });

  LessonCommentsState copyWith({
    List<CommentDto>? flatComments,
    List<CommentDto>? treeComments,
    int? totalCount,
    PaginationState? paginationState,
    CommentDto? Function()? replyingToTarget,
    bool? isSubmitting,
    bool? isLoadingMore,
  }) {
    return LessonCommentsState(
      flatComments: flatComments ?? this.flatComments,
      treeComments: treeComments ?? this.treeComments,
      totalCount: totalCount ?? this.totalCount,
      paginationState: paginationState ?? this.paginationState,
      replyingToTarget:
          replyingToTarget != null ? replyingToTarget() : this.replyingToTarget,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Notifier managing comments list, pagination, threading, and mutations.
class LessonCommentsNotifier
    extends StateNotifier<AsyncValue<LessonCommentsState>> {
  final CommentsRepository _repository;
  final String _commentsUrl;
  final PaginationService _paginationService = const PaginationService();

  LessonCommentsNotifier({
    required CommentsRepository repository,
    required String commentsUrl,
  })  : _repository = repository,
        _commentsUrl = commentsUrl,
        super(const AsyncValue.loading()) {
    fetchInitial();
  }

  /// Initial load of comments (page 1, newest first).
  Future<void> fetchInitial() async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.fetchComments(
        commentsUrl: _commentsUrl,
        page: 1,
        order: '-created',
      );
      final paginationState = _paginationService.calculateNextState(
        response: response,
        currentPage: 1,
      );
      final tree = buildCommentTree(response.results);
      state = AsyncValue.data(
        LessonCommentsState(
          flatComments: response.results,
          treeComments: tree,
          totalCount: response.count,
          paginationState: paginationState,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Pull-to-refresh comments list.
  Future<void> refresh() async {
    final current = state.valueOrNull;
    try {
      final response = await _repository.fetchComments(
        commentsUrl: _commentsUrl,
        page: 1,
        order: '-created',
      );
      final paginationState = _paginationService.calculateNextState(
        response: response,
        currentPage: 1,
      );
      final tree = buildCommentTree(response.results);
      state = AsyncValue.data(
        (current ?? const LessonCommentsState()).copyWith(
          flatComments: response.results,
          treeComments: tree,
          totalCount: response.count,
          paginationState: paginationState,
        ),
      );
    } catch (e, st) {
      if (current == null) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  /// Load more comments if subsequent pages are available.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        !current.paginationState.hasMore ||
        current.isLoadingMore) {
      return;
    }

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));
    try {
      final nextPage = current.paginationState.nextPage;
      final response = await _repository.fetchComments(
        commentsUrl: _commentsUrl,
        page: nextPage,
        order: '-created',
      );
      final nextPagination = _paginationService.calculateNextState(
        response: response,
        currentPage: nextPage,
      );
      final combined = [...current.flatComments, ...response.results];
      final tree = buildCommentTree(combined);

      state = AsyncValue.data(
        current.copyWith(
          flatComments: combined,
          treeComments: tree,
          totalCount: response.count,
          paginationState: nextPagination,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      state = AsyncValue.data(current.copyWith(isLoadingMore: false));
    }
  }

  /// Set which comment is currently targeted for a reply (or null for top-level).
  void setReplyTarget(CommentDto? target) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(replyingToTarget: () => target),
    );
  }

  /// Submit a comment or reply.
  Future<CommentDto> postComment(String text) async {
    final current = state.valueOrNull;
    final parentId = current?.replyingToTarget?.id;

    if (current != null) {
      state = AsyncValue.data(current.copyWith(isSubmitting: true));
    }

    try {
      final created = await _repository.postComment(
        commentsUrl: _commentsUrl,
        comment: text,
        parentId: parentId,
      );

      if (state.hasValue) {
        final cur = state.requireValue;
        final updatedFlat = [created, ...cur.flatComments];
        final updatedTree = buildCommentTree(updatedFlat);
        state = AsyncValue.data(
          cur.copyWith(
            flatComments: updatedFlat,
            treeComments: updatedTree,
            totalCount: cur.totalCount + 1,
            replyingToTarget: () => null,
            isSubmitting: false,
          ),
        );
      }

      return created;
    } catch (e) {
      if (state.hasValue) {
        state = AsyncValue.data(
          state.requireValue.copyWith(isSubmitting: false),
        );
      }
      rethrow;
    }
  }

  /// Delete a comment with optimistic UI update and rollback on error.
  Future<void> deleteComment(int commentId) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final previousFlat = current.flatComments;
    final updatedFlat = previousFlat
        .where((c) => c.id != commentId && c.parentId != commentId)
        .toList();
    final updatedTree = buildCommentTree(updatedFlat);

    state = AsyncValue.data(
      current.copyWith(
        flatComments: updatedFlat,
        treeComments: updatedTree,
        totalCount: current.totalCount > 0 ? current.totalCount - 1 : 0,
      ),
    );

    try {
      await _repository.deleteComment(commentId);
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(
        current.copyWith(
          flatComments: previousFlat,
          treeComments: buildCommentTree(previousFlat),
          totalCount: current.totalCount,
        ),
      );
      rethrow;
    }
  }
}

/// Provider family for comments keyed by [commentsUrl].
final lessonCommentsProvider = StateNotifierProvider.autoDispose
    .family<LessonCommentsNotifier, AsyncValue<LessonCommentsState>, String>(
  (ref, commentsUrl) {
    final repository = ref.watch(commentsRepositoryProvider);
    return LessonCommentsNotifier(
      repository: repository,
      commentsUrl: commentsUrl,
    );
  },
);
