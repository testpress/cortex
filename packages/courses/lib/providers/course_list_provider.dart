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
final _hasFetchedOnce = StateProvider<bool>((ref) => false);

/// State provider for initial sync status (first time loading courses).
final isInitialSyncingProvider = StateProvider<bool>((ref) => false);

/// Stream notifier for the full course list.
///
/// - `build()` streams courses from the local Drift DB.
/// - `initialize()` ensures the first page is fetched from API one time.
/// - `loadMore()` loads subsequent pages on user scroll.
@Riverpod(keepAlive: true)
class CourseList extends _$CourseList {
  @override
  Stream<List<CourseDto>> build() async* {
    final repo = await ref.watch(courseRepositoryProvider.future);
    yield* repo.watchCourses();
  }

  /// Explicit initialization: ensures the first sync happens one time per session.
  /// Call this when the Study tab is entered.
  Future<void> initialize() async {
    // Wait for auth state to be resolved (e.g. if still checking token storage)
    final auth = await ref.read(authProvider.future);
    if (auth == null) return; // Auth gate — explicit

    if (ref.read(_hasFetchedOnce)) return;

    ref.read(isInitialSyncingProvider.notifier).state = true;
    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      await repo.refreshCourses(reset: true);
      ref.read(_hasFetchedOnce.notifier).state = true;
    } finally {
      ref.read(isInitialSyncingProvider.notifier).state = false;
    }
  }

  /// Loads the next page from the API.
  Future<void> loadMore() async {
    final repo = await ref.read(courseRepositoryProvider.future);
    if (!repo.hasMore || repo.isSyncing) return;
    await repo.refreshCourses();
  }
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
