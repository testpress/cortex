import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Dummy data used as placeholder content when [isLoading] is true.
/// Skeletonizer renders the real layout over this data with a shimmer effect.
const _kPlaceholderAttempts = [
  AttemptDto(
    date: '2026-01-01T00:00:00Z',
    score: '00.00',
    correctCount: 00,
    incorrectCount: 00,
  ),
  AttemptDto(
    date: '2026-01-01T00:00:00Z',
    score: '00.00',
    correctCount: 00,
    incorrectCount: 00,
  ),
  AttemptDto(
    date: '2026-01-01T00:00:00Z',
    score: '00.00',
    correctCount: 00,
    incorrectCount: 00,
  ),
];

class ExamHistoryTable extends StatelessWidget {
  final List<AttemptDto> attempts;
  final void Function(AttemptDto attempt) onReviewTapped;

  /// When true, renders the widget wrapped in a [Skeletonizer] shimmer using
  /// placeholder data. The [attempts] and [onReviewTapped] values are ignored.
  final bool isLoading;

  const ExamHistoryTable({
    super.key,
    required this.attempts,
    required this.onReviewTapped,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final displayAttempts = isLoading ? _kPlaceholderAttempts : attempts;

    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.title(
            l10n.examPreviousAttempts,
            style: design.typography.title.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: design.spacing.md),
          Container(
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.circular(design.radius.md),
              border: Border.all(color: design.colors.border),
            ),
            child: Column(
              children: [
                // Header row
                _buildHeaderRow(context),
                Container(height: 1, color: design.colors.border),
                // Data rows
                ...displayAttempts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final attempt = entry.value;
                  return Column(
                    children: [
                      _buildDataRow(context, attempt),
                      if (index < displayAttempts.length - 1)
                        Container(height: 1, color: design.colors.border),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: AppText.cardSubtitle(l10n.labelDate)),
          Expanded(
            flex: 2,
            child: AppText.cardSubtitle(
              l10n.analyticsCorrect,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppText.cardSubtitle(
              l10n.analyticsIncorrect,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppText.cardSubtitle(
              l10n.labelScore,
              textAlign: TextAlign.center,
            ),
          ),
          // Review column — same Expanded as data row to guarantee alignment
          const Expanded(flex: 2, child: SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, AttemptDto attempt) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final dateStr = attempt.date != null
        ? DateFormatter.formatFullDate(DateTime.parse(attempt.date!).toLocal())
        : '--';

    final correctColor = design.colors.success;
    final incorrectColor = design.colors.error;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.md,
      ),
      child: Row(
        children: [
          // Date
          Expanded(flex: 3, child: AppText.cardTitle(dateStr)),
          // Correct
          Expanded(
            flex: 2,
            child: AppText.cardTitle(
              '${attempt.correctCount ?? 0}',
              style: design.typography.cardTitle.copyWith(color: correctColor),
              textAlign: TextAlign.center,
            ),
          ),
          // Incorrect
          Expanded(
            flex: 2,
            child: AppText.cardTitle(
              '${attempt.incorrectCount ?? 0}',
              style: design.typography.cardTitle.copyWith(
                color: incorrectColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Score
          Expanded(
            flex: 2,
            child: AppText.cardTitle(
              attempt.score ?? '0.00',
              textAlign: TextAlign.center,
            ),
          ),
          // Review button — Expanded(flex:2) matches header placeholder
          Expanded(
            flex: 2,
            child: isLoading
                ? const SizedBox.shrink()
                : AppSemantics.button(
                    label: l10n.testReview,
                    onTap: () => onReviewTapped(attempt),
                    child: GestureDetector(
                      onTap: () => onReviewTapped(attempt),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppText.label(
                            l10n.testReview,
                            style: design.typography.label.copyWith(
                              color: design.colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: design.spacing.xs),
                          Icon(
                            LucideIcons.chevronRight,
                            size: design.spacing.md,
                            color: design.colors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
