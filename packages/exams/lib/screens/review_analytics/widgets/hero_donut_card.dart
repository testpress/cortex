import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import '../../../models/analytics_overview.dart';
import 'donut_chart.dart';

class HeroDonutCard extends StatelessWidget {
  const HeroDonutCard({super.key, required this.overview});

  final AnalyticsOverview overview;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          AppSemantics.progressValue(
            value: overview.scorePercentage / 100,
            label: 'Overall score distribution',
            child: DonutChart(
              correct: overview.correct,
              incorrect: overview.incorrect,
              unanswered: overview.unanswered,
              size: 190,
              strokeWidth: 20,
            ),
          ),
          const SizedBox(height: 12),
          const DonutLegend(),
        ],
      ),
    );
  }
}

class DonutLegend extends StatelessWidget {
  const DonutLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: design.spacing.md,
      runSpacing: design.spacing.xs,
      children: [
        _LegendDot(label: 'Correct', color: design.colors.accent4),
        _LegendDot(label: 'Incorrect', color: design.colors.accent5),
        _LegendDot(label: 'Unanswered', color: design.colors.accent3),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: design.spacing.xs),
        AppText.caption(label, color: design.colors.textSecondary),
      ],
    );
  }
}
