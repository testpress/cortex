import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../explore_constants.dart';

class ShortLessonsSection extends StatelessWidget {
  const ShortLessonsSection({super.key, required this.lessons});

  final List<ShortLessonDto> lessons;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    if (lessons.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.labelBold(
                l10n.exploreShortLessonsTitle.toUpperCase(),
                style: const TextStyle(
                  letterSpacing: ExploreConstants.sectionHeaderLetterSpacing,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: AppText.labelBold(
                  l10n.viewAllAction,
                  color: design.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: design.spacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: Row(
            children: [
              for (final lesson in lessons)
                Padding(
                  padding: EdgeInsets.only(right: design.spacing.md),
                  child: _ShortLessonCard(lesson: lesson),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShortLessonCard extends StatelessWidget {
  const _ShortLessonCard({required this.lesson});

  final ShortLessonDto lesson;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return SizedBox(
      width: ExploreConstants.cardWidth,
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with overlays
            AspectRatio(
              aspectRatio: ExploreConstants.cardAspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: design.radius.card.topLeft,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      lesson.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: design.colors.surfaceVariant,
                        child: const Center(child: Icon(LucideIcons.imageOff)),
                      ),
                    ),

                    // Dark overlay for legibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            design.colors.shadow.withValues(alpha: 0.0),
                            design.colors.shadow.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),

                    // Play Button Overlay
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: design.colors.textInverse.withValues(
                            alpha: 0.9,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.play,
                          size: 20,
                          color: design.colors.textPrimary,
                        ),
                      ),
                    ),

                    // Duration Overlay (Bottom Right)
                    Positioned(
                      bottom: design.spacing.xs,
                      right: design.spacing.xs,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: design.spacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: design.colors.shadow.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(design.radius.sm),
                        ),
                        child: Text(
                          lesson.duration,
                          style: design.typography.caption.copyWith(
                            color: design.colors.textInverse,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content Footer
            Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.cardTitle(
                    lesson.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: AppText.caption(
                          '${lesson.author}  •  ${lesson.viewCount} views',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: design.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
