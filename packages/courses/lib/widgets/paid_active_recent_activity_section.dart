import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../models/recent_activity_dto.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({
    super.key,
    required this.activities,
  });

  final List<RecentActivityDto> activities;

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: AppText.title(
            l10n.profileRecentLearningTitle,
            color: design.colors.textPrimary,
          ),
        ),
        SizedBox(height: design.spacing.md),
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: activities.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: design.spacing.md),
            itemBuilder: (context, index) {
              return _RecentActivityCard(activity: activities[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({required this.activity});
  final RecentActivityDto activity;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return SizedBox(
      width: 220,
      child: AppCard(
        padding: EdgeInsets.all(design.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon + Status Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTypeIcon(context),
                _buildStatusPill(context),
              ],
            ),
            const Spacer(),
            // Middle: Title
            AppText.cardTitle(
              activity.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: design.spacing.sm),
            // Bottom: Context
            _buildContext(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIcon(BuildContext context) {
    final design = Design.of(context);
    IconData icon;
    Color color;

    switch (activity.type) {
      case ActivityType.video:
        icon = LucideIcons.playCircle;
        color = design.colors.accent1; // Purple
        break;
      case ActivityType.test:
        icon = LucideIcons.shieldCheck;
        color = design.colors.accent3; // Orange
        break;
      case ActivityType.notes:
        icon = LucideIcons.fileText;
        color = design.colors.success; // Green/Emerald
        break;
      case ActivityType.lesson:
        icon = LucideIcons.bookOpen;
        color = design.colors.accent2; // Blue
        break;
      case ActivityType.assessment:
        icon = LucideIcons.fileCheck;
        color = design.colors.success; // Green/Emerald
        break;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(design.radius.lg),
      ),
      child: Icon(
        icon,
        color: color,
        size: design.iconSize.md,
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context) {
    final design = Design.of(context);
    final isCompleted = activity.status == ActivityStatus.completed;
    final color = isCompleted ? design.colors.success : design.colors.accent2;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.sm,
        vertical: design.spacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(design.radius.full),
      ),
      child: AppText.labelSmall(
        isCompleted ? 'Completed' : 'In progress',
        color: color,
      ),
    );
  }

  Widget _buildContext(BuildContext context) {
    final design = Design.of(context);
    String mainText = '';
    
    if (activity.status == ActivityStatus.completed) {
      if (activity.score != null) {
        mainText = 'Score: ${activity.score}%';
      } else {
        mainText = 'Completed';
      }
    } else {
      if (activity.progress != null) {
        mainText = '${activity.progress}% watched so far';
      } else {
        mainText = 'Started';
      }
    }

    return AppText.xs(
      '$mainText • ${activity.timeAgo}',
      color: design.colors.textSecondary,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
