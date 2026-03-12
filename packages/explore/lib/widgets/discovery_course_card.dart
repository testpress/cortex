import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../explore_constants.dart';

class DiscoveryCourseCard extends StatelessWidget {
  const DiscoveryCourseCard({super.key, required this.course});

  final DiscoveryCourseDto course;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Badge
          Stack(
            children: [
              AspectRatio(
                aspectRatio: ExploreConstants.cardAspectRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: design.radius.card.topLeft,
                    topRight: design.radius.card.topRight,
                  ),
                  child: Image.network(
                    course.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: design.colors.surfaceVariant,
                      child: const Center(child: Icon(LucideIcons.imageOff)),
                    ),
                  ),
                ),
              ),
              if (course.badge != null)
                Positioned(
                  top: design.spacing.sm,
                  right: design.spacing.sm,
                  child: AppBadge(
                    label: course.badge!,
                    backgroundColor: design.colors.overlay.withValues(
                      alpha: 0.8,
                    ),
                    foregroundColor: design.colors.textInverse,
                  ),
                ),
            ],
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(design.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.cardTitle(
                  course.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: design.spacing.xs),
                Row(
                  children: [
                    Icon(
                      LucideIcons.clock,
                      size: 14,
                      color: design.colors.textSecondary,
                    ),
                    SizedBox(width: design.spacing.xs),
                    AppText.caption(course.duration),
                  ],
                ),
                SizedBox(height: design.spacing.xs),
                Row(
                  children: [
                    Icon(
                      LucideIcons.users,
                      size: 14,
                      color: design.colors.textSecondary,
                    ),
                    SizedBox(width: design.spacing.xs),
                    AppText.caption(course.learnerCount),
                    const Spacer(),
                    AppText.title(
                      course.price,
                      color: design.colors.textPrimary,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
