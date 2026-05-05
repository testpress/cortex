import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_detail_provider.dart';
import '../providers/course_list_provider.dart';
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
    setState(() => _activeFilter = filter);

    // If the user selects a specific content filter (not "All"), 
    // trigger the Master Sync to ensure we have all lessons across the course.
    if (filter != CurriculumFilter.all) {
      ref.read(courseRepositoryProvider.future).then((repo) async {
        repo.refreshCourseContents(widget.courseId).ignore();
        
        // Also trigger recursive sync for immediate sub-chapters to show nested content faster
        final chapters = await repo.watchChapters(widget.courseId, parentId: widget.parentId).first;
        for (var chapter in chapters) {
          if (!chapter.isLeaf) {
            repo.syncChapterContents(widget.courseId, chapter.id).ignore();
          }
        }
      });
    }
  }

  Future<void> _syncCurrentLevelRecursive() async {
    final repo = await ref.read(courseRepositoryProvider.future);
    
    // 1. Sync current level chapters
    await repo.refreshChapters(widget.courseId, parentId: widget.parentId);
    
    // 2. Sync lessons for this chapter
    if (widget.parentId != null) {
      repo.syncChapterContents(widget.courseId, widget.parentId!).ignore();
    }

    // 3. Sync lessons for all immediate sub-chapters (one level deep recursion)
    // This makes nested videos visible immediately when filtering at the parent level.
    final subChapters = await repo.watchChapters(widget.courseId, parentId: widget.parentId).first;
    for (var chapter in subChapters) {
      if (!chapter.isLeaf) {
        repo.syncChapterContents(widget.courseId, chapter.id).ignore();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _syncCurrentLevelRecursive();
      
      if (widget.parentId == null) {
        // Master sync is deferred but we refresh root chapters
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Watch chapters for the current depth only (lazy loading)
    final chaptersAsync = ref.watch(
      subChaptersProvider(widget.courseId, widget.parentId),
    );
    final courseAsync = ref.watch(courseDetailProvider(widget.courseId));
    final allCurriculumAsync = ref.watch(
      allCourseLessonsProvider(widget.courseId),
    );
    final allKnownChaptersAsync = ref.watch(allChaptersProvider(widget.courseId));
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

          final curriculum = allCurriculumAsync.maybeWhen(
            data: (c) => c,
            orElse: () => const CourseCurriculumDto(),
          );

          final lessons = curriculum.lessons;
          
          // Combine API snapshot chapters with all known chapters from the local vault.
          // This fills in any structural folders that might be missing from the flat API metadata.
          final allChapters = [
            ...curriculum.chapters,
            ...(allKnownChaptersAsync.value ?? []),
          ];
          
          // Determine the set of valid chapter IDs for the current view.
          // If we are in a subchapter, we only want lessons from this chapter or its subchapters.
          final Set<String> validChapterIds = {};
          if (widget.parentId != null) {
            validChapterIds.add(widget.parentId!);
            
            // Add all descendants of the current parent
            // O(N) optimization: Group chapters by parentId once
            final parentMap = <String?, List<ChapterDto>>{};
            for (var c in allChapters) {
              parentMap.putIfAbsent(c.parentId, () => []).add(c);
            }

            void addDescendants(String pid) {
              final children = parentMap[pid] ?? [];
              for (var c in children) {
                validChapterIds.add(c.id);
                addDescendants(c.id);
              }
            }
            addDescendants(widget.parentId!);
          }

          final filteredLessons = _filterLessons(lessons, _activeFilter).where((l) {
            if (widget.parentId == null) return true; // Show all for root level
            return validChapterIds.contains(l.chapterId);
          }).toList();

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
                                '${widget.basePath}/course/${widget.courseId}/chapters?parentId=${chapter.id}',
                              );
                            } else {
                              // If leaf, go to detail (lessons)
                              context.push(
                                '${widget.basePath}/course/${widget.courseId}/chapters/${chapter.id}',
                              );
                            }
                          },
                        );
                      })
                    else if ((allCurriculumAsync.isLoading || isSyncing) && filteredLessons.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: AppLoadingIndicator()),
                      )
                    else if (filteredLessons.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: AppText.body(
                            'No ${widget.showFilters ? _activeFilter.name : "exam"}s found.',
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

    if (filter == CurriculumFilter.pdf) {
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
