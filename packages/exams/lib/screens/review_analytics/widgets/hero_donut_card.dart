import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import '../../../models/analytics_overview.dart';
import 'donut_chart.dart';
import 'donut_legend.dart';

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
