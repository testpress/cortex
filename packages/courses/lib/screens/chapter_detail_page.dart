import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chapter_detail_provider.dart';
import '../models/course_content.dart';
import '../widgets/chapter_status_filter_bar.dart';
import '../widgets/chapter_content_item.dart';

/// Screen displaying the detailed curriculum of a specific chapter.
/// Users can filter content by status (Running, Upcoming, History)
/// and navigate to specific lesson readers.
class ChapterDetailPage extends ConsumerWidget {
  const ChapterDetailPage({
    super.key,
    required this.courseId,
    required this.chapterId,
    this.onBack,
    this.onLessonClick,
  });

  final String courseId;
  final String chapterId;
  final VoidCallback? onBack;
  final ValueChanged<Lesson>? onLessonClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Watch the chapter detail data
    final chapterAsync = ref.watch(chapterDetailProvider(courseId, chapterId));

    // Check status filter state
    final activeStatusFilter = ref.watch(chapterStatusFilterProvider);

    return Container(
      color: design.colors.canvas,
      child: chapterAsync.when(
        data: (chapter) {
          if (chapter == null) {
            return Center(child: AppText.body(l10n.chapterNotFound));
          }

          final filteredLessons = chapter.lessons.where((l) {
            switch (activeStatusFilter) {
              case ChapterStatusFilter.running:
                return l.isRunning; // Primary source of truth from Running Contents API
              case ChapterStatusFilter.upcoming:
                return l.isUpcoming; // Primary source of truth from Upcoming Contents API
              case ChapterStatusFilter.history:
                return l.hasAttempts; // Primary source of truth from Content Attempts API
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
                    const ChapterStatusFilterBar(),
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
                            if (onLessonClick != null) {
                              onLessonClick!(lesson);
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
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (error, _) => Center(child: AppText.body(error.toString())),
      ),
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
            onTap: onBack ?? () => context.pop(),
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
