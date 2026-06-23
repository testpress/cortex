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
        ? 'Forever'
        : endDateStr;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showStart) ...[
          Expanded(
            child: _buildNode(
              label: 'Starts On',
              value: startDateStr,
              dotColor: successColor,
            ),
          ),
          SizedBox(width: design.spacing.md),
        ],
        Expanded(
          child: _buildNode(
            label: 'Ends On',
            value: finalEndDateStr,
            dotColor: errorColor,
          ),
        ),
      ],
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
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        AppText.body(
          value,
          color: design.colors.textPrimary,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
