import 'dart:async';
import 'package:core/data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/course_repository.dart';
import 'course_list_provider.dart';

part 'filtered_lessons_provider.g.dart';

class FilteredLessonsState {
  const FilteredLessonsState({
    required this.lessons,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
  });

  final List<LessonDto> lessons;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  FilteredLessonsState copyWith({
    List<LessonDto>? lessons,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return FilteredLessonsState(
      lessons: lessons ?? this.lessons,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

@riverpod
class FilteredLessons extends _$FilteredLessons {
  StreamSubscription<List<LessonDto>>? _dbSub;
  StreamSubscription<List<LessonDto>>? _apiSub;
  bool _isApiSyncing = false;
  bool _isDisposed = false;

  @override
  FilteredLessonsState build(
    String courseId, {
    String? chapterId,
    String? type,
  }) {
    // Watch the repository FutureProvider and init subscriptions once ready.
    final repoAsync = ref.watch(courseRepositoryProvider);
    final repo = repoAsync.valueOrNull;
    if (repo == null) {
      return const FilteredLessonsState(
        lessons: [],
        isLoading: true,
        isLoadingMore: false,
        hasMore: true,
      );
    }

    ref.onDispose(() {
      _isDisposed = true;
      _dbSub?.cancel();
      _apiSub?.cancel();
    });

    // Schedule initialization for after the build method returns the initial state.
    Future.microtask(() {
      if (_isDisposed) return;

      // 1. Watch local database for real-time updates.
      _dbSub = repo
          .watchFilteredLessonsLocal(
        courseId,
        chapterId: chapterId,
        type: type,
      )
          .listen((lessons) {
        state = state.copyWith(
          lessons: lessons,
          isLoading: false,
        );
      });

      // 2. Start background sync
      _startApiSync(repo);
    });

    return const FilteredLessonsState(
      lessons: [],
      isLoading: true,
      isLoadingMore: false,
      hasMore: true,
    );
  }

  void _startApiSync(CourseRepository repo) {
    if (_isApiSyncing) return;
    _isApiSyncing = true;
    state = state.copyWith(isLoadingMore: true);

    final stream = repo.streamFilteredContents(
      courseId,
      chapterId: chapterId,
      type: type,
    );

    _apiSub = stream.listen(
      (_) {
        // Pause stream to prevent eager loading of the next page
        _apiSub?.pause();
        _isApiSyncing = false;
        state = state.copyWith(isLoadingMore: false);
      },
      onError: (e) {
        _isApiSyncing = false;
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
        );
      },
      onDone: () {
        _isApiSyncing = false;
        state = state.copyWith(
          isLoadingMore: false,
          hasMore: false,
        );
      },
    );
  }

  void fetchNextPage() {
    if (!state.hasMore || _isApiSyncing) return;
    if (_apiSub != null && _apiSub!.isPaused) {
      _isApiSyncing = true;
      state = state.copyWith(isLoadingMore: true);
      _apiSub!.resume();
    }
  }
}
