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

@Riverpod(keepAlive: true)
class FilteredLessons extends _$FilteredLessons {
  LessonPaginationController? _controller;

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
        isLoadingMore: true,
        hasMore: true,
      );
    }

    _controller = repo.getFilteredLessonsController(
      courseId,
      chapterId: chapterId,
      type: type,
    );

    final lessonsSub = _controller!.lessonsStream.listen((lessons) {
      state = state.copyWith(
        lessons: lessons,
        isLoading: false,
      );
    });

    final isLoadingMoreSub =
        _controller!.isLoadingMoreStream.listen((isLoadingMore) {
      state = state.copyWith(isLoadingMore: isLoadingMore);
    });

    final hasMoreSub = _controller!.hasMoreStream.listen((hasMore) {
      state = state.copyWith(hasMore: hasMore);
    });

    ref.onDispose(() {
      lessonsSub.cancel();
      isLoadingMoreSub.cancel();
      hasMoreSub.cancel();
      _controller?.dispose();
    });

    return const FilteredLessonsState(
      lessons: [],
      isLoading: true,
      isLoadingMore: true,
      hasMore: true,
    );
  }

  void fetchNextPage() {
    _controller?.fetchNextPage();
  }
}
