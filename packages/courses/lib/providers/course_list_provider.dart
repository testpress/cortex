import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'package:core/data/services/pagination_service.dart';
import '../repositories/course_repository.dart';

part 'course_list_provider.g.dart';

@Riverpod(keepAlive: true)
Future<CourseRepository> courseRepository(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return CourseRepository(db, source);
}

/// Track if initial fetch has been done in the current session.
final _hasFetchedOnce = StateProvider<bool>((ref) => false);

/// State provider for initial sync status (first time loading courses).
final isInitialSyncingProvider = StateProvider<bool>((ref) => false);

/// State provider for "Load More" sync status (pagination footer).
final isMoreSyncingProvider = StateProvider<bool>((ref) => false);

/// Captures the last error that occurred during any sync operation.
final syncErrorProvider = StateProvider<Object?>((ref) => null);

@Riverpod(keepAlive: true)
class CourseList extends _$CourseList {
  PaginationState _syncState = const PaginationState();
  Future<void>? _activeSync;

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
    if (_activeSync != null) return _activeSync;

    _activeSync = _performSync(isReset: true);
    try {
      await _activeSync;
      ref.read(_hasFetchedOnce.notifier).state = true;
    } finally {
      _activeSync = null;
    }
  }

  /// Loads the next page from the API.
  Future<void> loadMore() async {
    if (!_syncState.hasMore || _activeSync != null) return;

    _activeSync = _performSync(isReset: false);
    try {
      await _activeSync;
    } finally {
      _activeSync = null;
    }
  }

  Future<void> _performSync({required bool isReset}) async {
    // Reset any previous errors
    ref.read(syncErrorProvider.notifier).state = null;

    if (isReset) {
      _syncState = const PaginationState();
      ref.read(isInitialSyncingProvider.notifier).state = true;
    } else {
      ref.read(isMoreSyncingProvider.notifier).state = true;
    }

    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      final response = await repo.fetchAndPersistCourses(
        page: _syncState.nextPage,
      );

      // Explicit logic to mark completeness if no results
      if (response.results.isEmpty) {
        _syncState = _syncState.copyWith(hasMore: false);
      } else {
        const pagination = PaginationService();
        _syncState = pagination.calculateNextState(
          response: response,
          currentPage: _syncState.nextPage,
        );
      }
    } catch (e) {
      // Capture the error but don't rethrow (so stream from DB is still visible)
      ref.read(syncErrorProvider.notifier).state = e;
    } finally {
      if (isReset) {
        ref.read(isInitialSyncingProvider.notifier).state = false;
      } else {
        ref.read(isMoreSyncingProvider.notifier).state = false;
      }
    }
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
