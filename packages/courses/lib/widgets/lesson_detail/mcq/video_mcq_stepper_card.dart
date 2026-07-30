import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class VideoMcqStepperCard extends StatelessWidget {
  final LearnLensQuizQuestionDto question;
  final int currentIndex;
  final int totalQuestions;
  final String difficulty;
  final String? selectedOption;
  final bool showHint;
  final VoidCallback onToggleHint;
  final ValueChanged<String> onSelectOption;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<Duration>? onSeek;

  const VideoMcqStepperCard({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.difficulty,
    this.selectedOption,
    required this.showHint,
    required this.onToggleHint,
    required this.onSelectOption,
    required this.onPrevious,
    required this.onNext,
    this.onSeek,
  });

  Widget _buildTextWithTimestamps(
    BuildContext context,
    String text,
    DesignConfig design, {
    Color? textColor,
  }) {
    // Convert bare timestamps like "4:23" to markdown links "[4:23](timestamp:4:23)"
    // so AppMarkdown renders them as tappable blue links — consistent with ai_tab.dart.
    final converted = text.replaceAllMapped(
      RegExp(r'(\d{1,2}:\d{2}(?::\d{2})?)'),
      (m) => '[${m.group(1)}](timestamp:${m.group(1)})',
    );
    return AppMarkdown(
      data: converted,
      onTapLink: (url) {
        if (url.startsWith('timestamp:')) {
          final timeStr = url.substring('timestamp:'.length);
          final parts = timeStr
              .split(':')
              .map((e) => int.tryParse(e.trim()) ?? 0)
              .toList();
          final seconds = parts.length == 2
              ? parts[0] * 60 + parts[1]
              : parts.length == 3
                  ? parts[0] * 3600 + parts[1] * 60 + parts[2]
                  : null;
          if (seconds != null) {
            onSeek?.call(Duration(seconds: seconds));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isAnswered = selectedOption != null;

    return Padding(
      padding: EdgeInsets.all(design.spacing.md),
      child: Container(
        padding: EdgeInsets.all(design.spacing.lg),
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: Border.all(color: design.colors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Question Title with Index Prefix
            AppText.cardTitle(
              '${currentIndex + 1}. ${question.text}',
              color: design.colors.textPrimary,
            ),
            SizedBox(height: design.spacing.lg),

            // Options List
            ...question.options.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              final option = entry.value;
              final isOptionSelected = selectedOption == option;
              final isOptionCorrect =
                  question.isOptionCorrect(option, optionIndex);

              Color optionBg = design.colors.surface;
              Color optionBorder = design.colors.divider;
              Color optionTextColor = design.colors.textPrimary;
              Widget? iconWidget;

              if (isAnswered) {
                if (isOptionCorrect) {
                  optionBg = design.colors.success.withValues(alpha: 0.15);
                  optionBorder = design.colors.success;
                  optionTextColor = design.colors.success;
                  iconWidget = Icon(
                    LucideIcons.checkCircle,
                    color: design.colors.success,
                    size: 18,
                  );
                } else if (isOptionSelected) {
                  optionBg = design.colors.error.withValues(alpha: 0.15);
                  optionBorder = design.colors.error;
                  optionTextColor = design.colors.error;
                  iconWidget = Icon(
                    LucideIcons.xCircle,
                    color: design.colors.error,
                    size: 18,
                  );
                }
              }

              return Padding(
                padding: EdgeInsets.only(bottom: design.spacing.md),
                child: AppSemantics.button(
                  label: isOptionSelected ? '$option, selected' : option,
                  child: AppFocusable(
                    onTap: isAnswered ? null : () => onSelectOption(option),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.md,
                        vertical: design.spacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: optionBg,
                        borderRadius: BorderRadius.circular(design.radius.md),
                        border: Border.all(color: optionBorder),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppText.cardTitle(
                              option,
                              color: optionTextColor,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ),
                          if (iconWidget != null) ...[
                            SizedBox(width: design.spacing.xs),
                            iconWidget,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Hint Button (Below Options - Only shown before answer is selected)
            if (!isAnswered && question.hint.isNotEmpty) ...[
              SizedBox(height: design.spacing.xs),
              AppSemantics.button(
                label: showHint
                    ? L10n.of(context).videoMcqHideHint
                    : L10n.of(context).videoMcqSeeHint,
                child: AppFocusable(
                  onTap: onToggleHint,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.lightbulb,
                            color: showHint
                                ? design.colors.accent2
                                : design.colors.textSecondary,
                            size: 16,
                          ),
                          SizedBox(width: design.spacing.xs),
                          AppText.labelBold(
                            showHint
                                ? L10n.of(context).videoMcqHideHint
                                : L10n.of(context).videoMcqSeeHint,
                            color: showHint
                                ? design.colors.accent2
                                : design.colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (showHint) ...[
                SizedBox(height: design.spacing.xs),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(design.spacing.sm),
                  decoration: BoxDecoration(
                    color: design.colors.accent2.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(design.radius.sm),
                    border: Border.all(
                      color: design.colors.accent2.withValues(alpha: 0.3),
                    ),
                  ),
                  child: _buildTextWithTimestamps(
                    context,
                    question.hint,
                    design,
                    textColor: design.colors.textPrimary,
                  ),
                ),
              ],
            ],

            // Explanation Section
            if (isAnswered && question.explanation.isNotEmpty) ...[
              SizedBox(height: design.spacing.sm),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(design.spacing.md),
                decoration: BoxDecoration(
                  color: design.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(design.radius.sm),
                  border: Border.all(
                    color: design.colors.divider.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelBold(
                      L10n.of(context).videoMcqExplanation,
                      color: design.colors.textPrimary,
                    ),
                    SizedBox(height: design.spacing.sm),
                    _buildTextWithTimestamps(
                      context,
                      question.explanation,
                      design,
                      textColor: design.colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: design.spacing.lg),

            // Card Footer: [ < ]    3 / 10    [ > ]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentIndex > 0)
                  AppIconButton(
                    icon: LucideIcons.chevronLeft,
                    onTap: onPrevious,
                    accessibilityLabel:
                        L10n.of(context).videoMcqPreviousQuestion,
                  )
                else
                  const SizedBox(width: 48, height: 48),
                AppText.labelBold(
                  '${currentIndex + 1} / $totalQuestions',
                  color: design.colors.textSecondary,
                ),
                AppIconButton(
                  icon: LucideIcons.chevronRight,
                  onTap: onNext,
                  accessibilityLabel: L10n.of(context).videoMcqNextQuestion,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
