import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chapter_detail_provider.dart';
import '../providers/course_list_provider.dart';
import '../models/course_content.dart';
import '../widgets/chapter_status_filter_bar.dart';
import '../widgets/chapter_content_item.dart';

/// Screen displaying the detailed curriculum of a specific chapter.
/// Users can filter content by status (Running, Upcoming, History)
/// and navigate to specific lesson readers.
class ChapterDetailPage extends ConsumerStatefulWidget {
  const ChapterDetailPage({
    super.key,
    required this.courseId,
    required this.chapterId,
    this.onBack,
    this.onLessonClick,
    this.showFilters = true,
  });

  final String courseId;
  final String chapterId;
  final VoidCallback? onBack;
  final ValueChanged<Lesson>? onLessonClick;
  final bool showFilters;

  @override
  ConsumerState<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends ConsumerState<ChapterDetailPage> {
  @override
  void initState() {
    super.initState();
    // Trigger background sync only once when the screen is navigated to.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final repo = await ref.read(courseRepositoryProvider.future);
      repo.syncChapterContents(widget.courseId, widget.chapterId).ignore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Watch the chapter detail data
    final chapterAsync = ref.watch(chapterDetailProvider(widget.courseId, widget.chapterId));

    // Check status filter state
    final activeStatusFilter = ref.watch(chapterStatusFilterProvider);

    return Container(
      color: design.colors.canvas,
      child: () {
        // If we have data (even if it's currently refreshing in the background),
        // show the content immediately to avoid "loading flashes" between tabs.
        if (chapterAsync.hasValue) {
          final chapter = chapterAsync.value;
          if (chapter == null) {
            return Center(child: AppText.body(l10n.chapterNotFound));
          }

          final filteredLessons = chapter.lessons.where((l) {
            switch (activeStatusFilter) {
              case ChapterStatusFilter.all:
                return true;
              case ChapterStatusFilter.running:
                return l.isRunning;
              case ChapterStatusFilter.upcoming:
                return l.isUpcoming;
              case ChapterStatusFilter.history:
                return l.hasAttempts;
            }
          }).toList();

          return Column(
            children: [
              // Unified Top Bar (Header + Filters)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: design.colors.card,
                  border: Border(
                    bottom: BorderSide(color: design.colors.divider, width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderContents(context, design, chapter),
                    if (widget.showFilters) const ChapterStatusFilterBar(),
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
                    if (filteredLessons.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: AppText.body(l10n.chapterNoContent),
                        ),
                      )
                    else
                      ...filteredLessons.map(
                        (lesson) => ChapterContentItem(
                          lesson: lesson,
                          onTap: () {
                            if (widget.onLessonClick != null) {
                              widget.onLessonClick!(lesson);
                            }
                          },
                        ),
                      ),
                    // Extra spacing at bottom for visibility
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          );
        }

        // Only show the spinner if we have NO data yet (first load).
        return chapterAsync.when(
          data: (_) => const SizedBox.shrink(), // Handled above by hasValue
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (error, _) => Center(child: AppText.body(error.toString())),
        );
      }(),
    );
  }

  /// Builds the contents of the header (Back button, Title, Stats)
  Widget _buildHeaderContents(
    BuildContext context,
    DesignConfig design,
    Chapter chapter,
  ) {
    final l10n = L10n.of(context);
    final displayTitle = chapter.courseTitle != null
        ? '${chapter.courseTitle} - ${chapter.title}'
        : chapter.title;

    final safeArea = MediaQuery.of(context).padding;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16, // Match Chapter list padding
        safeArea.top + 12, // Match safe area top margin
        16,
        design.spacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          AppFocusable(
            onTap: widget.onBack ?? () => context.pop(),
            borderRadius: BorderRadius.circular(design.radius.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.chevronLeft,
                  size: 20,
                  color: design.colors.textPrimary, // Matching list header
                ),
                const SizedBox(width: 8),
                AppText.label(
                  l10n.curriculumBackButton,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Chapter Title (Prominent as in reference)
          AppText.headline(
            displayTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Chapter Stats
          AppText.cardCaption(
            l10n.chapterMetadata(
              chapter.lessonCount,
              l10n.curriculumLessonsLabel,
              chapter.assessmentCount,
              l10n.curriculumAssessmentsLabel,
            ),
          ),
        ],
      ),
    );
  }
}
