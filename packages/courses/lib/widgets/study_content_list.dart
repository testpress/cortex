import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';
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

    final showInitialLoader = isSyncingInitial &&
        enrolledCoursesState.when(
          data: (courses) => courses.isEmpty,
          loading: () => true,
          error: (_, __) => false,
        );

    return enrolledCoursesState.when(
      data: (courses) {
        final filteredCourses = _filterCourses(courses);
        final filteredLessons = _filterLessons(allLessons);

        final isSkeleton = showInitialLoader && filteredCourses.isEmpty;
        final displayCourses = isSkeleton
            ? _skeletonCourses
            : filteredCourses;

        return SliverMainAxisGroup(
          slivers: [
            if (activeTypeFilters.isEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final course = displayCourses[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: design.spacing.md),
                        child: CourseCard(
                          course: course,
                          isSkeleton: isSkeleton,
                          onTap: isSkeleton
                              ? null
                              : () => context.push(
                                    '/study/course/${course.id}/chapters',
                                  ),
                        ),
                      );
                    },
                    childCount: displayCourses.length,
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
            if (isSyncingMore)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: design.spacing.md),
                    child: CourseCard(
                      course: _skeletonCourses.first,
                      isSkeleton: isSyncingMore,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      // DB stream briefly loading — only show skeleton if there's nothing cached yet.
      loading: () => isSyncingInitial
          ? SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: design.spacing.md),
                      child: CourseCard(
                        course: _skeletonCourses[index],
                        isSkeleton: isSyncingInitial,
                      ),
                    ),
                    childCount: _skeletonCourses.length,
                  ),
              ),
            )
          : const SliverToBoxAdapter(child: SizedBox.shrink()),
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
}

// Skeleton placeholder courses — used only during loading states.
// Values are chosen to produce realistic-sized shimmer bones.
final _skeletonCourses = List.generate(
  6,
  (index) => CourseDto(
    id: 'skeleton-$index',
    title: 'Loading course title text',
    colorIndex: index % 6,
    chapterCount: 12,
    totalContents: 48,
    progress: 0,
    completedLessons: 0,
    totalLessons: 48,
    image: '',
    examsCount: 0,
    order: index,
  ),
);
