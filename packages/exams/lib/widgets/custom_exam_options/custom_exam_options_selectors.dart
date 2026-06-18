import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../models/custom_exam_options.dart';

class CustomExamOptionsSelectors extends StatelessWidget {
  final QuestionSource questionSource;
  final ValueChanged<QuestionSource> onQuestionSourceChanged;
  final int questionCount;
  final ValueChanged<int> onQuestionCountChanged;
  final DifficultyLevel difficulty;
  final ValueChanged<DifficultyLevel> onDifficultyChanged;
  final AttemptMode attemptMode;
  final ValueChanged<AttemptMode> onAttemptModeChanged;
  const CustomExamOptionsSelectors({
    super.key,
    required this.questionSource,
    required this.onQuestionSourceChanged,
    required this.questionCount,
    required this.onQuestionCountChanged,
    required this.difficulty,
    required this.onDifficultyChanged,
    required this.attemptMode,
    required this.onAttemptModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomExamSectionLabel(
          label: context.l10n.customExamStepSource,
          design: design,
        ),
        SizedBox(height: design.spacing.sm),
        _buildQuestionSourceSelector(context, design),
        SizedBox(height: design.spacing.md),

        CustomExamSectionLabel(
          label: context.l10n.customExamStepCount,
          design: design,
        ),
        SizedBox(height: design.spacing.sm),
        _buildQuestionCountSelector(context, design),
        SizedBox(height: design.spacing.md),

        CustomExamSectionLabel(
          label: context.l10n.customExamStepDifficulty,
          design: design,
        ),
        SizedBox(height: design.spacing.sm),
        _buildDifficultySelector(context, design),
        SizedBox(height: design.spacing.md),

        CustomExamSectionLabel(
          label: context.l10n.customExamStepMode,
          design: design,
        ),
        SizedBox(height: design.spacing.sm),
        _buildAttemptModeSelector(context, design),
      ],
    );
  }

  Widget _buildQuestionSourceSelector(
    BuildContext context,
    DesignConfig design,
  ) {
    final options = [
      (QuestionSource.previousYear, context.l10n.customExamSourcePrevYear),
      (QuestionSource.boardPapers, context.l10n.customExamSourceBoard),
      (QuestionSource.important, context.l10n.customExamSourceImportant),
    ];

    return Wrap(
      spacing: design.spacing.sm,
      runSpacing: design.spacing.sm,
      children: options.map((opt) {
        final (value, label) = opt;
        final isSelected = questionSource == value;
        return AppSemantics.button(
          label: label,
          onTap: () => onQuestionSourceChanged(value),
          child: GestureDetector(
            onTap: () => onQuestionSourceChanged(value),
            child: _Chip(label: label, isSelected: isSelected, design: design),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuestionCountSelector(
    BuildContext context,
    DesignConfig design,
  ) {
    const counts = [10, 15, 20, 30, 50];

    return Wrap(
      spacing: design.spacing.sm,
      runSpacing: design.spacing.sm,
      children: counts.map((count) {
        final isSelected = questionCount == count;
        return AppSemantics.button(
          label: context.l10n.customExamCountLabel(count),
          onTap: () => onQuestionCountChanged(count),
          child: GestureDetector(
            onTap: () => onQuestionCountChanged(count),
            child: _Chip(
              label: '$count',
              isSelected: isSelected,
              design: design,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDifficultySelector(BuildContext context, DesignConfig design) {
    final options = [
      (DifficultyLevel.easy, context.l10n.customExamDiffEasy),
      (DifficultyLevel.medium, context.l10n.customExamDiffMedium),
      (DifficultyLevel.hard, context.l10n.customExamDiffHard),
      (DifficultyLevel.mixed, context.l10n.customExamDiffMixed),
    ];

    return Wrap(
      spacing: design.spacing.sm,
      runSpacing: design.spacing.sm,
      children: options.map((opt) {
        final (value, label) = opt;
        final isSelected = difficulty == value;
        return AppSemantics.button(
          label: label,
          onTap: () => onDifficultyChanged(value),
          child: GestureDetector(
            onTap: () => onDifficultyChanged(value),
            child: _Chip(label: label, isSelected: isSelected, design: design),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAttemptModeSelector(BuildContext context, DesignConfig design) {
    final options = [
      (
        value: AttemptMode.quiz,
        label: context.l10n.customExamModeQuiz,
        description: context.l10n.customExamModeQuizDesc,
      ),
      (
        value: AttemptMode.test,
        label: context.l10n.customExamModeTest,
        description: context.l10n.customExamModeTestDesc,
      ),
    ];

    return Column(
      children: options.map((opt) {
        final isSelected = attemptMode == opt.value;
        return Padding(
          padding: EdgeInsets.only(bottom: design.spacing.sm),
          child: AppSemantics.button(
            label: opt.label,
            onTap: () => onAttemptModeChanged(opt.value),
            child: GestureDetector(
              onTap: () => onAttemptModeChanged(opt.value),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 56),
                padding: EdgeInsets.all(
                  isSelected ? design.spacing.md - 1 : design.spacing.md,
                ),
                decoration: BoxDecoration(
                  color: design.colors.surface,
                  borderRadius: BorderRadius.circular(design.radius.lg),
                  border: Border.all(
                    color: isSelected
                        ? design.colors.primary
                        : design.colors.textTertiary.withValues(alpha: 0.4),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    _RadioDot(isSelected: isSelected, design: design),
                    SizedBox(width: design.spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.body(
                            opt.label,
                            color: design.colors.textPrimary,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          AppText.caption(
                            opt.description,
                            color: design.colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CustomExamSectionLabel extends StatelessWidget {
  final String label;
  final DesignConfig design;

  const CustomExamSectionLabel({
    super.key,
    required this.label,
    required this.design,
  });

  @override
  Widget build(BuildContext context) {
    return AppSemantics.header(
      label: label,
      child: AppText.bodySmall(
        label,
        color: design.colors.textSecondary,
        style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.4),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final DesignConfig design;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.design,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: isSelected ? design.colors.primary : design.colors.surface,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(
          color: isSelected
              ? design.colors.primary
              : design.colors.textTertiary.withValues(alpha: 0.4),
        ),
      ),
      child: AppText.body(
        label,
        color: isSelected ? design.colors.onPrimary : design.colors.textPrimary,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool isSelected;
  final DesignConfig design;

  const _RadioDot({required this.isSelected, required this.design});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? design.colors.primary : design.colors.border,
      ),
      child: Center(
        child: Container(
          width: isSelected ? 8 : 16,
          height: isSelected ? 8 : 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: design.colors.surface,
          ),
        ),
      ),
    );
  }
}
