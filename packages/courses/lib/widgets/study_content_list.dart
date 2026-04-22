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

    final showInitialLoader =
        isSyncingInitial && enrolledCoursesState.valueOrNull?.isEmpty == true;

    if (showInitialLoader) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: AppLoadingIndicator()),
      );
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
                            LessonType.video => '/study/video/${lesson.id}',
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: design.spacing.md),
                  child: const Center(child: AppLoadingIndicator()),
                ),
              ),
          ],
        );
      },
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
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
