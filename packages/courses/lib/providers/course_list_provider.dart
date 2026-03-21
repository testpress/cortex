import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../repositories/course_repository.dart';

part 'course_list_provider.g.dart';

/// Provider to track syncing state for course list.
final courseSyncingProvider = StateProvider<bool>((ref) => false);

@Riverpod(keepAlive: true)
Future<CourseRepository> courseRepository(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return CourseRepository(
    db,
    source,
    onSyncStateChanged: (isSyncing) {
      ref.read(courseSyncingProvider.notifier).state = isSyncing;
    },
  );
}

/// Track if initial fetch has been done in the current session.
final hasFetchedOnceProvider = StateProvider<bool>((ref) => false);

/// Syncs the first page of courses if not already done.
/// Auth-gated: only runs if user is logged in.
@Riverpod(keepAlive: true)
Future<void> courseInitialSync(Ref ref) async {
  final auth = ref.watch(authProvider).valueOrNull;
  if (auth == null) return;
  
  if (ref.read(hasFetchedOnceProvider)) return;

  final repo = await ref.watch(courseRepositoryProvider.future);
  await repo.refreshCourses(reset: true);
  ref.read(hasFetchedOnceProvider.notifier).state = true;
}

/// Stream provider for the full course list.
/// Screens should watch [courseInitialSyncProvider] if they want to trigger/wait for the first sync.
@riverpod
Stream<List<CourseDto>> courseList(CourseListRef ref) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchCourses();
}

/// Provider for a specific course's chapters.
@riverpod
Stream<List<ChapterDto>> courseChapters(
    CourseChaptersRef ref, String courseId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchChapters(courseId);
}

/// Provider for a specific chapter's lessons.
@riverpod
Stream<List<LessonDto>> chapterLessons(
    ChapterLessonsRef ref, String chapterId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchLessons(chapterId);
}
