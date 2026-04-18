import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_detail_provider.dart';
import '../widgets/chapters_filter_tab_bar.dart';
import '../widgets/chapter_curriculum_item.dart';
import '../widgets/curriculum_header.dart';
import '../widgets/lesson_list_item.dart';

/// Screen displaying the full curriculum (chapters and lessons) of a course.
class ChaptersListPage extends ConsumerStatefulWidget {
  const ChaptersListPage({
    super.key,
    required this.courseId,
    this.parentId,
    this.onBack,
  });

  final String courseId;
  final String? parentId;
  final VoidCallback? onBack;

  @override
  ConsumerState<ChaptersListPage> createState() => _ChaptersListPageState();
}

class _ChaptersListPageState extends ConsumerState<ChaptersListPage> {
  CurriculumFilter _activeFilter = CurriculumFilter.all;

  void _onFilterChanged(CurriculumFilter filter) {
    setState(() => _activeFilter = filter);
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Watch chapters for the current depth only (lazy loading)
    final chaptersAsync = ref.watch(
      subChaptersProvider(widget.courseId, widget.parentId),
    );
    final courseAsync = ref.watch(courseDetailProvider(widget.courseId));
    final allLessonsAsync = ref.watch(
      allCourseLessonsProvider(widget.courseId),
    );

    return Container(
      color: design.colors.canvas,
      child: chaptersAsync.when(
        data: (chapters) {
          final course = courseAsync.maybeWhen(
            data: (c) => c,
            orElse: () => null,
          );

          final lessons = allLessonsAsync.maybeWhen(
            data: (l) => l,
            orElse: () => <LessonDto>[],
          );
          final filteredLessons = _filterLessons(lessons, _activeFilter);

          // If we have a parent, use its title, otherwise use course title
          String headerTitle = course?.title ?? 'Curriculum';

          return Column(
            children: [
              // Sticky Header including Tabs
              Container(
                decoration: BoxDecoration(
                  color: design.colors.card,
                  border: Border(
                    bottom: BorderSide(color: design.colors.border, width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurriculumHeader(
                      courseTitle: headerTitle,
                      chapterCount: chapters.length,
                      onBack: widget.onBack,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ChaptersFilterTabBar(
                        activeFilter: _activeFilter,
                        onFilterChanged: _onFilterChanged,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: AppScroll(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.md,
                    vertical: design.spacing.md,
                  ),
                  children: [
                    // Chapters or Lessons List
                    if (_activeFilter == CurriculumFilter.all)
                      ...chapters.asMap().entries.map((entry) {
                        final chapter = entry.value;
                        return ChapterCurriculumItem(
                          chapter: chapter,
                          index: entry.key,
                          onTap: () {
                            if (!chapter.isLeaf) {
                              // If parent, drill down (recursive navigation)
                              context.push(
                                '/study/course/${widget.courseId}/chapters?parentId=${chapter.id}',
                              );
                            } else {
                              // If leaf, go to detail (lessons)
                              context.push(
                                '/study/course/${widget.courseId}/chapters/${chapter.id}',
                              );
                            }
                          },
                        );
                      })
                    else
                      ...filteredLessons.map((lesson) {
                        return LessonListItem(
                          lesson: lesson,
                          onTap: () {
                            final route = switch (lesson.type) {
                              LessonType.video => '/study/video/${lesson.id}',
                              LessonType.pdf => '/study/lesson/${lesson.id}',
                              LessonType.assessment =>
                                '/study/assessment/${lesson.id}',
                              LessonType.test => '/study/test/${lesson.id}',
                            };
                            context.push(route);
                          },
                        );
                      }),

                    // Bottom Spacing
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (error, _) => Center(child: AppText.body(error.toString())),
      ),
    );
  }

  List<LessonDto> _filterLessons(
    List<LessonDto> lessons,
    CurriculumFilter filter,
  ) {
    if (filter == CurriculumFilter.all) return lessons;

    final LessonType targetType = switch (filter) {
      CurriculumFilter.video => LessonType.video,
      CurriculumFilter.pdf => LessonType.pdf,
      CurriculumFilter.assessment => LessonType.assessment,
      CurriculumFilter.test => LessonType.test,
      _ => throw UnimplementedError('Filter type $filter is not supported.'),
    };

    return lessons.where((l) => l.type == targetType).toList();
  }
}
