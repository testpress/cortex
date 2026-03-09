import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import '../../../models/analytics_overview.dart';
import 'performance_gradient_bar.dart';

class OverallPerformanceCard extends StatelessWidget {
  const OverallPerformanceCard({super.key, required this.overview});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.body(
                'Overall Performance',
                color: design.colors.textPrimary,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Builder(
                builder: (context) {
                  final level = overview.performanceLevel.toLowerCase();
                  Color levelColor = design.colors.success;
                  if (level == 'bad') {
                    levelColor = design.colors.error;
                  } else if (level == 'average') {
                    levelColor = design.colors.warning;
                  } else if (level == 'good') {
                    levelColor = design.colors.primary;
                  }

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.sm,
                      vertical: design.spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: levelColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(design.radius.full),
                    ),
                    child: AppText.caption(
                      overview.performanceLevel,
                      color: levelColor,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: design.spacing.sm),
          AppSemantics.progressValue(
            value: overview.scorePercentage / 100,
            label: 'Overall performance score',
            child: PerformanceGradientBar(percentage: overview.scorePercentage),
          ),
        ],
      ),
    );
  }
}
