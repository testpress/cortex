import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';

/// A badge that displays the progress status of a lesson.
///
/// Maps [LessonProgressStatus] to systematic [DesignStatusColors] tokens.
/// Re-designed as per user request to remove "locked" visuals for paid users.
class LessonStatusBadge extends StatelessWidget {
  const LessonStatusBadge({super.key, required this.status});

  final LessonProgressStatus status;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Paid users according to the USER should not see "locked" status in this view.
    // If it's completed, show green badge. Otherwise, don't show or show "Not Started/In Progress".

    switch (status) {
      case LessonProgressStatus.completed:
        return AppBadge(
          label: l10n.statusCompleted,
          semanticStatus: design.statusColors.completed,
        );
      case LessonProgressStatus.inProgress:
        return AppBadge(
          label: l10n.statusInProgress,
          semanticStatus: design
              .statusColors
              .upcoming, // Using upcoming (blue) for progress
        );
      case LessonProgressStatus.notStarted:
        return const SizedBox.shrink();
    }
  }
}
