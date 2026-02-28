import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../models/today_schedule.dart';

class ContentIcon extends StatelessWidget {
  const ContentIcon({super.key, required this.status});
  final ClassStatus status;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return switch (status) {
      ClassStatus.live => Icon(
        LucideIcons.video,
        size: 20,
        color: design.colors.error,
      ),
      ClassStatus.completed => Icon(
        LucideIcons.checkCircle2,
        size: 20,
        color: design.colors.success,
      ),
      ClassStatus.upcoming => Icon(
        LucideIcons.clock,
        size: 20,
        color: design.colors.warning,
      ),
    };
  }
}

class AssignmentIcon extends StatelessWidget {
  const AssignmentIcon({super.key, required this.status});
  final AssignmentStatus status;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return switch (status) {
      AssignmentStatus.overdue => Icon(
        LucideIcons.alertCircle,
        size: 20,
        color: design.colors.error,
      ),
      AssignmentStatus.submitted => Icon(
        LucideIcons.checkCircle2,
        size: 20,
        color: design.colors.success,
      ),
      AssignmentStatus.pending => Icon(
        LucideIcons.clock,
        size: 20,
        color: design.colors.warning,
      ),
    };
  }
}

class TestIcon extends StatelessWidget {
  const TestIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Icon(
      LucideIcons.shieldCheck,
      size: 20,
      color: design.colors.warning,
    );
  }
}

class PillBadge extends StatelessWidget {
  const PillBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(design.radius.full),
      ),
      child: AppText.labelSmall(label, color: design.colors.textInverse),
    );
  }
}

/// A unified card layout for today's snapshot items to ensure UI consistency.
class SnapshotCard extends StatelessWidget {
  const SnapshotCard({
    super.key,
    required this.icon,
    required this.title,
    this.titleSuffix,
    this.subtitles = const [],
    this.bottomAction,
    this.isCompleted = false,
    this.chevronSize = 20,
  });

  final Widget icon;
  final String title;
  final Widget? titleSuffix;
  final List<String> subtitles;
  final Widget? bottomAction;
  final bool isCompleted;
  final double chevronSize;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      showShadow: true,
      padding: const EdgeInsets.all(12),
      child: Opacity(
        opacity: isCompleted ? 0.6 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText.cardTitle(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (titleSuffix != null) ...[
                            const SizedBox(width: 8),
                            titleSuffix!,
                          ],
                        ],
                      ),
                      for (final sub in subtitles) ...[
                        const SizedBox(height: 2),
                        AppText.cardSubtitle(
                          sub,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: chevronSize,
                  color: isCompleted
                      ? design.colors.textTertiary.withValues(alpha: 0.5)
                      : design.colors.textTertiary,
                ),
              ],
            ),
            if (bottomAction != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: bottomAction!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
