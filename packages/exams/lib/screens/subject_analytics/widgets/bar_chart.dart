import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/models/review_models.dart';
import '../subject_analytics_screen.dart';

import 'package:skeletonizer/skeletonizer.dart';

const double _minPctForStackedLabel = 20.0;
const double _minPctForInsideLabel = 30.0;

String formatPct(double pct) => '${pct.toStringAsFixed(pct % 1 == 0 ? 0 : 2)}%';

Widget _barLabel(String text, Color color, bool isLargeText) {
  return FittedBox(
    fit: BoxFit.scaleDown,
    child: isLargeText
        ? AppText.xs(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600),
            color: color,
            maxLines: 1,
          )
        : AppText.xxs(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 0.06,
            ),
            color: color,
            maxLines: 1,
          ),
  );
}

class BarRow extends StatelessWidget {
  const BarRow({
    super.key,
    required this.subjectAnalytics,
    required this.activeFilter,
    this.showLabel = true,
    this.contentPadding,
    this.fixedLabelWidth = true,
    this.height,
    this.isLargeText = false,
  });

  final SubjectAnalyticsDto subjectAnalytics;
  final String activeFilter;
  final bool showLabel;
  final EdgeInsetsGeometry? contentPadding;
  final bool fixedLabelWidth;
  final double? height;
  final bool isLargeText;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isSkeleton =
        Skeletonizer.maybeOf(context)?.enabled == true ||
        subjectAnalytics.id == 0;

    final correctPct = subjectAnalytics.correctPercentage;
    final incorrectPct = subjectAnalytics.incorrectPercentage;
    final unansweredPct = subjectAnalytics.unansweredPercentage;

    final correctFlex = (correctPct * 10).round();
    final incorrectFlex = (incorrectPct * 10).round();
    final unansweredFlex = (unansweredPct * 10).round();

    final isCorrectActive = activeFilter == 'All' || activeFilter == 'Correct';
    final isIncorrectActive =
        activeFilter == 'All' || activeFilter == 'Incorrect';
    final isUnansweredActive =
        activeFilter == 'All' || activeFilter == 'Unanswered';

    final Color correctColor = isSkeleton
        ? design.colors.surfaceVariant
        : (isCorrectActive
              ? design.correctColor
              : design.colors.surfaceVariant);

    final Color incorrectColor = isSkeleton
        ? design.colors.surfaceVariant
        : (isIncorrectActive
              ? design.incorrectColor
              : design.colors.surfaceVariant);

    final Color unansweredColor = isSkeleton
        ? design.colors.surfaceVariant
        : (isUnansweredActive
              ? design.unansweredColor
              : design.colors.surfaceVariant);

    final (pct, baseActiveColor) = switch (activeFilter) {
      'Correct' => (correctPct, design.correctColor),
      'Incorrect' => (incorrectPct, design.incorrectColor),
      'Unanswered' => (unansweredPct, design.unansweredColor),
      _ => (0.0, design.colors.transparent),
    };

    final activeColor = isSkeleton
        ? design.colors.surfaceVariant
        : baseActiveColor;

    final activeBgColor = activeColor == design.colors.transparent
        ? design.colors.transparent
        : activeColor.withValues(alpha: 0.1);

    final labelText = activeColor == design.colors.transparent
        ? ''
        : formatPct(pct);

    final activeFlex = (pct * 10).round();
    final remainingFlex = ((100.0 - pct) * 10).round();

    return Container(
      padding:
          contentPadding ??
          EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm,
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showLabel) ...[
            SizedBox(
              width: fixedLabelWidth ? design.spacing.xxxl * 2 : null,
              child: isSkeleton
                  ? Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: design.colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(design.radius.sm),
                      ),
                    )
                  : AppText.xs(
                      subjectAnalytics.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      color: design.colors.textPrimary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            SizedBox(width: design.spacing.sm + design.spacing.xs),
          ],
          Expanded(
            child: Container(
              height: height ?? design.spacing.lg,
              decoration: BoxDecoration(
                color: design.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(design.radius.sm),
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: activeFilter == 'All'
                    ? [
                        _BarSegment(
                          flex: correctFlex,
                          color: correctColor,
                          pct: correctPct,
                          isLargeText: isLargeText,
                          showLabel: !isSkeleton,
                        ),
                        _BarSegment(
                          flex: incorrectFlex,
                          color: incorrectColor,
                          pct: incorrectPct,
                          isLargeText: isLargeText,
                          showLabel: !isSkeleton,
                        ),
                        _BarSegment(
                          flex: unansweredFlex,
                          color: unansweredColor,
                          pct: unansweredPct,
                          padding: EdgeInsets.only(right: design.spacing.sm),
                          isLargeText: isLargeText,
                          showLabel: !isSkeleton,
                        ),
                      ]
                    : [
                        _SingleMetricSegment(
                          flex: activeFlex,
                          color: activeColor,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: design.spacing.sm),
                          showLabel:
                              !isSkeleton && pct >= _minPctForInsideLabel,
                          labelText: labelText,
                          textColor: design.colors.textInverse,
                          isLargeText: isLargeText,
                        ),
                        _SingleMetricSegment(
                          flex: remainingFlex,
                          color: activeBgColor,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: design.spacing.sm),
                          showLabel: !isSkeleton && pct < _minPctForInsideLabel,
                          labelText: labelText,
                          textColor: activeColor,
                          isLargeText: isLargeText,
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
    this.isLargeText = false,
    this.showLabel = true,
  });

  final int flex;
  final Color color;
  final double pct;
  final EdgeInsetsGeometry? padding;
  final bool isLargeText;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    if (flex <= 0) return const SizedBox.shrink();

    return Expanded(
      flex: flex,
      child: Container(
        color: color,
        alignment: Alignment.center,
        padding: padding,
        child: (showLabel && pct >= _minPctForStackedLabel)
            ? _barLabel(
                formatPct(pct),
                Design.of(context).colors.textInverse,
                isLargeText,
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
    this.isLargeText = false,
  });

  final int flex;
  final Color color;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;
  final bool showLabel;
  final String labelText;
  final Color textColor;
  final bool isLargeText;

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
            ? _barLabel(labelText, textColor, isLargeText)
            : const SizedBox.shrink(),
      ),
    );
  }
}
