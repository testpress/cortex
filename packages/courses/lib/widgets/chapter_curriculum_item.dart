import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        label: chapter.title,
        onTap: onTap ?? () {},
        child: AppFocusable(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Skeletonizer(
            enabled: isSkeleton,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icon Box (md: 40x40)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: chapter.image?.isNotEmpty == true
                          ? design.colors.transparent // Transparent when image is present
                          : iconTheme.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildIcon(context, chapter, iconTheme, design),
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
      ),
    );
  }

  Widget _buildIcon(BuildContext context, ChapterDto chapter, ShortcutColors chapterTheme, DesignConfig design) {
    final image = chapter.image;
    if (image != null && image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholder: (context, url) => Container(
            color: design.colors.skeleton,
          ),
          errorWidget: (context, url, error) => _DefaultIcon(theme: chapterTheme),
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
