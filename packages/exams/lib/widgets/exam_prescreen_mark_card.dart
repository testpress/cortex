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
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: effectiveColor),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.caption(
              label,
              color: design.colors.textSecondary,
              style: const TextStyle(fontSize: 12),
            ),
            AppText.body(
              value,
              color: effectiveColor,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
