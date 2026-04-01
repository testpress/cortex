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

/// Tracks if the initial API sync for the course list was completed in this session.
final _wasInitialSyncDone = StateProvider<bool>((ref) => false);

/// Tracks if the first page of courses is currently being synced from the network.
final isSyncingInitialPage = StateProvider<bool>((ref) => false);

/// Tracks if additional pages (pagination) are currently being synced.
final isSyncingMoreResults = StateProvider<bool>((ref) => false);

/// Detailed error object from the most recent course sync operation.
final courseListSyncError = StateProvider<Object?>((ref) => null);

@Riverpod(keepAlive: true)
class CourseList extends _$CourseList {
  PaginationState _paginationTracker = const PaginationState();
  Future<void>? _pendingSyncRequest;

  @override
  Stream<List<CourseDto>> build() async* {
    final repo = await ref.watch(courseRepositoryProvider.future);
    yield* repo.watchCourses().map(
          (rows) => rows.map((row) => repo.rowToCourseDto(row)).toList(),
        );
  }

  /// Explicit initialization: ensures the first sync happens one time per session.
  /// Call this when the Study tab is entered.
  Future<void> initialize() async {
    // Wait for auth state to be resolved (e.g. if still checking token storage)
    final auth = await ref.read(authProvider.future);
    if (auth == null) return; // Auth gate — explicit

    if (ref.read(_wasInitialSyncDone)) return;
    if (_pendingSyncRequest != null) return _pendingSyncRequest;

    _pendingSyncRequest = _performSync(isReset: true);
    try {
      await _pendingSyncRequest;
      ref.read(_wasInitialSyncDone.notifier).state = true;
    } finally {
      _pendingSyncRequest = null;
    }
  }

  /// Loads the next page from the API.
  Future<void> loadMore() async {
    if (!_paginationTracker.hasMore || _pendingSyncRequest != null) return;

    _pendingSyncRequest = _performSync(isReset: false);
    try {
      await _pendingSyncRequest;
    } finally {
      _pendingSyncRequest = null;
    }
  }

  Future<void> _performSync({required bool isReset}) async {
    // Reset any previous errors
    ref.read(courseListSyncError.notifier).state = null;

    if (isReset) {
      _paginationTracker = const PaginationState();
      ref.read(isSyncingInitialPage.notifier).state = true;
    } else {
      ref.read(isSyncingMoreResults.notifier).state = true;
    }

    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      final response = await repo.refreshCourses(
        page: _paginationTracker.nextPage,
      );

      // Explicit logic to mark completeness if no results
      if (response.results.isEmpty) {
        _paginationTracker = _paginationTracker.copyWith(hasMore: false);
      } else {
        const pagination = PaginationService();
        _paginationTracker = pagination.calculateNextState(
          response: response,
          currentPage: _paginationTracker.nextPage,
        );
      }
    } catch (e) {
      // Capture the error but don't rethrow (so stream from DB is still visible)
      ref.read(courseListSyncError.notifier).state = e;
    } finally {
      if (isReset) {
        ref.read(isSyncingInitialPage.notifier).state = false;
      } else {
        ref.read(isSyncingMoreResults.notifier).state = false;
      }
    }
  }
}

/// Provider for a specific course's chapters.
@riverpod
Stream<List<ChapterDto>> courseChapters(
    CourseChaptersRef ref, String courseId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchChapters(courseId).map(
        (rows) => rows.map((row) => repo.rowToChapterDto(row)).toList(),
      );
}

/// Provider for a specific chapter's lessons.
@riverpod
Stream<List<LessonDto>> chapterLessons(
    ChapterLessonsRef ref, String chapterId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchLessons(chapterId).map(
        (rows) => rows.map((row) => repo.rowToLessonDto(row)).toList(),
      );
}
