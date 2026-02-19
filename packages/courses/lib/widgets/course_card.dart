import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';

/// Course card widget displaying course information and progress.
///
/// Accepts a [CourseDto] from the data layer (repository/Riverpod).
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final CourseDto course;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          AppText.title(course.title, color: design.colors.textPrimary),
          SizedBox(height: design.spacing.sm),

          // Chapter count & duration metadata
          AppText.bodySmall(
            '${course.chapterCount} chapters · ${course.totalDuration}',
            color: design.colors.textSecondary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: design.spacing.md),

          // Progress indicator
          _ProgressIndicator(
            progress: course.progress / 100.0,
            completedLessons: course.completedLessons,
            totalLessons: course.totalLessons,
            l10n: l10n,
          ),
          SizedBox(height: design.spacing.md),

          // Action button
          AppButton.primary(
            label: course.progress > 0 ? l10n.labelContinue : l10n.labelStart,
            onPressed: () {
              // TODO: Navigate to course detail screen
            },
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

/// Custom progress indicator widget.
class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.progress,
    required this.completedLessons,
    required this.totalLessons,
    required this.l10n,
  });

  final double progress; // 0.0 to 1.0
  final int completedLessons;
  final int totalLessons;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return AppSemantics.progressValue(
      value: progress,
      label: l10n.labelCourseProgress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.caption(
                l10n.labelProgress,
                color: design.colors.textSecondary,
              ),
              AppText.caption(
                '$completedLessons / $totalLessons lessons',
                color: design.colors.textSecondary,
              ),
            ],
          ),
          SizedBox(height: design.spacing.xs),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: design.colors.progressBackground,
              borderRadius: BorderRadius.circular(design.radius.full),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: design.colors.progressForeground,
                  borderRadius: BorderRadius.circular(design.radius.full),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
