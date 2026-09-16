import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExamPrescreenMarkCard extends StatelessWidget {
  final DesignConfig design;
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const ExamPrescreenMarkCard({
    super.key,
    required this.design,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;
    final effectiveColor = isSkeleton ? design.colors.textSecondary : color;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(design.spacing.sm),
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: effectiveColor),
        ),
        SizedBox(width: design.spacing.sm),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.caption(
                label,
                color: design.colors.textSecondary,
                style: design.typography.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: AppText.body(
                  value,
                  color: effectiveColor,
                  style: design.typography.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
