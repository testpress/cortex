import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExamPrescreenTimeline extends StatelessWidget {
  final DesignConfig design;
  final String startDateStr;
  final String endDateStr;

  const ExamPrescreenTimeline({
    super.key,
    required this.design,
    required this.startDateStr,
    required this.endDateStr,
  });

  @override
  Widget build(BuildContext context) {
    if (startDateStr.isEmpty && endDateStr.isEmpty) {
      return const SizedBox.shrink();
    }

    final isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;
    final successColor = isSkeleton
        ? design.colors.textSecondary
        : design.colors.success;
    final errorColor = isSkeleton
        ? design.colors.textSecondary
        : design.colors.error;
    final showStart = startDateStr.isNotEmpty;
    final finalEndDateStr = (endDateStr.isEmpty || endDateStr == 'N/A')
        ? L10n.of(context).examForever
        : endDateStr;

    return AppSemantics.container(
      label: L10n.of(context).semanticExamTimeline,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showStart) ...[
            Expanded(
              child: _buildNode(
                label: L10n.of(context).examStartsOn,
                value: startDateStr,
                dotColor: successColor,
              ),
            ),
            SizedBox(width: design.spacing.md),
          ],
          Expanded(
            child: _buildNode(
              label: L10n.of(context).examEndsOn,
              value: finalEndDateStr,
              dotColor: errorColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNode({
    required String label,
    required String value,
    required Color dotColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: design.spacing.xs),
            AppText.caption(
              label,
              color: design.colors.textSecondary,
              style: design.typography.caption,
            ),
          ],
        ),
        SizedBox(height: design.spacing.xs),
        AppText.body(
          value,
          color: design.colors.textPrimary,
          style: design.typography.body.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
