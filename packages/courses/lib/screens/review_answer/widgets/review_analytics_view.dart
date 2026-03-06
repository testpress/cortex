import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class ReviewOverallSummary extends StatelessWidget {
  final AppLocalizations l10n;
  final int total;
  final int correct;
  final int incorrect;
  final int unanswered;

  const ReviewOverallSummary({
    super.key,
    required this.l10n,
    required this.total,
    required this.correct,
    required this.incorrect,
    required this.unanswered,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      padding: EdgeInsets.all(design.spacing.lg),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: design.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.body(
            l10n.labelOverallSummary,
            color: design.colors.textPrimary,
          ),
          const SizedBox(height: 20),
          _SegmentedProgressBar(
            total: total,
            correct: correct,
            incorrect: incorrect,
            unanswered: unanswered,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _LegendItem(
                label: l10n.examReviewFilterAnswered,
                count: correct,
                color: design.colors.accent4,
              ),
              _LegendItem(
                label: l10n.examReviewFilterWrong,
                count: incorrect,
                color: design.colors.accent5,
              ),
              _LegendItem(
                label: l10n.examReviewFilterUnanswered,
                count: unanswered,
                color: design.colors.accent3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentedProgressBar extends StatelessWidget {
  final int total;
  final int correct;
  final int incorrect;
  final int unanswered;

  const _SegmentedProgressBar({
    required this.total,
    required this.correct,
    required this.incorrect,
    required this.unanswered,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();
    final design = Design.of(context);

    return Container(
      height: 12,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: design.colors.divider,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          if (correct > 0)
            Expanded(
              flex: correct,
              child: Container(color: design.colors.accent4),
            ),
          if (incorrect > 0)
            Expanded(
              flex: incorrect,
              child: Container(color: design.colors.accent5),
            ),
          if (unanswered > 0)
            Expanded(
              flex: unanswered,
              child: Container(color: design.colors.accent3),
            ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _LegendItem({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            AppText.caption(label, color: design.colors.textSecondary),
          ],
        ),
        const SizedBox(height: 8),
        AppText.headline(count.toString(), color: design.colors.textPrimary),
      ],
    );
  }
}

class ReviewDetailedAnalytics extends StatelessWidget {
  final AppLocalizations l10n;

  const ReviewDetailedAnalytics({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      padding: EdgeInsets.all(design.spacing.lg),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: design.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.body(
            l10n.labelDetailedAnalytics,
            color: design.colors.textPrimary,
          ),
          const SizedBox(height: 20),
          _DetailedAnalyticsCard(
            title: l10n.labelSubjectWiseAnalytics,
            subtitle: l10n.labelViewPerformanceBySubject,
            design: design,
          ),
          const SizedBox(height: 12),
          _DetailedAnalyticsCard(
            title: l10n.labelOverallPerformance,
            subtitle: l10n.labelSeeDetailedMetrics,
            design: design,
          ),
          const SizedBox(height: 12),
          _DetailedAnalyticsCard(
            title: l10n.labelInsights,
            subtitle: l10n.labelGetPersonalizedRecommendations,
            design: design,
          ),
        ],
      ),
    );
  }
}

class _DetailedAnalyticsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final DesignConfig design;

  const _DetailedAnalyticsCard({
    required this.title,
    required this.subtitle,
    required this.design,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: design.colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.body(
            title,
            color: design.colors.textPrimary,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          AppText.caption(subtitle, color: design.colors.textSecondary),
        ],
      ),
    );
  }
}
