import 'package:core/design/design_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/design/design_provider.dart';
import '../models/course.dart';

/// Course card widget displaying course information and progress.
///
/// Shows title, description, progress indicator, and action button.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          AppText.title(course.title, color: AppColors.textPrimary),
          const SizedBox(height: AppSpacing.sm),

          // Description
          AppText.bodySmall(
            course.description,
            color: AppColors.textSecondary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),

          // Progress indicator
          _ProgressIndicator(progress: course.progress),
          const SizedBox(height: AppSpacing.md),

          // Action button
          AppButton.primary(
            label: course.isStarted ? 'Continue' : 'Start',
            onPressed: () {
              // TODO: Navigate to course detail
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
  const _ProgressIndicator({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return AppSemantics.progressValue(
      value: progress,
      label: 'Course progress',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.caption('Progress', color: design.colors.textSecondary),
              AppText.caption(
                '${(progress * 100).toInt()}%',
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
              widthFactor: progress,
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
