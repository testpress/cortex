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

  bool _isOptionCorrect(String option, String correctAnswer) {
    final cleanOpt = option.trim();
    final cleanAns = correctAnswer.trim();
    if (cleanOpt.isEmpty || cleanAns.isEmpty) return false;
    if (cleanOpt == cleanAns) return true;
    if (cleanOpt.startsWith(cleanAns)) return true;
    if (cleanAns.startsWith(cleanOpt[0])) return true;
    return false;
  }

  int? _parseTimestampToSeconds(String timestampStr) {
    final parts = timestampStr
        .split(':')
        .map((e) => int.tryParse(e.trim()) ?? 0)
        .toList();
    if (parts.length == 2) {
      return parts[0] * 60 + parts[1];
    } else if (parts.length == 3) {
      return parts[0] * 3600 + parts[1] * 60 + parts[2];
    }
    return null;
  }

  Widget _buildTextWithTimestamps(
    BuildContext context,
    String text,
    DesignConfig design, {
    Color? textColor,
  }) {
    final regExp = RegExp(r'(\d{1,2}:\d{2}(?::\d{2})?)');
    final matches = regExp.allMatches(text);
    final color = textColor ?? design.colors.textPrimary;

    if (matches.isEmpty) {
      return AppText.body(
        text,
        color: color,
      );
    }

    final spans = <InlineSpan>[];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        final precedingText = text.substring(lastMatchEnd, match.start);
        spans.add(
          TextSpan(
            text: precedingText,
            style: TextStyle(
              color: color,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        );
      }

      final timeStr = match.group(0)!;
      final seconds = _parseTimestampToSeconds(timeStr);

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: AppFocusable(
            onTap: seconds != null && onSeek != null
                ? () => onSeek!(Duration(seconds: seconds))
                : null,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: design.colors.accent2.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(design.radius.sm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.play,
                    color: design.colors.accent2,
                    size: 11,
                  ),
                  const SizedBox(width: 3),
                  AppText.labelBold(
                    timeStr,
                    color: design.colors.accent2,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: TextStyle(
            color: color,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans),
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
            ...question.options.map((option) {
              final isOptionSelected = selectedOption == option;
              final isOptionCorrect =
                  _isOptionCorrect(option, question.correctAnswer);

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
                            style: const TextStyle(fontWeight: FontWeight.w400),
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
              );
            }),

            // Hint Button (Below Options - Only shown before answer is selected)
            if (!isAnswered && question.hint.isNotEmpty) ...[
              SizedBox(height: design.spacing.xs),
              AppFocusable(
                onTap: onToggleHint,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: design.spacing.xs),
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
                    accessibilityLabel: 'Previous Question',
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
                  accessibilityLabel: 'Next Question',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
