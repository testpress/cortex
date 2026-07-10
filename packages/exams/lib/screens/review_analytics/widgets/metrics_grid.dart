import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../../../models/analytics_overview.dart';
import 'review_analytics_formatters.dart';

enum _PerformanceState { low, average, good }

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({super.key, required this.overview});

  final AnalyticsOverview overview;

  _PerformanceState get _state {
    switch (overview.performanceLevel.toLowerCase()) {
      case 'excellent':
      case 'good':
        return _PerformanceState.good;
      case 'average':
        return _PerformanceState.average;
      default:
        return _PerformanceState.low;
    }
  }

  Color _getStateColor(DesignConfig design) {
    switch (_state) {
      case _PerformanceState.good:
        return design.colors.success;
      case _PerformanceState.average:
        return design.colors.warning;
      case _PerformanceState.low:
        return design.colors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = context.l10n;
    final stateColor = _getStateColor(design);

    final attemptedPercent = overview.totalQuestions > 0
        ? (overview.attemptedQuestions / overview.totalQuestions * 100)
              .toStringAsFixed(1)
        : '0';

    final attemptedMetric = _MetricData(
      label: l10n.reviewAttempted,
      value: '${overview.attemptedQuestions}',
      subValue: ' / ${overview.totalQuestions}',
      bottomText: '$attemptedPercent% ${l10n.reviewOfTotal}',
      progressValue: overview.totalQuestions > 0
          ? overview.attemptedQuestions / overview.totalQuestions
          : 0.0,
      progressColor: design.colors.primary,
      iconData: LucideIcons.fileText,
      iconColor: design.colors.primary,
    );

    final correctMetric = _MetricData(
      label: l10n.reviewCorrect,
      value: '${overview.correct}',
      subValue: ' / ${overview.totalQuestions}',
      bottomText:
          '${((overview.totalQuestions > 0 ? overview.correct / overview.totalQuestions : 0.0) * 100).toStringAsFixed(1)}% ${l10n.reviewOfTotal}',
      progressValue: overview.totalQuestions > 0
          ? overview.correct / overview.totalQuestions
          : 0.0,
      progressColor: design.colors.success,
      iconData: LucideIcons.checkCircle,
      iconColor: design.colors.success,
    );

    final accuracyMetric = _MetricData(
      label: l10n.reviewAccuracy,
      value: '${overview.accuracy.toStringAsFixed(1)}%',
      bottomText:
          '${overview.correct} out of ${overview.attemptedQuestions} ${l10n.reviewCorrect.toLowerCase()}',
      progressValue: overview.accuracy / 100.0,
      progressColor: design.colors.primary,
      iconData: LucideIcons.target,
      iconColor: design.colors.primary,
    );

    final timePercent =
        overview.totalTime != null && overview.totalTime!.inSeconds > 0
        ? ((overview.timeTaken?.inSeconds ?? 0) /
                  overview.totalTime!.inSeconds *
                  100)
              .toStringAsFixed(1)
        : '0';

    final timeTakenMetric = _MetricData(
      label: l10n.reviewTimeTaken,
      value: formatDuration(overview.timeTaken),
      subValue: overview.totalTime != null
          ? ' / ${formatDuration(overview.totalTime, showUnit: true)}'
          : null,
      bottomText: '$timePercent% ${l10n.reviewOfTotal}',
      progressValue:
          overview.totalTime != null && overview.totalTime!.inSeconds > 0
          ? ((overview.timeTaken?.inSeconds ?? 0) /
                    overview.totalTime!.inSeconds)
                .clamp(0.0, 1.0)
          : null,
      progressColor: design.colors.primary,
      iconData: LucideIcons.clock,
      iconColor: design.colors.primary,
    );

    final rankMetric = overview.rankEnabled == true
        ? _MetricData(
            label: l10n.reviewRank,
            value: '${overview.overallRank}',
            subValue: ' / ${overview.totalParticipants}',
            iconData: LucideIcons.award,
            iconColor: design.colors.warning,
          )
        : _MetricData(
            label: l10n.reviewRank,
            value: '-',
            iconData: LucideIcons.award,
            iconColor: design.colors.warning,
          );

    final percentileMetric = _MetricData(
      label: l10n.reviewPercentile,
      value: '${overview.percentile.toStringAsFixed(1)}%',
      iconData: LucideIcons.barChart2,
      iconColor: stateColor,
    );

    final metrics = [
      attemptedMetric,
      correctMetric,
      accuracyMetric,
      timeTakenMetric,
      rankMetric,
      percentileMetric,
    ];

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: design.layout.tabletBreakpoint),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ScoreCard(
              overview: overview,
              state: _state,
              stateColor: stateColor,
            ),
            SizedBox(height: design.spacing.md),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _MetricCard(metric: metrics[0])),
                  SizedBox(width: design.spacing.sm),
                  Expanded(child: _MetricCard(metric: metrics[1])),
                ],
              ),
            ),
            SizedBox(height: design.spacing.sm),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _MetricCard(metric: metrics[2])),
                  SizedBox(width: design.spacing.sm),
                  Expanded(child: _MetricCard(metric: metrics[3])),
                ],
              ),
            ),
            SizedBox(height: design.spacing.sm),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _MetricCard(metric: metrics[4])),
                  SizedBox(width: design.spacing.sm),
                  Expanded(child: _MetricCard(metric: metrics[5])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.overview,
    required this.state,
    required this.stateColor,
  });

  final AnalyticsOverview overview;
  final _PerformanceState state;
  final Color stateColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = context.l10n;

    Color bgColor;
    IconData iconData;
    String performanceText;

    switch (state) {
      case _PerformanceState.good:
        bgColor = design.colors.success.withValues(alpha: 0.06);
        iconData = LucideIcons.smile;
        performanceText = l10n.reviewPerformanceExcellent;
        break;
      case _PerformanceState.average:
        bgColor = design.colors.warning.withValues(alpha: 0.06);
        iconData = LucideIcons.meh;
        performanceText = l10n.reviewPerformanceAverage;
        break;
      case _PerformanceState.low:
        bgColor = design.colors.error.withValues(alpha: 0.06);
        iconData = LucideIcons.frown;
        performanceText = l10n.reviewPerformanceLow;
        break;
    }

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: design.radius.card,
        border: Border.all(color: stateColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.labelBold(l10n.reviewScore),
              SizedBox(height: design.spacing.xs),
              RichText(
                text: TextSpan(
                  style: design.typography.display.copyWith(
                    color: state == _PerformanceState.low
                        ? design.colors.textPrimary
                        : stateColor,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(
                      text: overview.totalScore.toDouble().toStringAsFixed(2),
                    ),
                    TextSpan(
                      text: ' / ${overview.maxScore}',
                      style: design.typography.title,
                    ),
                  ],
                ),
              ),
              SizedBox(height: design.spacing.md),
              Row(
                children: [
                  Icon(iconData, color: stateColor, size: design.iconSize.md),
                  SizedBox(width: design.spacing.xs),
                  AppText.labelBold(
                    performanceText,
                    color: stateColor,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(overview.maxScore > 0 ? (overview.totalScore / overview.maxScore * 100) : 0.0).toStringAsFixed(1)}%',
                style: design.typography.title.copyWith(
                  fontWeight: FontWeight.w700,
                  color: state == _PerformanceState.low
                      ? design.colors.textPrimary
                      : stateColor,
                ),
              ),
              Text(
                l10n.reviewOfTotal,
                style: design.typography.bodySmall.copyWith(
                  color: design.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.label,
    required this.value,
    this.subValue,
    this.bottomText,
    this.progressValue,
    this.progressColor,
    this.iconData,
    this.iconColor,
  });

  final String label;
  final String value;
  final String? subValue;
  final String? bottomText;
  final double? progressValue;
  final Color? progressColor;
  final IconData? iconData;
  final Color? iconColor;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _MetricData metric;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return AppSemantics.container(
      label: metric.label,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.lg,
        ),
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: design.radius.card,
          border: Border.all(color: design.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (metric.iconData != null)
                  Container(
                    padding: EdgeInsets.all(design.spacing.xs),
                    margin: EdgeInsets.only(right: design.spacing.xs),
                    decoration: BoxDecoration(
                      color:
                          metric.iconColor?.withValues(alpha: 0.1) ??
                          design.colors.border,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      metric.iconData,
                      size: design.iconSize.sm,
                      color: metric.iconColor,
                    ),
                  ),
                Expanded(child: AppText.cardTitle(metric.label)),
              ],
            ),
            SizedBox(height: design.spacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                        style: design.typography.cardSubtitle,
                      ),
                  ],
                ),
              ),
            ),
            if (metric.bottomText != null) ...[
              SizedBox(height: design.spacing.sm),
              AppText.cardSubtitle(metric.bottomText!),
            ],
            if (metric.progressValue != null &&
                metric.progressColor != null) ...[
              SizedBox(height: design.spacing.sm),
              _ProgressBar(
                value: metric.progressValue!,
                color: metric.progressColor!,
                label: metric.label,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.value,
    required this.color,
    required this.label,
  });

  final double value;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return AppSemantics.progressValue(
      value: value,
      label: label,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(design.radius.sm),
        child: LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          minHeight: 4,
          color: color,
          backgroundColor: color.withValues(alpha: 0.15),
        ),
      ),
    );
  }
}
