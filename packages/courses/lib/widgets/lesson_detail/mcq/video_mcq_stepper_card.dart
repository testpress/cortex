import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class VideoMcqStepperCard extends StatelessWidget {
  final LearnLensQuizQuestionDto question;
  final int currentIndex;
  final int totalQuestions;
  final int answeredCount;
  final String difficulty;
  final String? selectedOption;
  final bool showHint;
  final VoidCallback onToggleHint;
  final ValueChanged<String> onSelectOption;
  final bool isAnswerChecked;
  final VoidCallback? onCheckAnswer;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback? onViewAllQuestions;
  final ValueChanged<Duration>? onSeek;

  const VideoMcqStepperCard({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    this.answeredCount = 0,
    required this.difficulty,
    this.selectedOption,
    this.isAnswerChecked = false,
    this.onCheckAnswer,
    required this.showHint,
    required this.onToggleHint,
    required this.onSelectOption,
    required this.onPrevious,
    required this.onNext,
    this.onViewAllQuestions,
    this.onSeek,
  });

  Widget _buildHeader(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: AppText.title(
            l10n.videoMcqPracticeTestHeading,
            color: design.colors.textPrimary,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: design.spacing.sm),
        AppBadge(
          label: l10n.videoMcqQuestionsCount(totalQuestions),
          isPill: true,
          backgroundColor: design.colors.surfaceVariant,
          foregroundColor: design.colors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final progress =
        totalQuestions > 0 ? (currentIndex + 1) / totalQuestions : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.labelBold(
              l10n.testQuestionXofY(currentIndex + 1, totalQuestions),
              color: design.colors.textPrimary,
            ),
            AppText.caption(
              l10n.videoMcqAnsweredCount(answeredCount),
              color: design.colors.textSecondary,
            ),
          ],
        ),
        SizedBox(height: design.spacing.xs),
        AppSemantics.progressValue(
          value: progress.clamp(0.0, 1.0),
          label: l10n.testQuestionXofY(currentIndex + 1, totalQuestions),
          child: ClipRRect(
            borderRadius: design.radius.pill,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: design.spacing.xs,
                  width: double.infinity,
                  color: design.colors.divider.withValues(alpha: 0.5),
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: MotionPreferences.duration(
                      context,
                      design.motion.normal,
                    ),
                    curve: MotionPreferences.curve(
                      context,
                      design.motion.easeOut,
                    ),
                    width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                    color: design.colors.primary,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

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

  Widget _buildRadioIndicator({
    required DesignConfig design,
    required bool isSelected,
    required bool isAnswerChecked,
    required bool isOptionCorrect,
  }) {
    Color borderColor;
    Color? dotColor;

    if (isAnswerChecked) {
      if (isOptionCorrect) {
        borderColor = dotColor = design.colors.success;
      } else if (isSelected) {
        borderColor = dotColor = design.colors.error;
      } else {
        borderColor = design.colors.border;
      }
    } else if (isSelected) {
      borderColor = dotColor = design.colors.success;
    } else {
      borderColor = design.colors.border;
    }

    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: dotColor != null ? 2.0 : 1.5,
        ),
      ),
      child: dotColor != null
          ? Center(
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildExplanation(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final isUserCorrect = selectedOption != null &&
        question.isOptionCorrect(
          selectedOption!,
          question.options.indexOf(selectedOption!),
        );
    final statusColor =
        isUserCorrect ? design.colors.success : design.colors.error;
    final statusTitle =
        isUserCorrect ? l10n.videoMcqCorrect : l10n.videoMcqIncorrect;

    return Column(
      children: [
        SizedBox(height: design.spacing.sm),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(design.radius.sm),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.lightbulb,
                    color: statusColor,
                    size: 16,
                  ),
                  SizedBox(width: design.spacing.xs),
                  AppText.labelBold(
                    statusTitle,
                    color: statusColor,
                  ),
                ],
              ),
              SizedBox(height: design.spacing.sm),
              _buildTextWithTimestamps(
                context,
                question.explanation,
                design,
                textColor: design.colors.textPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.card,
      padding: EdgeInsets.all(design.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          SizedBox(height: design.spacing.md),
          _buildProgressBar(context),
          SizedBox(height: design.spacing.lg),

          AppText.base(
            question.text,
            style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4),
            color: design.colors.textPrimary,
          ),
          SizedBox(height: design.spacing.lg),

          ...question.options.asMap().entries.map((entry) {
            final optionIndex = entry.key;
            final option = entry.value;
            final isOptionSelected = selectedOption == option;
            final isOptionCorrect =
                question.isOptionCorrect(option, optionIndex);

            Color optionBg = design.colors.card;
            Color optionBorder = design.colors.divider;
            Color optionTextColor = design.colors.textPrimary;

            if (isAnswerChecked) {
              if (isOptionCorrect) {
                optionBg = design.colors.success.withValues(alpha: 0.12);
                optionBorder = design.colors.success;
                optionTextColor = design.colors.success;
              } else if (isOptionSelected) {
                optionBg = design.colors.error.withValues(alpha: 0.12);
                optionBorder = design.colors.error;
                optionTextColor = design.colors.error;
              } else {
                optionBg = design.colors.card;
                optionBorder = design.colors.divider;
                optionTextColor = design.colors.textSecondary;
              }
            } else if (isOptionSelected) {
              optionBg = design.colors.success.withValues(alpha: 0.08);
              optionBorder = design.colors.success;
              optionTextColor = design.colors.textPrimary;
            }

            final iconWidget = _buildRadioIndicator(
              design: design,
              isSelected: isOptionSelected,
              isAnswerChecked: isAnswerChecked,
              isOptionCorrect: isOptionCorrect,
            );

            return Padding(
              padding: EdgeInsets.only(bottom: design.spacing.md),
              child: AppSemantics.button(
                label: option,
                child: AppFocusable(
                  onTap: isAnswerChecked ? null : () => onSelectOption(option),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                      vertical: design.spacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: optionBg,
                      borderRadius: BorderRadius.circular(design.radius.md),
                      border: Border.all(
                        color: optionBorder,
                        width: (isOptionSelected ||
                                (isAnswerChecked && isOptionCorrect))
                            ? 1.5
                            : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        iconWidget,
                        SizedBox(width: design.spacing.md),
                        Expanded(
                          child: AppText.sm(
                            option,
                            color: optionTextColor,
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                        if (isAnswerChecked && isOptionCorrect) ...[
                          SizedBox(width: design.spacing.sm),
                          Icon(
                            LucideIcons.check,
                            color: design.colors.success,
                            size: 20,
                          ),
                        ] else if (isAnswerChecked &&
                            isOptionSelected &&
                            !isOptionCorrect) ...[
                          SizedBox(width: design.spacing.sm),
                          Icon(
                            LucideIcons.x,
                            color: design.colors.error,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          if (!isAnswerChecked && question.hint.isNotEmpty) ...[
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

          if (!isAnswerChecked && selectedOption != null) ...[
            SizedBox(height: design.spacing.md),
            AppButton.primary(
              label: l10n.videoMcqCheckAnswer,
              onPressed: onCheckAnswer,
              fullWidth: true,
              backgroundColor: design.colors.success,
            ),
          ],

          if (isAnswerChecked && question.explanation.isNotEmpty)
            _buildExplanation(context),

          SizedBox(height: design.spacing.lg),

          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: l10n.videoMcqPrevious,
                  onPressed: currentIndex > 0 ? onPrevious : null,
                  backgroundColor: design.colors.card,
                  foregroundColor: currentIndex > 0
                      ? design.colors.textPrimary
                      : design.colors.textTertiary.withValues(alpha: 0.5),
                  borderColor: design.colors.divider,
                  fullWidth: true,
                ),
              ),
              SizedBox(width: design.spacing.md),
              Expanded(
                child: AppButton.secondary(
                  label: currentIndex < totalQuestions - 1
                      ? l10n.videoMcqNext
                      : l10n.testFinish,
                  onPressed: onNext,
                  backgroundColor: design.colors.card,
                  foregroundColor: design.colors.textPrimary,
                  borderColor: design.colors.divider,
                  fullWidth: true,
                ),
              ),
            ],
          ),

          if (onViewAllQuestions != null) ...[
            SizedBox(height: design.spacing.md),
            AppButton.secondary(
              label: l10n.testViewAllQuestions(answeredCount, totalQuestions),
              onPressed: onViewAllQuestions,
              backgroundColor: design.colors.card,
              foregroundColor: design.colors.textPrimary,
              borderColor: design.colors.divider,
              fullWidth: true,
            ),
          ],
        ],
      ),
    );
  }
}
