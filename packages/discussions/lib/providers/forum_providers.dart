import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../repositories/forum_repository.dart';

part 'forum_providers.g.dart';

@Riverpod(keepAlive: true)
Future<ForumRepository> forumRepository(ForumRepositoryRef ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return ForumRepository(db, source);
}

final globalForumThreadDetailProvider =
    StreamProvider.family<ForumThreadDto?, String>((ref, slug) async* {
      final repo = await ref.watch(forumRepositoryProvider.future);
      yield* repo.watchThreadBySlug(slug);
    });

final globalForumCommentsProvider =
    StreamProvider.family<List<ForumCommentDto>, int>((ref, threadId) async* {
      final repo = await ref.watch(forumRepositoryProvider.future);

      final localData = await repo.watchComments(threadId).first;
      final fetchFuture = repo.fetchComments(threadId: threadId);

      if (localData.isEmpty) {
        try {
          await fetchFuture;
        } catch (_) {
          // Ignore network errors so the provider doesn't crash
        }
      } else {
        fetchFuture.ignore();
      }

      yield* repo.watchComments(threadId);
    });

@riverpod
class PostForumComment extends _$PostForumComment {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required int threadId,
    required String content,
    List<String> attachments = const [],
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(forumRepositoryProvider.future);

      String finalContent = content;

      if (attachments.isNotEmpty) {
        final uploadFutures = attachments.map(
          (path) => repo.uploadImage(File(path)),
        );
        final urls = await Future.wait(uploadFutures);

        for (final url in urls) {
          finalContent += '<br><img src="$url" />';
        }
      }

      await repo.postComment(threadId: threadId, content: finalContent);
      ref.invalidate(globalForumCommentsProvider(threadId));
    });
  }
}

@riverpod
class CreateForumThread extends _$CreateForumThread {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String title,
    required String content,
    required String categorySlug,
    String? courseId,
    List<String> attachments = const [],
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(forumRepositoryProvider.future);

      String finalContent = content;

      if (attachments.isNotEmpty) {
        final uploadFutures = attachments.map(
          (path) => repo.uploadImage(File(path)),
        );
        final urls = await Future.wait(uploadFutures);

        for (final url in urls) {
          finalContent += '<br><img src="$url" />';
        }
      }

      await repo.createThread(
        title: title,
        html: finalContent,
        categorySlug: categorySlug,
        courseId: courseId,
      );

      ref.invalidate(globalForumFeedProvider);
    });
  }
}

// ── Global Providers ────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
Future<List<ForumCategoryDto>> globalForumCategories(
  GlobalForumCategoriesRef ref,
) async {
  final repo = await ref.watch(forumRepositoryProvider.future);
  return repo.fetchCategories();
}

@riverpod
class GlobalForumFeed extends _$GlobalForumFeed {
  @override
  Future<GlobalForumFeedState> build({
    int? categoryId,
    String? searchQuery,
  }) async {
    if (searchQuery == null || searchQuery.isEmpty) {
      ref.keepAlive();
    }
    final repo = await ref.watch(forumRepositoryProvider.future);
    final response = await repo.fetchThreads(
      categoryId: categoryId,
      searchQuery: searchQuery,
    );
    final nextPage = _extractPageNumber(response.next);
    return GlobalForumFeedState(
      items: response.results,
      nextPage: nextPage,
      hasMore: nextPage != null,
    );
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null ||
        !currentState.hasMore ||
        currentState.isLoadingMore)
      return;

    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    final repo = await ref.read(forumRepositoryProvider.future);
    final response = await repo.fetchThreads(
      page: currentState.nextPage!,
      categoryId: categoryId,
      searchQuery: searchQuery,
    );

    final existingIds = currentState.items.map((t) => t.threadId).toSet();
    final newItems = response.results
        .where((t) => !existingIds.contains(t.threadId))
        .toList();

    final nextPage = _extractPageNumber(response.next);
    state = AsyncData(
      GlobalForumFeedState(
        items: [...currentState.items, ...newItems],
        nextPage: nextPage,
        hasMore: nextPage != null,
        isInitialLoading: false,
        isLoadingMore: false,
      ),
    );
  }

  int? _extractPageNumber(String? nextUrl) {
    if (nextUrl == null) return null;
    final uri = Uri.tryParse(nextUrl);
    if (uri == null) return null;
    final pageParam = uri.queryParameters['page'];
    return pageParam != null ? int.tryParse(pageParam) : null;
  }
}

class GlobalForumFeedState {
  final List<ForumThreadDto> items;
  final int? nextPage;
  final bool hasMore;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final Object? error;

  const GlobalForumFeedState({
    required this.items,
    this.nextPage,
    this.hasMore = true,
    this.isInitialLoading = true,
    this.isLoadingMore = false,
    this.error,
  });

  GlobalForumFeedState copyWith({
    List<ForumThreadDto>? items,
    int? nextPage,
    bool? hasMore,
    bool? isInitialLoading,
    bool? isLoadingMore,
    Object? error,
  }) => GlobalForumFeedState(
    items: items ?? this.items,
    nextPage: nextPage ?? this.nextPage,
    hasMore: hasMore ?? this.hasMore,
    isInitialLoading: isInitialLoading ?? this.isInitialLoading,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    error: error ?? this.error,
  );
}
