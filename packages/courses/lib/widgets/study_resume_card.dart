import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:data/data.dart';

/// Floating resume card at the bottom of the Study screen.
class StudyResumeCard extends StatelessWidget {
  const StudyResumeCard({
    super.key,
    required this.activity,
    required this.onDismiss,
    required this.onResume,
  });

  final RecentActivityVo activity;
  final VoidCallback onDismiss;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.lg),
        border: Border.all(color: design.colors.border),
        boxShadow: [
          BoxShadow(
            color: design.colors.shadow.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: design.colors.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm + design.spacing.xs, // 12px
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.label(
                  activity.lessonTitle.isNotEmpty
                      ? activity.lessonTitle
                      : l10n.resumeStudyHeader,
                  color: design.colors.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                AppText.caption(
                  activity.courseTitle,
                  color: design.colors.textSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: design.spacing.md),
          GestureDetector(
            onTap: onResume,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.sm + 2,
                vertical: design.spacing.xs,
              ),
              decoration: BoxDecoration(
                color: design.colors.onPrimaryContainer,
                borderRadius: design.radius.button,
              ),
              child: AppText.label(
                l10n.labelResume,
                color: design.colors.textInverse,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
