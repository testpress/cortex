import 'dart:async';
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
    final search = ref.watch(courseSearchProvider);

    if (search.query.isEmpty) {
      final repo = await ref.watch(courseRepositoryProvider.future);
      yield* repo.watchStudyCourses().map(
            (rows) => rows.map((row) => repo.rowToCourseDto(row)).toList(),
          );
    } else {
      yield search.results;
    }
  }

  /// Entry point for search - redirects to search provider
  Future<void> search(String query) =>
      ref.read(courseSearchProvider.notifier).search(query);

  /// Explicit initialization for browse mode
  Future<void> initialize() async {
    final auth = await ref.read(authProvider.future);
    if (!auth) return;

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

  /// Redirects to appropriate loadMore based on mode
  Future<void> loadMore() async {
    final search = ref.read(courseSearchProvider);
    if (search.query.isNotEmpty) {
      ref.read(courseSearchProvider.notifier).loadMore();
      return;
    }

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
        tags: 'classes',
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
@Riverpod(keepAlive: true)
Stream<List<ChapterDto>> courseChapters(
    CourseChaptersRef ref, String courseId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  repo.refreshChapters(courseId).ignore();

  yield* repo.watchChapters(courseId).map(
        (rows) => rows.map((row) => repo.rowToChapterDto(row)).toList(),
      );
}

/// Provider for a specific course's chapters (all depths).
@Riverpod(keepAlive: true)
Stream<List<ChapterDto>> allChapters(
    AllChaptersRef ref, String courseId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchAllChapters(courseId).map(
        (rows) => rows.map((row) => repo.rowToChapterDto(row)).toList(),
      );
}

/// Provider for a specific chapter's lessons.
@Riverpod(keepAlive: true)
Stream<List<LessonDto>> chapterLessons(
    ChapterLessonsRef ref, String chapterId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchLessons(chapterId).map(
        (rows) => rows.map((row) => repo.rowToLessonDto(row)).toList(),
      );
}
@Riverpod(keepAlive: true)
class CourseSearch extends _$CourseSearch {
  Future<void>? _pendingRequest;

  @override
  CourseSearchState build() => CourseSearchState();

  Future<void> search(String query) async {
    if (query == state.query) return;
    if (query.isEmpty) {
      state = CourseSearchState();
      return;
    }

    // Preserve existing results while loading new search to avoid flashing empty list
    state = state.copyWith(query: query, isLoading: true, error: null);

    _pendingRequest = _performSearch(query: query, isReset: true);
    await _pendingRequest;
  }

  Future<void> loadMore() async {
    if (!state.pagination.hasMore || _pendingRequest != null) return;
    
    _pendingRequest = _performSearch(query: state.query, isReset: false);
    await _pendingRequest;
  }

  Future<void> _performSearch({required String query, required bool isReset}) async {
    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      final page = isReset ? 1 : state.pagination.nextPage;
      
      final response = await repo.searchCourses(query: query, page: page);
      
      final results = isReset ? response.results : [...state.results, ...response.results];
      
      PaginationState newPagination;
      if (response.results.isEmpty) {
        newPagination = state.pagination.copyWith(hasMore: false);
      } else {
        const paginationService = PaginationService();
        newPagination = paginationService.calculateNextState(
          response: response,
          currentPage: page,
        );
      }

      state = state.copyWith(
        results: results,
        isLoading: false,
        pagination: newPagination,
      );
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    } finally {
      _pendingRequest = null;
    }
  }
}

class CourseSearchState {
  final String query;
  final List<CourseDto> results;
  final bool isLoading;
  final Object? error;
  final PaginationState pagination;

  CourseSearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.error,
    this.pagination = const PaginationState(),
  });

  CourseSearchState copyWith({
    String? query,
    List<CourseDto>? results,
    bool? isLoading,
    Object? error,
    PaginationState? pagination,
  }) {
    return CourseSearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      pagination: pagination ?? this.pagination,
    );
  }
}
