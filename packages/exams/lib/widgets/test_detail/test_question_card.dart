import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'test_navigation_actions.dart';
import 'test_palette_trigger.dart';
import 'option_card.dart';

/// Card displayed for each question during an active exam session.
///
/// Renders the question direction, text and all options as native Flutter
/// widgets via [AppHtmlV2] so that MathJax and cached images work correctly
/// both online and offline — no CDN dependency, no WebView CORS restrictions.
///
/// Option selection is wired through native [OptionCard] taps, removing the
/// previous JS `MessageChannel.postMessage` bridge entirely.
class TestQuestionCard extends StatefulWidget {
  final QuestionDto question;
  final AnswerDto? answer;
  final bool isMarked;
  final bool canGoPrevious;
  final bool isLastQuestion;
  final String? finishLabel;
  final VoidCallback onToggleMark;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isQuizMode;
  final bool isQuizChecked;
  final QuizReviewResultDto? quizReview;
  final VoidCallback? onCheck;
  final int answeredCount;
  final int totalQuestions;
  final VoidCallback onPaletteTap;

  /// Called when the user selects an option or changes a text input.
  ///
  /// For MCQ options, the raw option-ID string is passed.
  /// For text inputs, a JSON-encoded `{"type":"inputChange","value":"..."}` is
  /// passed so the existing [_handleHtmlMessage] in the parent screen can
  /// route it correctly without modification.
  final void Function(String) onOptionSelect;

  const TestQuestionCard({
    super.key,
    required this.question,
    required this.answer,
    required this.isMarked,
    required this.canGoPrevious,
    required this.isLastQuestion,
    this.finishLabel,
    required this.answeredCount,
    required this.totalQuestions,
    required this.onPaletteTap,
    required this.onToggleMark,
    required this.onPrevious,
    required this.onNext,
    required this.onOptionSelect,
    this.isQuizMode = false,
    this.isQuizChecked = false,
    this.quizReview,
    this.onCheck,
  });

  @override
  State<TestQuestionCard> createState() => _TestQuestionCardState();
}

class _TestQuestionCardState extends State<TestQuestionCard> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _currentInputValue());
  }

  @override
  void didUpdateWidget(TestQuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset the text field when navigating to a different question.
    if (oldWidget.question.id != widget.question.id) {
      _textController.text = _currentInputValue();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _currentInputValue() {
    final a = widget.answer;
    if (a == null) return '';
    if (widget.question.type == 'essay') return a.essayText ?? '';
    return a.shortText ?? '';
  }

  /// Returns the IDs of correct options for this question.
  /// Priority: quiz-review server response → question DTO → option.isCorrect flag.
  List<String> _correctIds() {
    final qr = widget.quizReview;
    if (qr != null && qr.correctAnswers.isNotEmpty) {
      return qr.correctAnswers.map((e) => e.toString()).toList();
    }
    final q = widget.question;
    if (q.correctOptionIds.isNotEmpty) {
      return q.correctOptionIds.map((e) => e.toString()).toList();
    }
    return q.options
        .where((o) => o.isCorrect)
        .map((o) => o.id.toString())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final q = widget.question;
    final answer = widget.answer;

    final correctIds = widget.isQuizChecked ? _correctIds() : <String>[];

    final isInputType =
        q.type == 'shortAnswer' || q.type == 'numerical' || q.type == 'essay';

    // Explanation shown in quiz-review mode.
    final String? explanationContent = widget.isQuizChecked
        ? ((widget.quizReview?.explanationHtml?.isNotEmpty == true)
              ? widget.quizReview!.explanationHtml
              : (q.explanation?.isNotEmpty == true ? q.explanation : null))
        : null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(design.spacing.md),
            padding: EdgeInsets.all(design.spacing.md),
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.circular(design.radius.md),
              border: Border.all(color: design.colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Direction / passage shown above the question when present.
                if (q.directionHtml != null && q.directionHtml!.isNotEmpty) ...[
                  AppHtmlV2(
                    data: q.directionHtml!,
                    fontSize: design.typography.body.fontSize ?? 18.0,
                  ),
                  SizedBox(height: design.spacing.md),
                  Container(height: 1, color: design.colors.border),
                  SizedBox(height: design.spacing.md),
                ],

                // Question text.
                AppHtmlV2(
                  data: q.text,
                  fontSize: design.typography.body.fontSize ?? 18.0,
                ),
                SizedBox(height: design.spacing.md),

                // "Select all that apply" hint for multi-select questions.
                if (q.type == 'multipleSelect' && !widget.isQuizChecked) ...[
                  Text(
                    l10n.testSelectAllApply,
                    style: TextStyle(
                      fontSize: design.typography.label.fontSize ?? 12.0,
                      fontStyle: FontStyle.italic,
                      color: design.colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: design.spacing.sm),
                ],

                // Options or input field.
                if (isInputType)
                  _buildInputField(design, l10n, q, answer, correctIds)
                else
                  _buildOptions(design, q, answer, correctIds),

                // Explanation box in quiz-review mode.
                if (explanationContent != null) ...[
                  SizedBox(height: design.spacing.md),
                  _buildExplanation(design, l10n, explanationContent),
                ],
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: design.spacing.md,
              right: design.spacing.md,
              bottom: design.spacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TestNavigationActions(
                  isMarked: widget.isMarked,
                  canGoPrevious: widget.canGoPrevious,
                  isLastQuestion: widget.isLastQuestion,
                  finishLabel: widget.finishLabel,
                  onToggleMark: widget.onToggleMark,
                  onPrevious: widget.onPrevious,
                  onNext: widget.onNext,
                  isQuizMode: widget.isQuizMode,
                  isQuizChecked: widget.isQuizChecked,
                  onCheck: widget.onCheck,
                ),
                SizedBox(height: design.spacing.md),
                TestPaletteTrigger(
                  answeredCount: widget.answeredCount,
                  totalQuestions: widget.totalQuestions,
                  onTap: widget.onPaletteTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Renders the MCQ options as a list of native [OptionCard] widgets.
  Widget _buildOptions(
    DesignConfig design,
    QuestionDto q,
    AnswerDto? answer,
    List<String> correctIds,
  ) {
    return Column(
      children: q.options.map((option) {
        final optionId = option.id.toString();
        final isSelected =
            answer?.selectedOptions.any((id) => id.toString() == optionId) ??
            false;
        final isCorrect =
            widget.isQuizChecked && correctIds.any((id) => id == optionId);
        final isIncorrect = widget.isQuizChecked && isSelected && !isCorrect;

        return OptionCard(
          option: option,
          isSelected: isSelected,
          type: q.type,
          showFeedback: widget.isQuizChecked,
          isCorrect: isCorrect,
          isIncorrect: isIncorrect,
          onTap: widget.isQuizChecked
              ? null
              : () => widget.onOptionSelect(optionId),
        );
      }).toList(),
    );
  }

  /// Renders a text/essay input for short-answer, numerical and essay questions.
  ///
  /// In quiz-review mode, shows the user's answer and the correct answer
  /// as read-only display containers.
  Widget _buildInputField(
    DesignConfig design,
    AppLocalizations l10n,
    QuestionDto q,
    AnswerDto? answer,
    List<String> correctIds,
  ) {
    if (widget.isQuizChecked) {
      final userValue = q.type == 'essay'
          ? (answer?.essayText ?? '')
          : (answer?.shortText ?? '');

      final correctOptions = q.options.where((o) => o.isCorrect).toList();
      final correctValues = correctOptions.isNotEmpty
          ? correctOptions.map((o) => o.text).toList()
          : q.options.map((o) => o.text).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User's answer (read-only).
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(design.spacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(design.radius.md),
              border: Border.all(color: design.colors.border),
            ),
            child: Text(
              userValue.isEmpty ? l10n.noAnswerGiven : userValue,
              style: TextStyle(color: design.colors.textPrimary, fontSize: 18),
            ),
          ),
          if (correctValues.isNotEmpty) ...[
            SizedBox(height: design.spacing.sm),
            Text(
              l10n.correctAnswerLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: design.colors.textSecondary,
              ),
            ),
            SizedBox(height: design.spacing.xs),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(design.spacing.md),
              decoration: BoxDecoration(
                color: design.colors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(design.radius.md),
                border: Border.all(color: design.colors.success),
              ),
              child: AppHtmlV2(
                data: correctValues.join(', '),
                textColor: design.colors.textPrimary,
                fontSize: 18,
              ),
            ),
          ],
        ],
      );
    }

    // Active input mode — use the shared AppTextField from core.
    return AppTextField(
      label: '',
      hintText: 'YOUR ANSWER',
      controller: _textController,
      maxLines: q.type == 'essay' ? null : 1,
      keyboardType: q.type == 'numerical'
          ? const TextInputType.numberWithOptions(decimal: true, signed: true)
          : q.type == 'essay'
          ? TextInputType.multiline
          : TextInputType.text,
      onChanged: (val) {
        widget.onOptionSelect(
          jsonEncode({'type': 'inputChange', 'value': val}),
        );
      },
    );
  }

  /// Renders the explanation box shown in quiz-review mode.
  Widget _buildExplanation(
    DesignConfig design,
    AppLocalizations l10n,
    String content,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.accent2.withValues(
          alpha: design.isDark ? 0.18 : 0.12,
        ),
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(
          color: design.colors.accent2.withValues(
            alpha: design.isDark ? 0.40 : 0.35,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.assessmentExplanation,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: design.colors.accent2,
            ),
          ),
          SizedBox(height: design.spacing.sm),
          AppHtmlV2(
            data: content,
            textColor: design.colors.textSecondary,
            fontSize: 18,
          ),
        ],
      ),
    );
  }
}
