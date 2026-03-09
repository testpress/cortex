import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import '../../../models/analytics_overview.dart';
import 'review_analytics_formatters.dart';

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({super.key, required this.overview});

  final AnalyticsOverview overview;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricData(
        label: 'Total Score',
        value:
            '${overview.totalScore}/${overview.maxScore} (${overview.scorePercentage.toStringAsFixed(1)}%)',
      ),
      _MetricData(
        label: 'Attempted',
        value: '${overview.attemptedQuestions}/${overview.totalQuestions}',
      ),
      _MetricData(
        label: 'Percentile',
        value: '${overview.percentile.toStringAsFixed(1)}%',
      ),
      _MetricData(
        label: 'Accuracy',
        value: '${overview.accuracy.toStringAsFixed(1)}%',
      ),
      _MetricData(
        label: 'Time Taken',
        value: formatDuration(overview.timeTaken),
        subValue: ' / ${formatDuration(overview.totalTime, showUnit: true)}',
      ),
      _MetricData(
        label: 'Overall Rank',
        value: '${overview.overallRank}',
        subValue: ' / ${overview.totalParticipants}',
      ),
    ];

    return GridView.builder(
      itemCount: metrics.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.75,
      ),
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return _MetricCard(metric: metric);
      },
    );
  }
}

class _MetricData {
  const _MetricData({required this.label, required this.value, this.subValue});

  final String label;
  final String value;
  final String? subValue;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _MetricData metric;

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              AppText.labelSmall(
                metric.label,
                color: design.colors.textSecondary,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (metric.label == 'Percentile' || metric.label == 'Accuracy')
                Padding(
                  padding: EdgeInsets.only(left: design.spacing.xs),
                  child: Icon(
                    LucideIcons.info,
                    size: 12,
                    color: design.colors.textSecondary,
                  ),
                ),
            ],
          ),
          SizedBox(height: design.spacing.xs),
          RichText(
            text: TextSpan(
              style: design.typography.title.copyWith(
                color: design.colors.textPrimary,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              children: [
                TextSpan(text: metric.value),
                if (metric.subValue != null)
                  TextSpan(
                    text: metric.subValue,
                    style: design.typography.bodySmall.copyWith(
                      color: design.colors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
