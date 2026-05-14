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
    this.showFilters = true,
    this.basePath = '/study',
  });

  final String courseId;
  final String? parentId;
  final VoidCallback? onBack;
  final bool showFilters;
  final String basePath;

  @override
  ConsumerState<ChaptersListPage> createState() => _ChaptersListPageState();
}

class _ChaptersListPageState extends ConsumerState<ChaptersListPage> {
  CurriculumFilter _activeFilter = CurriculumFilter.all;

  void _onFilterChanged(CurriculumFilter filter) {
    // Master Sync is now handled lazily by the filtered curriculum provider.
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
    // We only show lessons for the current chapter level (non-recursive).
    // Filters are applied client-side to the already-cached items.
    final lessonsAsync = widget.parentId != null
      ? ref.watch(chapterLessonsProvider(widget.courseId, widget.parentId!))
      : const AsyncValue<List<LessonDto>>.data([]);
    
    final isSyncingAsync = ref.watch(courseSyncStatusProvider(widget.courseId));
    final isSyncing = isSyncingAsync.valueOrNull ?? false;


    return Container(
      color: design.colors.canvas,
      child: chaptersAsync.when(
        data: (chapters) {
          final course = courseAsync.maybeWhen(
            data: (c) => c,
            orElse: () => null,
          );

          final lessons = lessonsAsync.valueOrNull ?? [];
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
                    if (widget.showFilters)
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
                    if (_activeFilter == CurriculumFilter.all && chapters.isNotEmpty)
                      ...chapters.asMap().entries.map((entry) {
                        final chapter = entry.value;
                        return ChapterCurriculumItem(
                          chapter: chapter,
                          index: entry.key,
                          onTap: () {
                            if (chapter.isLeaf) {
                              // If leaf, go to detail screen (lessons)
                              context.push(
                                '${widget.basePath}/course/${widget.courseId}/chapters/${chapter.id}',
                              );
                            } else {
                              // If parent, drill down (recursive navigation)
                              context.push(
                                '${widget.basePath}/course/${widget.courseId}/chapters?parentId=${chapter.id}',
                              );
                            }
                          },
                        );
                      })
                    else if (_activeFilter != CurriculumFilter.all || chapters.isEmpty)
                      if ((chaptersAsync.isLoading || lessonsAsync.isLoading || isSyncing) && filteredLessons.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: AppLoadingIndicator()),
                      )
                    else if (filteredLessons.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: AppText.body(
                            'No ${widget.showFilters ? _activeFilter.displayName : "exams"} found.',
                            color: design.colors.textSecondary,
                          ),
                        ),
                      )
                    else
                      ...filteredLessons.map((lesson) {
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
                                '${widget.basePath}/lesson/${lesson.id}',
                              LessonType.assessment =>
                                '${widget.basePath}/assessment/${lesson.id}',
                              LessonType.test => '${widget.basePath}/test/${lesson.id}',
                              LessonType.unknown => null,
                            };
                            if (route != null) {
                              context.push(route);
                            }
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

    if (filter == CurriculumFilter.lesson) {
      // "Lessons" filter: Show everything except specialized categories
      return lessons.where((l) => 
        l.type != LessonType.video && 
        l.type != LessonType.assessment && 
        l.type != LessonType.test
      ).toList();
    }

    final LessonType targetType = switch (filter) {
      CurriculumFilter.video => LessonType.video,
      CurriculumFilter.assessment => LessonType.assessment,
      CurriculumFilter.test => LessonType.test,
      _ => throw UnimplementedError('Filter type $filter is not supported.'),
    };

    return lessons.where((l) => l.type == targetType).toList();
  }
}
