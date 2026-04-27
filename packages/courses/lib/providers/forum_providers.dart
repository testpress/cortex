import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';

part 'forum_providers.g.dart';

final forumCategoriesProvider =
    FutureProvider.family<List<ForumCategoryDto>, String>((ref, courseId) async {
      final repo = await ref.watch(forumRepositoryProvider.future);
      return repo.getCategories(courseId);
    });

@Riverpod(keepAlive: true)
Stream<List<ForumThreadDto>> courseForumThreads(CourseForumThreadsRef ref, String courseId) async* {
  final repo = await ref.watch(forumRepositoryProvider.future);
  
  final count = await repo.getThreadsCount(courseId);
  
  final refreshFuture = repo.refreshThreads(courseId);

  if (count == 0) {
    await refreshFuture;
  } else {
    refreshFuture.ignore();
  }

  yield* repo.watchThreads(courseId);
}

@Riverpod(keepAlive: true)
Stream<ForumThreadDto?> forumThreadDetail(ForumThreadDetailRef ref, {required String courseId, required String threadId}) async* {
  final repo = await ref.watch(forumRepositoryProvider.future);
  
  // Fetch existing count to decide if we need to block on initial load
  final count = await repo.getThreadsCount(courseId);
  final refreshFuture = repo.refreshThreads(courseId);

  if (count == 0) {
    await refreshFuture;
  } else {
    refreshFuture.ignore();
  }

  yield* repo.watchThread(threadId);
}

@Riverpod(keepAlive: true)
Stream<List<ForumCommentDto>> threadComments(ThreadCommentsRef ref, String threadId) async* {
  final repo = await ref.watch(forumRepositoryProvider.future);
  
  // Refresh comments on load
  repo.refreshComments(threadId).ignore();

  yield* repo.watchComments(threadId);
}
