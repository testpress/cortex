import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'test_navigation_actions.dart';
import 'test_palette_trigger.dart';
import 'test_question_html_builder.dart';
import '../../screens/review_answer/widgets/review_question_html_builder.dart';

/// Card displayed for each question during an active exam session.
///
/// Renders the question text and all options in a single [AppHtml] widget
/// (one WebView) so that MathJax initialises only once per question instead
/// of once per option.  See [TestQuestionHtmlBuilder] for the HTML details.
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
  // Cache the HTML so that answer state updates (option taps) don't
  // reload the WebView — the JS inside handles immediate visual toggling.
  String _htmlData = '';
  String? _lastQuestionId;
  bool? _lastIsDark;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isDark = design.isDark;
    final l10n = L10n.of(context);

    // Rebuild HTML only when the question or colour-scheme changes.
    if (_htmlData.isEmpty ||
        _lastQuestionId != widget.question.id ||
        _lastIsDark != isDark ||
        widget.isQuizChecked) {
      _htmlData = widget.isQuizChecked
          ? ReviewQuestionHtmlBuilder.build(
              question: widget.question,
              attemptState: widget.answer,
              quizReview: widget.quizReview,
              design: design,
              l10n: l10n,
            )
          : TestQuestionHtmlBuilder.build(
              question: widget.question,
              answer: widget.answer,
              design: design,
              context: context,
            );
      _lastQuestionId = widget.question.id;
      _lastIsDark = isDark;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 400),
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
                // Direction / passage shown above the question when present
                if (widget.question.directionHtml != null &&
                    widget.question.directionHtml!.isNotEmpty) ...[
                  AppHtml(data: widget.question.directionHtml!, fontSize: 16),
                  SizedBox(height: design.spacing.md),
                  Container(height: 1, color: design.colors.border),
                  SizedBox(height: design.spacing.md),
                ],

                // Unified question + options WebView
                AppHtml(
                  data: _htmlData,
                  fontSize: 16,
                  onMessage: widget.onOptionSelect,
                ),
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
}
