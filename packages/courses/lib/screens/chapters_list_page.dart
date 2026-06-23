import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_detail_provider.dart';
import '../providers/filtered_lessons_provider.dart';
import '../widgets/chapters_filter_tab_bar.dart';
import '../widgets/chapter_curriculum_item.dart';
import '../widgets/curriculum_header.dart';
import '../widgets/lesson_list_item.dart';
import '../widgets/chapters_filter_rules.dart';

/// Screen displaying the full curriculum (chapters and lessons) of a course.
class ChaptersListPage extends ConsumerStatefulWidget {
  const ChaptersListPage({
    super.key,
    required this.courseId,
    this.parentId,
    this.isLeaf = false,
    this.onBack,
    this.showFilters = true,
    this.basePath = '/study',
  });

  final String courseId;
  final String? parentId;
  final bool isLeaf;
  final VoidCallback? onBack;
  final bool showFilters;
  final String basePath;

  @override
  ConsumerState<ChaptersListPage> createState() => _ChaptersListPageState();
}

class _ChaptersListPageState extends ConsumerState<ChaptersListPage> {
  CurriculumFilter? _activeFilter;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      final type = _apiTypeForFilter(_resolvedActiveFilter);
      ref
          .read(filteredLessonsProvider(
            widget.courseId,
            chapterId: widget.parentId,
            type: type,
          ).notifier)
          .fetchNextPage();
    }
  }

  CurriculumFilter? get _resolvedActiveFilter {
    final visibleFilters = ChaptersFilterRules.getVisibleFilters();
    return _activeFilter != null && !visibleFilters.contains(_activeFilter)
        ? null
        : _activeFilter;
  }

  void _onFilterChanged(CurriculumFilter? filter) {
    setState(() {
      _activeFilter = filter;
    });
  }

  String? _apiTypeForFilter(CurriculumFilter? filter) {
    if (filter == null || filter == CurriculumFilter.all) return null;
    // Note: The remote API natively groups subtypes for 'notes' and 'attachment'.
    // Fetching type=notes returns both standard notes and embedContent (HTML with iframes).
    // Fetching type=attachment returns both standard attachments and pdfs.
    return filter.name;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final visibleFilters = ChaptersFilterRules.getVisibleFilters();
    final activeFilter = _resolvedActiveFilter;

    final chaptersAsync = ref.watch(
      subChaptersProvider(widget.courseId, widget.parentId),
    );
    final courseAsync = ref.watch(courseDetailProvider(widget.courseId));
    return Container(
      color: design.colors.canvas,
      child: chaptersAsync.when(
        data: (chapters) {
          final course = courseAsync.maybeWhen(
            data: (c) => c,
            orElse: () => null,
          );

          final showLessons = widget.isLeaf ||
              activeFilter != null ||
              (chapters.isEmpty && !chaptersAsync.isLoading);

          final lessons = <LessonDto>[];
          bool isLoadingFilter = false;
          bool isLoadingMore = false;

          if (showLessons) {
            final allFilterState = ref.watch(filteredLessonsProvider(
              widget.courseId,
              chapterId: widget.parentId,
              type: null,
            ));

            final type = _apiTypeForFilter(activeFilter);
            final filterState = ref.watch(filteredLessonsProvider(
              widget.courseId,
              chapterId: widget.parentId,
              type: type,
            ));

            // Optimistic UI: If the specific filter is loading and has no data yet,
            // fallback to the 'All' tab's cached data to prevent skeleton flickering.
            if (filterState.lessons.isEmpty &&
                filterState.isLoading &&
                type != null) {
              lessons.addAll(allFilterState.lessons);
              isLoadingFilter =
                  false; // Hide skeleton since we have optimistic data
            } else {
              lessons.addAll(filterState.lessons);
              isLoadingFilter = filterState.isLoading;
            }
            isLoadingMore = filterState.isLoadingMore;
          }

          final filteredLessons =
              activeFilter == null || activeFilter == CurriculumFilter.all
                  ? lessons
                  : lessons.where((l) {
                      final targetTypes = switch (activeFilter) {
                        CurriculumFilter.video => [LessonType.video],
                        CurriculumFilter.notes => [
                            LessonType.notes,
                            LessonType.embedContent
                          ],
                        CurriculumFilter.attachment => [
                            LessonType.attachment,
                            LessonType.pdf
                          ],
                        CurriculumFilter.assessment => [LessonType.assessment],
                        CurriculumFilter.test => [LessonType.test],
                        CurriculumFilter.all => const <LessonType>[],
                      };
                      return targetTypes.contains(l.type);
                    }).toList();

          final showChapters = activeFilter == null &&
              (chapters.isNotEmpty || chaptersAsync.isLoading);
          String headerTitle = course?.title ?? 'Curriculum';

          return Column(
            children: [
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
                          activeFilter: activeFilter,
                          onFilterChanged: _onFilterChanged,
                          visibleFilters: visibleFilters,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: showChapters
                    ? AppScroll(
                        padding: EdgeInsets.symmetric(
                          horizontal: design.spacing.md,
                          vertical: design.spacing.md,
                        ),
                        children: [
                          ...chapters.asMap().entries.map((entry) {
                            final chapter = entry.value;
                            return ChapterCurriculumItem(
                              chapter: chapter,
                              index: entry.key,
                              onTap: () {
                                if (chapter.isLeaf) {
                                  context.push(
                                    '${widget.basePath}/course/${widget.courseId}/chapters/${chapter.id}',
                                  );
                                } else {
                                  context.push(
                                    '${widget.basePath}/course/${widget.courseId}/chapters?parentId=${chapter.id}',
                                  );
                                }
                              },
                            );
                          }),
                          const SizedBox(height: 80),
                        ],
                      )
                    : (isLoadingFilter || isLoadingMore) &&
                            filteredLessons.isEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: design.spacing.md,
                              vertical: design.spacing.md,
                            ),
                            itemCount: _skeletonLessons.length,
                            itemBuilder: (context, index) {
                              return LessonListItem(
                                lesson: _skeletonLessons[index],
                                isSkeleton: isLoadingFilter || isLoadingMore,
                              );
                            },
                          )
                        : filteredLessons.isEmpty
                            ? Center(
                                child: AppText.body(
                                  L10n.of(context).filterEmptyStateMessage(
                                    widget.showFilters
                                        ? (activeFilter?.displayName(context) ??
                                            L10n.of(context)
                                                .labelContentsPlural)
                                        : L10n.of(context).labelExams,
                                  ),
                                  color: design.colors.textSecondary,
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.symmetric(
                                  horizontal: design.spacing.md,
                                  vertical: design.spacing.md,
                                ),
                                itemCount: filteredLessons.length +
                                    (isLoadingMore || isLoadingFilter ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index < filteredLessons.length) {
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
                                            '${widget.basePath}/lesson/${lesson.id}',
                                          LessonType.assessment =>
                                            '${widget.basePath}/assessment/${lesson.id}',
                                          LessonType.test =>
                                            '${widget.basePath}/test/${lesson.id}',
                                          LessonType.unknown => null,
                                        };
                                        if (route != null) context.push(route);
                                      },
                                    );
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: design.spacing.md),
                                    child: LessonListItem(
                                      lesson: _skeletonLessons.first,
                                      isSkeleton:
                                          isLoadingMore || isLoadingFilter,
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          );
        },
        loading: () {
          final course = courseAsync.maybeWhen(
            data: (c) => c,
            orElse: () => null,
          );
          final headerTitle = course?.title ?? 'Curriculum';

          return Column(
            children: [
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
                      chapterCount: 0,
                      onBack: widget.onBack,
                    ),
                    if (widget.showFilters)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ChaptersFilterTabBar(
                          activeFilter: activeFilter,
                          onFilterChanged: _onFilterChanged,
                          visibleFilters: visibleFilters,
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
                    ..._skeletonChapters.asMap().entries.map((entry) {
                      return ChapterCurriculumItem(
                        chapter: entry.value,
                        index: entry.key,
                        isSkeleton: chaptersAsync.isLoading,
                      );
                    }),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          );
        },
        error: (error, _) => Center(child: AppText.body(error.toString())),
      ),
    );
  }
}

final _skeletonChapters = List.generate(
  5,
  (index) => ChapterDto(
    id: 'skeleton-chapter-$index',
    courseId: 'skeleton-course-id',
    title: 'Loading course chapter title text',
    lessonCount: 4,
    assessmentCount: 2,
    orderIndex: index,
    isLeaf: true,
  ),
);

final _skeletonLessons = List.generate(
  5,
  (index) => LessonDto(
    id: 'skeleton-lesson-$index',
    chapterId: 'skeleton-chapter-0',
    title: 'Loading lesson title text content',
    chapterTitle: 'Loading chapter title text',
    type: LessonType.video,
    progressStatus: LessonProgressStatus.notStarted,
    isLocked: false,
    duration: '15 mins',
    orderIndex: index,
  ),
);
