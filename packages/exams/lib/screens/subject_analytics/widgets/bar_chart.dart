import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/models/review_models.dart';
import '../subject_analytics_screen.dart';

const double _minPctForStackedLabel = 12.0;
const double _minPctForInsideLabel = 30.0;

class BarRow extends StatelessWidget {
  const BarRow({super.key, required this.subject, required this.activeFilter});

  final SubjectAnalyticsDto subject;
  final String activeFilter;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final correctPct = subject.correctPercentage;
    final incorrectPct = subject.incorrectPercentage;
    final unansweredPct = subject.unansweredPercentage;

    // Convert double percentage to integer flex weight
    final correctFlex = (correctPct * 10).round();
    final incorrectFlex = (incorrectPct * 10).round();
    final unansweredFlex = (unansweredPct * 10).round();

    // Determine colors based on active filter
    final isCorrectActive = activeFilter == 'All' || activeFilter == 'Correct';
    final isIncorrectActive =
        activeFilter == 'All' || activeFilter == 'Incorrect';
    final isUnansweredActive =
        activeFilter == 'All' || activeFilter == 'Unanswered';

    final Color correctColor = isCorrectActive
        ? design.correctColor
        : design.colors.surfaceVariant;

    final Color incorrectColor = isIncorrectActive
        ? design.incorrectColor
        : design.colors.surfaceVariant;

    final Color unansweredColor = isUnansweredActive
        ? design.unansweredColor
        : design.colors.surfaceVariant;

    // Determine single-metric variables using a clean switch expression
    final (pct, activeColor) = switch (activeFilter) {
      'Correct' => (correctPct, design.correctColor),
      'Incorrect' => (incorrectPct, design.incorrectColor),
      'Unanswered' => (unansweredPct, design.unansweredColor),
      _ => (0.0, design.colors.transparent),
    };

    final activeBgColor = activeColor == design.colors.transparent
        ? design.colors.transparent
        : activeColor.withValues(alpha: 0.1);

    final labelText = activeColor == design.colors.transparent
        ? ''
        : '${pct.toStringAsFixed(pct % 1 == 0 ? 0 : 1)}%';

    final activeFlex = (pct * 10).round();
    final remainingFlex = ((100.0 - pct) * 10).round();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Subject Label - 128 width
          SizedBox(
            width: design.spacing.xxxl * 2,
            child: AppText.xs(
              subject.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
              color: design.colors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: design.spacing.sm + design.spacing.xs,
          ), // 12px gap using design tokens
          // Stacked Bar - 24 height (lg token)
          Expanded(
            child: Container(
              height: design.spacing.lg,
              decoration: BoxDecoration(
                color: design.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(
                  design.radius.sm,
                ), // 4px border radius
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: activeFilter == 'All'
                    ? [
                        _BarSegment(
                          flex: correctFlex,
                          color: correctColor,
                          pct: correctPct,
                        ),
                        _BarSegment(
                          flex: incorrectFlex,
                          color: incorrectColor,
                          pct: incorrectPct,
                        ),
                        _BarSegment(
                          flex: unansweredFlex,
                          color: unansweredColor,
                          pct: unansweredPct,
                          padding: EdgeInsets.only(
                            right: design.spacing.sm,
                          ), // 8px padding using token
                        ),
                      ]
                    : [
                        _SingleMetricSegment(
                          flex: activeFlex,
                          color: activeColor,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: design.spacing.sm),
                          showLabel: pct >= _minPctForInsideLabel,
                          labelText: labelText,
                          textColor: design.colors.textInverse,
                        ),
                        _SingleMetricSegment(
                          flex: remainingFlex,
                          color: activeBgColor,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: design.spacing.sm),
                          showLabel: pct < _minPctForInsideLabel,
                          labelText: labelText,
                          textColor: activeColor,
                        ),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarSegment extends StatelessWidget {
  const _BarSegment({
    required this.flex,
    required this.color,
    required this.pct,
    this.padding,
  });

  final int flex;
  final Color color;
  final double pct;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    if (flex <= 0) return const SizedBox.shrink();

    return Expanded(
      flex: flex,
      child: Container(
        color: color,
        alignment: Alignment.center,
        padding: padding,
        child: pct >= _minPctForStackedLabel
            ? AppText.xxs(
                '${pct.toStringAsFixed(pct % 1 == 0 ? 0 : 1)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.06,
                ),
                color: design.colors.textInverse,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _SingleMetricSegment extends StatelessWidget {
  const _SingleMetricSegment({
    required this.flex,
    required this.color,
    required this.alignment,
    required this.padding,
    required this.showLabel,
    required this.labelText,
    required this.textColor,
  });

  final int flex;
  final Color color;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;
  final bool showLabel;
  final String labelText;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    if (flex <= 0) return const SizedBox.shrink();
    return Expanded(
      flex: flex,
      child: Container(
        color: color,
        alignment: alignment,
        padding: padding,
        child: showLabel
            ? AppText.xxs(
                labelText,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.06,
                ),
                color: textColor,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
