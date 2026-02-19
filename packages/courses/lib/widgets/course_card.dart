import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../models/course.dart';

/// Course card widget displaying course information and progress.
///
/// Shows title, description, progress indicator, and action button.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Dynamic localization lookup based on ID
    final title = _getLocalizedTitle(l10n, course.id);
    final description = _getLocalizedDescription(l10n, course.id);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          AppText.title(title, color: design.colors.textPrimary),
          SizedBox(height: design.spacing.sm),

          // Description
          AppText.bodySmall(
            description,
            color: design.colors.textSecondary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: design.spacing.md),

          // Progress indicator
          _ProgressIndicator(progress: course.progress),
          SizedBox(height: design.spacing.md),

          // Action button
          AppButton.primary(
            label: course.isStarted ? l10n.labelContinue : l10n.labelStart,
            onPressed: () {
              // TODO: Navigate to course detail (Screen not yet implemented)
            },
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  String _getLocalizedTitle(AppLocalizations l10n, String id) {
    switch (id) {
      case '1':
        return l10n.course_1_title;
      case '2':
        return l10n.course_2_title;
      case '3':
        return l10n.course_3_title;
      case '4':
        return l10n.course_4_title;
      case '5':
        return l10n.course_5_title;
      case '6':
        return l10n.course_6_title;
      default:
        return course.title;
    }
  }

  String _getLocalizedDescription(AppLocalizations l10n, String id) {
    switch (id) {
      case '1':
        return l10n.course_1_description;
      case '2':
        return l10n.course_2_description;
      case '3':
        return l10n.course_3_description;
      case '4':
        return l10n.course_4_description;
      case '5':
        return l10n.course_5_description;
      case '6':
        return l10n.course_6_description;
      default:
        return course.description;
    }
  }
}

/// Custom progress indicator widget.
class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
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
