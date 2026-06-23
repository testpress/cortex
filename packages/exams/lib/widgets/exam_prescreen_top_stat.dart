import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class ExamPrescreenTopStat extends StatelessWidget {
  final DesignConfig design;
  final IconData icon;
  final String label;
  final String value;

  const ExamPrescreenTopStat({
    super.key,
    required this.design,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: design.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: design.colors.primary),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.cardTitle(
                label,
                color: design.colors.textSecondary,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              AppText.labelBold(
                value,
                color: design.colors.textSecondary,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
