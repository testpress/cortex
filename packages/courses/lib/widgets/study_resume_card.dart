import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:data/data.dart';

/// Floating resume card at the bottom of the Study screen.
class StudyResumeCard extends StatelessWidget {
  const StudyResumeCard({
    super.key,
    required this.activity,
    required this.onResume,
  });

  final RecentActivityVo activity;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppCard(
      showFloatingShadow: true,
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
                AppText.cardTitle(
                  activity.lessonTitle.isNotEmpty
                      ? activity.lessonTitle
                      : l10n.resumeStudyHeader,
                  color: design.colors.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: design.spacing.xs),
                AppText.cardSubtitle(
                  '${activity.courseTitle}${activity.chapterTitle.isNotEmpty ? ' • ${activity.chapterTitle}' : ''}',
                  color: design.colors.textSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: design.spacing.md),
          AppButton.primary(
            label: l10n.labelResume,
            onPressed: onResume,
            height: 32,
            backgroundColor: design.colors.textPrimary,
            foregroundColor: design.colors.textInverse,
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          ),
        ],
      ),
    );
  }
}
