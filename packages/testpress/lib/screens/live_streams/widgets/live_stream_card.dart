import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';

enum LiveStreamStatus { live, upcoming, completed, cancelled }

class LiveStreamItem {
  const LiveStreamItem({
    required this.id,
    required this.title,
    required this.courseName,
    required this.start,
    required this.status,
    this.durationMinutes,
  });

  final String id;
  final String title;
  final String courseName;
  final DateTime start;
  final LiveStreamStatus status;
  final int? durationMinutes;
}

/// Card widget for a single live stream entry.
class LiveStreamCard extends StatelessWidget {
  const LiveStreamCard({super.key, required this.item, this.onTap});

  final LiveStreamItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;

    final accentColor = switch (item.status) {
      LiveStreamStatus.live => design.statusColors.live.foreground,
      LiveStreamStatus.upcoming => design.statusColors.upcoming.foreground,
      LiveStreamStatus.completed => design.statusColors.completed.foreground,
      LiveStreamStatus.cancelled => design.statusColors.locked.foreground,
    };

    return AppSemantics.button(
      label: item.title,
      onTap: onTap ?? () {},
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AppCard(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: design.radius.card,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left accent strip
                  if (!isSkeleton)
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.only(
                          topLeft: design.radius.card.topLeft,
                          bottomLeft: design.radius.card.bottomLeft,
                        ),
                      ),
                    ),
                  // Card content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.md,
                        vertical: design.spacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.cardTitle(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            color: design.colors.textPrimary,
                          ),
                          SizedBox(height: design.spacing.xs),
                          AppText.cardCaption(
                            item.courseName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: design.spacing.md),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.calendar,
                                size: 13,
                                color: design.colors.textSecondary,
                              ),
                              SizedBox(width: design.spacing.xs),
                              AppText.cardCaption(
                                DateFormat(
                                  'd MMM yyyy · h:mm a',
                                ).format(item.start),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              _Dot(design: design),
                              Icon(
                                LucideIcons.clock,
                                size: 13,
                                color: design.colors.textSecondary,
                              ),
                              SizedBox(width: design.spacing.xs),
                              AppText.cardCaption(
                                L10n.of(context).liveClassesDurationMins(
                                  item.durationMinutes ?? 0,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: design.spacing.sm),
                          _StatusBadge(status: item.status),
                        ],
                      ),
                    ),
                  ),
                  // Chevron
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.sm,
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.chevronRight,
                        size: 18,
                        color: design.colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Format dates directly using DateFormat instead of custom helper methods
}

class _Dot extends StatelessWidget {
  const _Dot({required this.design});
  final DesignConfig design;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.sm),
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          color: design.colors.textSecondary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final LiveStreamStatus status;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final l10n = L10n.of(context);

    final (label, bg, fg) = switch (status) {
      LiveStreamStatus.live => (
        l10n.liveClassesFilterLive.toUpperCase(),
        design.statusColors.live.background,
        design.statusColors.live.foreground,
      ),
      LiveStreamStatus.upcoming => (
        l10n.liveClassesFilterUpcoming.toUpperCase(),
        design.statusColors.upcoming.background,
        design.statusColors.upcoming.foreground,
      ),
      LiveStreamStatus.completed => (
        l10n.liveClassesFilterCompleted.toUpperCase(),
        design.statusColors.completed.background,
        design.statusColors.completed.foreground,
      ),
      LiveStreamStatus.cancelled => (
        l10n.liveClassesFilterCancelled.toUpperCase(),
        design.statusColors.locked.background,
        design.statusColors.locked.foreground,
      ),
    };

    return Skeleton.leaf(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: AppText.labelBold(
          label,
          color: fg,
          style: const TextStyle(fontSize: 10, letterSpacing: 0.4, height: 1.2),
        ),
      ),
    );
  }
}
