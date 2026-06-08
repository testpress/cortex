import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A card representing a chapter in the curriculum list.
///
/// Navigates to a detail view for that chapter.
class ChapterCurriculumItem extends StatelessWidget {
  const ChapterCurriculumItem({
    super.key,
    required this.chapter,
    required this.index,
    this.onTap,
    this.isSkeleton = false,
  });

  final ChapterDto chapter;
  final int index;
  final VoidCallback? onTap;
  final bool isSkeleton;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    const double iconSize = 40;

    // Consistent blue for course/chapter icons as per reference
    final iconTheme = design.study.chapter;

    final activeOnTap = isSkeleton ? null : onTap;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: design.shadows.surfaceSoft,
      ),
      child: Skeletonizer(
        enabled: isSkeleton,
        ignoreContainers: true,
        effect: ShimmerEffect(
          baseColor: design.colors.skeleton,
          highlightColor: design.colors.onSkeleton,
        ),
        child: AppSemantics.button(
          label: chapter.title,
          onTap: activeOnTap ?? () {},
          child: AppFocusable(
            onTap: activeOnTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Skeleton.replace(
                    width: iconSize,
                    height: iconSize,
                    replacement: DecoratedBox(
                      decoration: BoxDecoration(
                        color: design.colors.skeleton,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        color: chapter.image?.isNotEmpty == true
                            ? design.colors
                                .transparent // Transparent when image is present
                            : iconTheme.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _buildIcon(chapter, iconTheme),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title and Metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.cardTitle(
                          chapter.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        AppText.cardSubtitle(
                          chapter.assessmentCount > 0
                              ? l10n.chapterMetadata(
                                  chapter.lessonCount,
                                  l10n.curriculumLessonsLabel,
                                  chapter.assessmentCount,
                                  l10n.curriculumAssessmentsLabel,
                                )
                              : '${chapter.lessonCount} ${l10n.curriculumLessonsLabel}',
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
      ),
    );
  }

  Widget _buildIcon(ChapterDto chapter, ShortcutColors chapterTheme) {
    final image = chapter.image;
    if (image != null && image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _DefaultIcon(theme: chapterTheme),
        ),
      );
    }
    return _DefaultIcon(theme: chapterTheme);
  }
}

class _DefaultIcon extends StatelessWidget {
  const _DefaultIcon({required this.theme});
  final ShortcutColors theme;

  @override
  Widget build(BuildContext context) {
    return Icon(
      LucideIcons.bookOpen,
      color: theme.foreground,
      size: 20,
    );
  }
}
