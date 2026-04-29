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
