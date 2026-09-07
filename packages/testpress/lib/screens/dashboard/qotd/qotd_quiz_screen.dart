import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'qotd_quiz_controller.dart';

/// The interactive QOTD quiz screen with new UI design. Reads state from [QotdQuizController].
class QotdQuizScreen extends ConsumerStatefulWidget {
  final List<QotdDto> questions;
  final int initialIndex;
  final ValueChanged<bool> onCloseQuiz;

  const QotdQuizScreen({
    super.key,
    required this.questions,
    required this.initialIndex,
    required this.onCloseQuiz,
  });

  @override
  ConsumerState<QotdQuizScreen> createState() => _QotdQuizScreenState();
}

class _QotdQuizScreenState extends ConsumerState<QotdQuizScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _goToPrevious(int currentIndex, QotdQuizController controller) {
    if (currentIndex > 0) {
      controller.setCurrentIndex(currentIndex - 1);
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
  }

  void _goToNext(int currentIndex, QotdQuizController controller) {
    if (currentIndex < widget.questions.length - 1) {
      controller.setCurrentIndex(currentIndex + 1);
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final state = ref.watch(
      qotdQuizControllerProvider(
        questions: widget.questions,
        initialIndex: widget.initialIndex,
      ),
    );
    final controller = ref.read(
      qotdQuizControllerProvider(
        questions: widget.questions,
        initialIndex: widget.initialIndex,
      ).notifier,
    );

    final totalQuestions = widget.questions.length;
    final currentIndex = state.currentIndex;
    final isSubmitted = state.isSubmittedMap[currentIndex] ?? false;
    final selectedOptions =
        state.selectedOptionIds[currentIndex] ?? const <int>{};
    final submitResponse = state.submitResponses[currentIndex];
    final question = widget.questions[currentIndex];
    final isMultipleChoice =
        question.questionType == QotdQuestionType.multipleCorrect;
    final questionTypeLabel = isMultipleChoice
        ? l10n.qotdMultipleCorrect
        : l10n.qotdSingleCorrect;
    final hasSelection = selectedOptions.isNotEmpty;
    final progress = totalQuestions > 0
        ? (currentIndex + 1) / totalQuestions
        : 0.0;

    return ColoredBox(
      color: design.colors.canvas,
      child: Column(
        children: [
          // Header with question counter subtitle
          AppHeader(
            title: l10n.qotdTitle,
            subtitle: l10n.qotdQuestionProgress(
              currentIndex + 1,
              totalQuestions,
            ),
            leading: Transform.translate(
              offset: const Offset(0, -12),
              child: AppBackButton(
                onTap: () => widget.onCloseQuiz(state.hasSubmittedNewAnswer),
              ),
            ),
            showDivider: false,
          ),

          // Linear Question Progress Bar
          AppSemantics.progressValue(
            value: progress,
            label: l10n.qotdQuestionProgress(currentIndex + 1, totalQuestions),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 3,
                  width: double.infinity,
                  color: design.colors.divider,
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
                    width: constraints.maxWidth * progress,
                    color: design.colors.primary,
                  ),
                );
              },
            ),
          ),

          // Scrollable Question Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.md,
                vertical: design.spacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question Metadata Pill (e.g. "General • Hard • Single Correct")
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.md,
                        vertical: design.spacing.xs * 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: design.colors.surfaceVariant,
                        borderRadius: design.radius.pill,
                      ),
                      child: Text(
                        [
                              question.subject ?? l10n.qotdGeneral,
                              question.difficulty,
                              questionTypeLabel,
                            ].nonNulls
                            .where((text) => text.trim().isNotEmpty)
                            .map((text) => text.trim())
                            .join('  •  '),
                        style: design.typography.labelSmall.copyWith(
                          color: design.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: design.spacing.md),

                  // Question Title
                  AppHtmlV2(
                    data: question.htmlContent,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    textColor: design.colors.textPrimary,
                    baseUrl: Uri.tryParse(AppConfig.apiBaseUrl),
                  ),
                  SizedBox(height: design.spacing.lg),

                  // Option Cards
                  ...question.options.indexed.map((entry) {
                    final index = entry.$1;
                    final option = entry.$2;
                    final isSelected = selectedOptions.contains(option.id);
                    final isCorrectOption =
                        submitResponse?.correctAnswerIds.contains(option.id) ??
                        false;
                    final isUserSelectedWrong =
                        isSubmitted && isSelected && !isCorrectOption;
                    final isUserSelectedCorrect =
                        isSubmitted && isSelected && isCorrectOption;
                    final isMissedCorrect =
                        isSubmitted && !isSelected && isCorrectOption;

                    return Padding(
                      padding: EdgeInsets.only(bottom: design.spacing.sm),
                      child: _buildOptionCard(
                        design: design,
                        l10n: l10n,
                        optionIndex: index,
                        option: option,
                        isSelected: isSelected,
                        isMultipleChoice: isMultipleChoice,
                        isSubmitted: isSubmitted,
                        isUserSelectedWrong: isUserSelectedWrong,
                        isUserSelectedCorrect: isUserSelectedCorrect,
                        isMissedCorrect: isMissedCorrect,
                        onTap: (isSubmitted || state.isSubmitting)
                            ? null
                            : () => controller.selectOption(
                                currentIndex,
                                option.id,
                                isMultiple: isMultipleChoice,
                              ),
                      ),
                    );
                  }),

                  // Explanation Banner
                  if (isSubmitted && submitResponse != null) ...[
                    SizedBox(height: design.spacing.md),
                    _buildExplanationCard(
                      design: design,
                      l10n: l10n,
                      isCorrect: submitResponse.isCorrect,
                      explanation: submitResponse.explanation.isNotEmpty
                          ? submitResponse.explanation
                          : l10n.qotdNoExplanation,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Action Button(s)
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.xs,
                design.spacing.md,
                design.spacing.md,
              ),
              child: _buildActionButtons(
                design: design,
                l10n: l10n,
                currentIndex: currentIndex,
                totalQuestions: totalQuestions,
                isSubmitted: isSubmitted,
                hasSelection: hasSelection,
                isSubmitting: state.isSubmitting,
                onPrevious: () => _goToPrevious(currentIndex, controller),
                onSubmit: () => controller.submitCurrentAnswer(context),
                onNext: () {
                  if (currentIndex == totalQuestions - 1) {
                    widget.onCloseQuiz(state.hasSubmittedNewAnswer);
                  } else {
                    _goToNext(currentIndex, controller);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required DesignConfig design,
    required AppLocalizations l10n,
    required int optionIndex,
    required QotdOptionDto option,
    required bool isSelected,
    required bool isMultipleChoice,
    required bool isSubmitted,
    required bool isUserSelectedWrong,
    required bool isUserSelectedCorrect,
    required bool isMissedCorrect,
    required VoidCallback? onTap,
  }) {
    // Determine card background and border colors
    final Color backgroundColor;
    final Color borderColor;
    final double borderWidth;

    if (isUserSelectedWrong) {
      backgroundColor = design.colors.error.withValues(alpha: 0.15);
      borderColor = design.colors.error;
      borderWidth = 1.5;
    } else if (isUserSelectedCorrect) {
      backgroundColor = design.colors.success.withValues(alpha: 0.2);
      borderColor = design.colors.success;
      borderWidth = 1.5;
    } else if (isMissedCorrect) {
      backgroundColor = design.colors.card;
      borderColor = design.colors.success;
      borderWidth = 1.5;
    } else if (isSelected && !isSubmitted) {
      backgroundColor = design.colors.primary;
      borderColor = design.colors.primary;
      borderWidth = 1.5;
    } else {
      backgroundColor = design.colors.card;
      borderColor = design.colors.border;
      borderWidth = 1.0;
    }

    // Determine text color
    final Color textColor = (isSelected && !isSubmitted)
        ? design.colors.onPrimary
        : design.colors.textPrimary;

    final optionLetter = String.fromCharCode(65 + optionIndex);
    final semanticLabel = '${l10n.qotdOptionLabel} $optionLetter';

    return AppSemantics.button(
      label: semanticLabel,
      enabled: onTap != null,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: MotionPreferences.duration(context, design.motion.fast),
          curve: MotionPreferences.curve(context, design.motion.easeOut),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.md,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(design.radius.lg),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Row(
            children: [
              // Leading Selector Indicator
              _buildSelectorIndicator(
                design: design,
                isMultipleChoice: isMultipleChoice,
                isSelected: isSelected,
                isSubmitted: isSubmitted,
                isUserSelectedWrong: isUserSelectedWrong,
                isUserSelectedCorrect: isUserSelectedCorrect,
              ),
              SizedBox(width: design.spacing.sm),

              // Option Content Text
              Expanded(
                child: AppHtmlV2(
                  data: option.htmlContent,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  textColor: textColor,
                  baseUrl: Uri.tryParse(AppConfig.apiBaseUrl),
                ),
              ),

              // Trailing Feedback Icon (after submission)
              if (isSubmitted) ...[
                SizedBox(width: design.spacing.xs),
                if (isUserSelectedWrong)
                  Icon(LucideIcons.x, color: design.colors.error, size: 20)
                else if (isUserSelectedCorrect || isMissedCorrect)
                  Icon(
                    LucideIcons.check,
                    color: design.colors.success,
                    size: 20,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorIndicator({
    required DesignConfig design,
    required bool isMultipleChoice,
    required bool isSelected,
    required bool isSubmitted,
    required bool isUserSelectedWrong,
    required bool isUserSelectedCorrect,
  }) {
    final double size = 20.0;

    if (isMultipleChoice) {
      // Checkbox Indicator
      final Color boxColor;
      final Color borderColor;
      final Widget? icon;

      if (isUserSelectedWrong) {
        boxColor = design.colors.error.withValues(alpha: 0.2);
        borderColor = design.colors.error;
        icon = Icon(LucideIcons.check, size: 14, color: design.colors.error);
      } else if (isUserSelectedCorrect) {
        boxColor = design.colors.success.withValues(alpha: 0.2);
        borderColor = design.colors.success;
        icon = Icon(
          LucideIcons.check,
          size: 14,
          color: design.colors.onPrimary,
        );
      } else if (isSelected && !isSubmitted) {
        boxColor = design.colors.onPrimary.withValues(alpha: 0.2);
        borderColor = design.colors.onPrimary;
        icon = Icon(
          LucideIcons.check,
          size: 14,
          color: design.colors.onPrimary,
        );
      } else {
        boxColor = design.colors.transparent;
        borderColor = design.colors.textTertiary;
        icon = null;
      }

      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(child: icon),
      );
    } else {
      // Radio Indicator
      final Color ringColor;
      final Color? innerDotColor;

      if (isUserSelectedWrong) {
        ringColor = design.colors.error;
        innerDotColor = design.colors.error;
      } else if (isUserSelectedCorrect) {
        ringColor = design.colors.success;
        innerDotColor = design.colors.success;
      } else if (isSelected && !isSubmitted) {
        ringColor = design.colors.onPrimary;
        innerDotColor = design.colors.onPrimary;
      } else {
        ringColor = design.colors.textTertiary;
        innerDotColor = null;
      }

      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ringColor, width: 1.5),
        ),
        child: innerDotColor != null
            ? Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: innerDotColor,
                  ),
                ),
              )
            : null,
      );
    }
  }

  Widget _buildExplanationCard({
    required DesignConfig design,
    required AppLocalizations l10n,
    required bool isCorrect,
    required String explanation,
  }) {
    final Color bgColor = isCorrect
        ? design.colors.success.withValues(alpha: 0.15)
        : design.colors.error.withValues(alpha: 0.15);
    final Color borderColor = isCorrect
        ? design.colors.success.withValues(alpha: 0.4)
        : design.colors.error.withValues(alpha: 0.4);
    final IconData statusIcon = isCorrect
        ? LucideIcons.checkCircle2
        : LucideIcons.xCircle;
    final Color statusIconColor = isCorrect
        ? design.colors.success
        : design.colors.error;
    final String statusTitle = isCorrect
        ? l10n.qotdCorrect
        : l10n.qotdIncorrect;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(design.radius.lg),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusIconColor, size: 20),
              SizedBox(width: design.spacing.xs),
              AppText.title(
                statusTitle,
                color: design.colors.textPrimary,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: design.spacing.sm),
          Container(
            height: 1,
            width: double.infinity,
            color: statusIconColor.withValues(alpha: 0.2),
          ),
          SizedBox(height: design.spacing.sm),
          AppText.labelBold(
            l10n.qotdExplanationTitle,
            color: design.colors.textPrimary,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: design.spacing.xs),
          AppHtmlV2(
            data: explanation,
            fontSize: 14.0,
            textColor: design.colors.textPrimary,
            baseUrl: Uri.tryParse(AppConfig.apiBaseUrl),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons({
    required DesignConfig design,
    required AppLocalizations l10n,
    required int currentIndex,
    required int totalQuestions,
    required bool isSubmitted,
    required bool hasSelection,
    required bool isSubmitting,
    required VoidCallback onPrevious,
    required VoidCallback onSubmit,
    required VoidCallback onNext,
  }) {
    final bool hasPrevious = currentIndex > 0;
    final bool isLastQuestion = currentIndex == totalQuestions - 1;
    final bool isEnabled = isSubmitted || hasSelection;
    final Color primaryButtonColor = isEnabled
        ? design.colors.primary
        : design.colors.surfaceVariant;
    final Color primaryTextColor = isEnabled
        ? design.colors.onPrimary
        : design.colors.textTertiary;
    final String primaryLabel = isSubmitted
        ? (isLastQuestion ? l10n.qotdFinish : l10n.qotdNextQuestion)
        : l10n.qotdCheckAnswer;

    const double buttonHeight = 48.0;

    final primaryButton = AppSemantics.button(
      label: primaryLabel,
      enabled: isEnabled && !isSubmitting,
      onTap: (isEnabled && !isSubmitting)
          ? (isSubmitted ? onNext : onSubmit)
          : null,
      child: GestureDetector(
        onTap: (isEnabled && !isSubmitting)
            ? (isSubmitted ? onNext : onSubmit)
            : null,
        child: Container(
          height: buttonHeight,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          decoration: BoxDecoration(
            color: primaryButtonColor,
            borderRadius: design.radius.pill,
          ),
          child: isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: AppLoadingIndicator(color: design.colors.onPrimary),
                )
              : AppText.labelBold(
                  primaryLabel,
                  color: primaryTextColor,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
      ),
    );

    if (!hasPrevious) {
      return SizedBox(width: double.infinity, child: primaryButton);
    }

    final previousButton = AppSemantics.button(
      label: l10n.qotdPrevious,
      enabled: !isSubmitting,
      onTap: isSubmitting ? null : onPrevious,
      child: GestureDetector(
        onTap: isSubmitting ? null : onPrevious,
        child: Container(
          height: buttonHeight,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: design.radius.pill,
            border: Border.all(color: design.colors.border, width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.chevronLeft,
                size: 16,
                color: design.colors.textPrimary,
              ),
              const SizedBox(width: 4.0),
              AppText.label(
                l10n.qotdPrevious,
                color: design.colors.textPrimary,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        previousButton,
        SizedBox(width: design.spacing.sm),
        Expanded(child: primaryButton),
      ],
    );
  }
}
