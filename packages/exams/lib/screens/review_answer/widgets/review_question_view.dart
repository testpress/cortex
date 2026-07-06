import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'review_question_html_builder.dart';

/// Card displayed for each question in the post-exam review screen.
///
/// Shows a colour-coded header (correct / incorrect / unanswered), an
/// optional direction passage, and then the question with all options
/// colour-coded to show what was correct and what was selected.
///
/// HTML generation is delegated to [ReviewQuestionHtmlBuilder] so this
/// widget stays focused on layout only.
class ReviewQuestionCard extends StatelessWidget {
  final QuestionDto question;
  final AnswerDto? attemptState;
  final AppLocalizations l10n;
  final bool isCorrect;
  final bool isUnanswered;
  final String questionNumber;

  const ReviewQuestionCard({
    super.key,
    required this.question,
    required this.attemptState,
    required this.l10n,
    required this.isCorrect,
    required this.isUnanswered,
    required this.questionNumber,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: design.spacing.md),
        padding: EdgeInsets.all(design.spacing.lg),
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: design.colors.border),
          boxShadow: design.isDark
              ? []
              : [
                  BoxShadow(
                    color: design.colors.shadow.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Correct / Incorrect / Unanswered badge row
            _QuestionHeader(
              questionNumber: questionNumber,
              isCorrect: isCorrect,
              isUnanswered: isUnanswered,
              l10n: l10n,
            ),
            const SizedBox(height: 16),

            // Direction / passage shown above the question when present
            if (question.directionHtml != null &&
                question.directionHtml!.isNotEmpty) ...[
              AppHtml(data: question.directionHtml!, fontSize: 15),
              const SizedBox(height: 16),
              Container(height: 1, color: design.colors.border),
              const SizedBox(height: 16),
            ],

            // Unified question + colour-coded options + explanation
            AppHtml(
              data: ReviewQuestionHtmlBuilder.build(
                question: question,
                attemptState: attemptState,
                design: design,
                l10n: l10n,
              ),
              fontSize: 15,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widget ────────────────────────────────────────────────────────

class _QuestionHeader extends StatelessWidget {
  final String questionNumber;
  final bool isCorrect;
  final bool isUnanswered;
  final AppLocalizations l10n;

  const _QuestionHeader({
    required this.questionNumber,
    required this.isCorrect,
    required this.isUnanswered,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final Color bg;
    final Color text;
    final String label;
    final IconData icon;

    if (isUnanswered) {
      bg = design.colors.accent3.withValues(alpha: design.isDark ? 0.2 : 0.1);
      text = design.colors.accent3;
      label = l10n.examReviewFilterUnanswered;
      icon = LucideIcons.alertCircle;
    } else if (isCorrect) {
      bg = design.colors.accent4.withValues(alpha: design.isDark ? 0.2 : 0.1);
      text = design.colors.accent4;
      label = l10n.examReviewFilterCorrect;
      icon = LucideIcons.checkCircle2;
    } else {
      bg = design.colors.accent5.withValues(alpha: design.isDark ? 0.2 : 0.1);
      text = design.colors.accent5;
      label = l10n.assessmentIncorrect;
      icon = LucideIcons.xCircle;
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: design.colors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: text, size: 20),
              const SizedBox(width: 8),
              AppText.title(
                l10n.reviewQuestionLabel(questionNumber),
                color: design.colors.textPrimary,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: AppText.caption(label, color: text),
          ),
        ],
      ),
    );
  }
}
