import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/course_list_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/lesson_list_item.dart';

class StudyContentList extends ConsumerWidget {
  final AsyncValue<List<CourseDto>> enrolledCoursesState;
  final bool isSyncingInitial;
  final bool isSyncingMore;
  final List<LessonDto> allLessons;
  final Set<LessonType> activeTypeFilters;
  final String searchQuery;

  static final List<CourseDto> _loadingCourses = List.generate(
    6,
    (index) => CourseDto(
      id: 'loading-course-${index + 1}',
      title: 'Loading course title text',
      colorIndex: index % 6,
      chapterCount: 90 + index,
      totalContents: 400 + (index * 3),
      progress: 0,
      completedLessons: 0,
      totalLessons: 400 + (index * 3),
      image: '',
      examsCount: index % 4,
      order: index,
    ),
  );

  const StudyContentList({
    super.key,
    required this.enrolledCoursesState,
    required this.isSyncingInitial,
    required this.isSyncingMore,
    required this.allLessons,
    required this.activeTypeFilters,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);

    final showInitialLoader = isSyncingInitial;

    if (showInitialLoader) {
      return _buildInitialSkeletonList(design);
    }

    return enrolledCoursesState.when(
      data: (courses) {
        final filteredCourses = _filterCourses(courses);
        final filteredLessons = _filterLessons(allLessons);

        return SliverMainAxisGroup(
          slivers: [
            if (activeTypeFilters.isEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final course = filteredCourses[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: design.spacing.md),
                        child: CourseCard(
                          course: course,
                          onTap: () => context.push(
                            '/study/course/${course.id}/chapters',
                          ),
                        ),
                      );
                    },
                    childCount: filteredCourses.length,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final lesson = filteredLessons[index];
                      return LessonListItem(
                        lesson: lesson,
                        onTap: () {
                          final route = switch (lesson.type) {
                            LessonType.video ||
                            LessonType.pdf ||
                            LessonType.notes ||
                            LessonType.embedContent ||
                            LessonType.liveStream ||
                            LessonType.attachment =>
                              '/study/lesson/${lesson.id}',
                            LessonType.assessment =>
                              '/study/assessment/${lesson.id}',
                            LessonType.test => '/study/test/${lesson.id}',
                            LessonType.unknown => null,
                          };
                          if (route != null) {
                            context.push(route);
                          }
                        },
                      );
                    },
                    childCount: filteredLessons.length,
                  ),
                ),
              ),
            if (isSyncingMore) _buildLoadMoreSkeleton(design),
          ],
        );
      },
      loading: () => _buildInitialSkeletonList(design),
      error: (e, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: AppErrorView(
          message: 'Initialization failed: $e',
          onRetry: () => ref.read(courseListProvider.notifier).initialize(),
        ),
      ),
    );
  }

  List<CourseDto> _filterCourses(List<CourseDto> courses) {
    return courses;
  }

  List<LessonDto> _filterLessons(List<LessonDto> lessons) {
    if (activeTypeFilters.isEmpty) return [];

    return lessons.where((lesson) {
      if (!activeTypeFilters.contains(lesson.type)) return false;
      if (searchQuery.isEmpty) return true;
      return lesson.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildInitialSkeletonList(DesignConfig design) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: EdgeInsets.only(bottom: design.spacing.md),
            child: CourseCard(
              course: _loadingCourses[index],
              isSkeleton: true,
            ),
          ),
          childCount: _loadingCourses.length,
        ),
      ),
    );
  }

  Widget _buildLoadMoreSkeleton(DesignConfig design) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      sliver: SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(bottom: design.spacing.md),
          child: CourseCard(
            course: _loadingCourses.first,
            isSkeleton: true,
          ),
        ),
      ),
    );
  }
}
