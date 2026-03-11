import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';

/// A card representing a chapter in the curriculum list.
///
/// Navigates to a detail view for that chapter.
class ChapterCurriculumItem extends StatelessWidget {
  const ChapterCurriculumItem({
    super.key,
    required this.chapter,
    required this.index,
    this.onTap,
  });

  final ChapterDto chapter;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Consistent blue for course/chapter icons as per reference
    final iconTheme = design.study.chapter;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: design.shadows.surfaceSoft,
      ),
      child: AppSemantics.button(
        label: l10n.chapterIndexLabel(index + 1, chapter.title),
        onTap: onTap ?? () {},
        child: AppFocusable(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon Box (md: 40x40)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconTheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    LucideIcons.bookOpen,
                    color: iconTheme.foreground,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Title and Metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.cardTitle(
                        l10n.chapterIndexLabel(index + 1, chapter.title),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      AppText.cardSubtitle(
                        l10n.chapterMetadata(
                          chapter.lessonCount,
                          l10n.curriculumLessonsLabel,
                          chapter.assessmentCount,
                          l10n.curriculumAssessmentsLabel,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),

                // Navigation Indicator
                Icon(
                  LucideIcons.chevronRight,
                  color: design.colors.textSecondary.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
