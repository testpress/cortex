import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// A single legend row for the QOTD donut chart breakdown.
class QotdChartLegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const QotdChartLegendRow({
    super.key,
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: design.spacing.sm),
        AppText.label(
          label,
          color: design.colors.textSecondary,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
        const Spacer(),
        AppText.labelBold(
          '$count',
          color: design.colors.textPrimary,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
