import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:exams/exams.dart';
import 'widgets/qotd_completion_gauge.dart';
import 'widgets/qotd_chart_legend_row.dart';

/// The QOTD landing / statistics overview screen.
class QotdOverviewScreen extends StatelessWidget {
  final List<QotdDto> questions;
  final ValueChanged<int> onStartQuiz;

  const QotdOverviewScreen({
    super.key,
    required this.questions,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final total = questions.length;
    final attempted = questions.where((q) => q.pastAttempt != null).length;
    final correct = questions
        .where((q) => q.pastAttempt != null && q.pastAttempt!.isCorrect)
        .length;
    final incorrect = attempted - correct;
    final unanswered = total - attempted;
    final isCompleted = total > 0 && attempted == total;
    final percentage = total > 0 ? ((attempted / total) * 100).toInt() : 0;

    final subjects = questions
        .map((q) => q.subject)
        .where((s) => s != null && s.trim().isNotEmpty)
        .map((s) => s!.trim())
        .toSet()
        .toList();
    final subjectsText = subjects.isNotEmpty ? subjects.join(', ') : '—';

    final difficulties = questions
        .map((q) => q.difficulty)
        .where((d) => d != null && d.trim().isNotEmpty)
        .toSet()
        .toList();
    final difficultyText = difficulties.length == 1
        ? difficulties.first!
        : l10n.qotdMixed;

    final formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    int firstUnattemptedIndex = questions.indexWhere(
      (q) => q.pastAttempt == null,
    );
    if (firstUnattemptedIndex == -1) firstUnattemptedIndex = 0;

    final ctaLabel = isCompleted
        ? l10n.qotdViewSolutions
        : (attempted > 0 ? l10n.qotdResumeQuiz : l10n.qotdStartQuiz);

    final String statusLabel;
    final Color statusColor;
    if (isCompleted) {
      statusLabel = l10n.qotdStatusCompleted;
      statusColor = design.colors.success;
    } else if (attempted > 0) {
      statusLabel = l10n.qotdStatusInProgress;
      statusColor = design.colors.accent2;
    } else {
      statusLabel = l10n.qotdStatusNotStarted;
      statusColor = design.colors.textSecondary;
    }

    final String subtitleText;
    if (isCompleted) {
      subtitleText = l10n.qotdSubtitleCompleted;
    } else if (attempted > 0) {
      subtitleText = l10n.qotdSubtitleInProgress(unanswered);
    } else {
      subtitleText = l10n.qotdSubtitleNotStarted;
    }

    return Column(
      children: [
        AppHeader(
          title: l10n.qotdTitle,
          leading: AppBackButton(onTap: () => context.pop()),
        ),
        Expanded(
          child: AppScroll(
            padding: EdgeInsets.symmetric(
              horizontal: design.spacing.lg,
              vertical: design.spacing.md,
            ),
            children: [
              // Date row
              Padding(
                padding: EdgeInsets.only(
                  left: design.spacing.xs,
                  bottom: design.spacing.md,
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.calendar,
                      size: 18,
                      color: design.colors.primary,
                    ),
                    SizedBox(width: design.spacing.sm),
                    AppText.label(
                      formattedDate,
                      color: design.colors.textSecondary,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(design.spacing.lg),
                decoration: BoxDecoration(
                  color: design.colors.surfaceVariant.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: design.colors.border.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    QotdCompletionGauge(percentage: percentage),
                    SizedBox(width: design.spacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: design.spacing.sm,
                              vertical: design.spacing.xs * 0.6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: design.radius.pill,
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: AppText.labelSmall(
                              statusLabel,
                              color: statusColor,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(height: design.spacing.xs),
                          AppText.headline(
                            l10n.qotdAttemptedCount(attempted, total),
                            color: design.colors.textPrimary,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: design.spacing.xs),
                          AppText.bodySmall(
                            subtitleText,
                            color: design.colors.textSecondary,
                            style: const TextStyle(height: 1.35, fontSize: 12),
                          ),
                          SizedBox(height: design.spacing.md),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: Container(
                              height: 5,
                              width: double.infinity,
                              color: design.colors.success.withValues(
                                alpha: 0.12,
                              ),
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: total > 0
                                    ? (attempted / total).clamp(0.0, 1.0)
                                    : 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: design.colors.success,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: design.spacing.lg),

              // Donut breakdown (always visible matching web design)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(design.spacing.lg),
                decoration: BoxDecoration(
                  color: design.colors.surfaceVariant.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: design.colors.border.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.xs,
                      ),
                      child: DonutChart(
                        correct: correct,
                        incorrect: incorrect,
                        unanswered: unanswered,
                        size: 96,
                        strokeWidth: 14,
                      ),
                    ),
                    SizedBox(width: design.spacing.xl),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QotdChartLegendRow(
                            color: design.colors.accent4,
                            label: l10n.qotdCorrect,
                            count: correct,
                          ),
                          SizedBox(height: design.spacing.sm),
                          QotdChartLegendRow(
                            color: design.colors.accent5,
                            label: l10n.qotdIncorrect,
                            count: incorrect,
                          ),
                          SizedBox(height: design.spacing.sm),
                          QotdChartLegendRow(
                            color: design.colors.accent3,
                            label: l10n.qotdUnanswered,
                            count: unanswered,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: design.spacing.lg),

              // Metadata cards
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _MetadataCard(
                        icon: LucideIcons.chartColumn,
                        iconColor: design.colors.primary,
                        label: l10n.qotdDifficulty,
                        value: difficultyText,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: design.spacing.md),
                    Expanded(
                      child: _MetadataCard(
                        icon: LucideIcons.bookOpen,
                        iconColor: design.colors.success,
                        label: l10n.qotdTargetedSubjects,
                        value: subjectsText,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: design.spacing.xl),

              // CTA button
              AppButton.primary(
                label: ctaLabel,
                fullWidth: true,
                onPressed: () => onStartQuiz(firstUnattemptedIndex),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetadataCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final int maxLines;

  const _MetadataCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      padding: EdgeInsets.all(design.spacing.lg),
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: design.colors.border.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          SizedBox(height: design.spacing.md),
          AppText.labelSmall(
            label,
            color: design.colors.textSecondary,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: 0.6,
            ),
          ),
          SizedBox(height: design.spacing.xs),
          AppText.title(
            value,
            color: design.colors.textPrimary,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: maxLines > 1 ? 15 : 16,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
