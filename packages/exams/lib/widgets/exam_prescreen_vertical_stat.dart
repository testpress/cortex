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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: effectiveColor),
        ),
        const SizedBox(height: 8),
        AppText.caption(
          label,
          color: design.colors.textSecondary,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            AppText.body(
              value,
              color: design.colors.textPrimary,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                height: 1.2,
              ),
            ),
            if (suffix != null)
              AppText.body(
                ' $suffix',
                color: design.colors.textSecondary,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
