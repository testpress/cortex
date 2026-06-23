import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExamPrescreenVerticalStat extends StatelessWidget {
  final DesignConfig design;
  final IconData icon;
  final String label;
  final String value;
  final String? suffix;

  const ExamPrescreenVerticalStat({
    super.key,
    required this.design,
    required this.icon,
    required this.label,
    required this.value,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;
    final effectiveColor = isSkeleton
        ? design.colors.textSecondary
        : design.colors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(design.spacing.sm),
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(design.radius.md),
          ),
          child: Icon(icon, size: 24, color: effectiveColor),
        ),
        SizedBox(height: design.spacing.sm),
        AppText.caption(
          label,
          color: design.colors.textSecondary,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
        SizedBox(height: design.spacing.xs),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            AppText.body(
              value,
              color: design.colors.textPrimary,
              style: design.typography.body.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            if (suffix != null)
              AppText.body(
                ' $suffix',
                color: design.colors.textSecondary,
                style: design.typography.caption,
              ),
          ],
        ),
      ],
    );
  }
}
