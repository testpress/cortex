import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../../models/test_model.dart';

class ReviewQuestionCard extends StatelessWidget {
  final TestQuestion question;
  final TestAttemptAnswer? attemptState;
  final AppLocalizations l10n;
  final bool isCorrect;
  final bool isUnanswered;

  const ReviewQuestionCard({
    super.key,
    required this.question,
    required this.attemptState,
    required this.l10n,
    required this.isCorrect,
    required this.isUnanswered,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
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
        children: [
          _QuestionHeader(
            questionId: question.id,
            isCorrect: isCorrect,
            isUnanswered: isUnanswered,
            l10n: l10n,
          ),
          const SizedBox(height: 16),
          AppText.headline(question.text, color: design.colors.textPrimary),
          const SizedBox(height: 24),
          ...question.options.map((opt) {
            final isCorrectOption = question.correctOptionIds.contains(opt.id);
            final isUserSelected =
                attemptState?.selectedOptions.contains(opt.id) ?? false;
            return _OptionItem(
              option: opt,
              isCorrectOption: isCorrectOption,
              isUserSelected: isUserSelected,
            );
          }),
          if (question.explanation != null && question.explanation!.isNotEmpty)
            _ExplanationSection(explanation: question.explanation!, l10n: l10n),
        ],
      ),
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  final String questionId;
  final bool isCorrect;
  final bool isUnanswered;
  final AppLocalizations l10n;

  const _QuestionHeader({
    required this.questionId,
    required this.isCorrect,
    required this.isUnanswered,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    Color bg;
    Color text;
    String label;
    IconData icon;

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
                l10n.reviewQuestionLabel(questionId),
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

class _OptionItem extends StatelessWidget {
  final QuestionOption option;
  final bool isCorrectOption;
  final bool isUserSelected;

  const _OptionItem({
    required this.option,
    required this.isCorrectOption,
    required this.isUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    Color borderColor = design.colors.border;
    Color bgColor = design.colors.card;

    if (isCorrectOption) {
      borderColor = design.colors.accent4;
      bgColor = design.colors.accent4.withValues(
        alpha: design.isDark ? 0.15 : 0.08,
      );
    } else if (isUserSelected) {
      borderColor = design.colors.accent5;
      bgColor = design.colors.accent5.withValues(
        alpha: design.isDark ? 0.15 : 0.08,
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: (isCorrectOption || isUserSelected) ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          _OptionIndicator(
            isCorrect: isCorrectOption,
            isSelected: isUserSelected,
            color: borderColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText.body(
              option.text,
              color: (isCorrectOption || isUserSelected)
                  ? design.colors.textPrimary
                  : design.colors.textSecondary,
              style: TextStyle(
                fontWeight: (isCorrectOption || isUserSelected)
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
          if (isCorrectOption)
            Icon(
              LucideIcons.checkCircle2,
              color: textCorrect(design),
              size: 16,
            ),
          if (isUserSelected && !isCorrectOption)
            Icon(LucideIcons.xCircle, color: textIncorrect(design), size: 16),
        ],
      ),
    );
  }

  Color textCorrect(DesignConfig design) => design.colors.accent4;
  Color textIncorrect(DesignConfig design) => design.colors.accent5;
}

class _OptionIndicator extends StatelessWidget {
  final bool isCorrect;
  final bool isSelected;
  final Color color;

  const _OptionIndicator({
    required this.isCorrect,
    required this.isSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isActive = isCorrect || isSelected;
    final activeColor = isCorrect
        ? design.colors.accent4
        : design.colors.accent5;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? activeColor : design.colors.border,
          width: 2,
        ),
        color: isActive ? activeColor : design.colors.card,
      ),
      child: isActive
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: design.colors.onPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

class _ExplanationSection extends StatelessWidget {
  final String explanation;
  final AppLocalizations l10n;

  const _ExplanationSection({required this.explanation, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final bgColor = design.colors.accent2.withValues(
      alpha: design.isDark ? 0.18 : 0.12,
    );
    final borderColor = design.colors.accent2.withValues(
      alpha: design.isDark ? 0.4 : 0.35,
    );
    final textColor = design.colors.accent2;
    final secondaryTextColor = design.colors.textSecondary;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.body(
              l10n.assessmentExplanation,
              color: textColor,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            AppText.body(explanation, color: secondaryTextColor),
          ],
        ),
      ),
    );
  }
}
