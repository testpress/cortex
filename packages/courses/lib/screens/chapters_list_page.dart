import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_detail_provider.dart';
import '../widgets/chapters_filter_tab_bar.dart';
import '../widgets/chapter_curriculum_item.dart';
import '../widgets/curriculum_header.dart';
import '../widgets/lesson_list_item.dart';

/// Screen displaying the full curriculum (chapters and lessons) of a course.
class ChaptersListPage extends ConsumerStatefulWidget {
  const ChaptersListPage({super.key, required this.courseId, this.onBack});

  final String courseId;
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

    // Watch course detail with nested chapters
    final courseAsync = ref.watch(courseDetailProvider(widget.courseId));
    final allLessonsAsync = ref.watch(
      allCourseLessonsProvider(widget.courseId),
    );

    return AppShell(
      backgroundColor: design.colors.canvas,
      child: courseAsync.when(
        data: (course) {
          if (course == null) {
            return const Center(child: AppText.body('Course not found'));
          }

          final chapters = course.chapters;
          final filteredLessons = allLessonsAsync.maybeWhen(
            data: (lessons) => _filterLessons(lessons, _activeFilter),
            orElse: () => <LessonDto>[],
          );

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
                  children: [
                    CurriculumHeader(
                      courseTitle: course.title,
                      chapterCount: course.chapterCount,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  children: [
                    // Chapters or Lessons List
                    if (_activeFilter == CurriculumFilter.all)
                      ...chapters.asMap().entries.map((entry) {
                        final chapter = entry.value;
                        return ChapterCurriculumItem(
                          chapter: chapter,
                          index: entry.key,
                          onTap: () => context.push(
                            '/study/course/${widget.courseId}/chapters/${chapter.id}',
                          ),
                        );
                      })
                    else
                      ...filteredLessons.map((lesson) {
                        return LessonListItem(
                          lesson: lesson,
                          onTap: () {
                            final route = switch (lesson.type) {
                              LessonType.video => '/video/${lesson.id}',
                              LessonType.pdf => '/lesson/${lesson.id}',
                              LessonType.assessment =>
                                '/assessment/${lesson.id}',
                              LessonType.test => '/test/${lesson.id}',
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
