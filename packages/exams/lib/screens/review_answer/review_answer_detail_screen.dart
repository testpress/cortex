import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../../models/test_model.dart';
import 'review_state_logic.dart';
import 'widgets/review_header.dart';
import 'widgets/review_filter_bar.dart';
import 'widgets/review_question_view.dart';
import 'widgets/review_footer_actions.dart';
import 'widgets/review_navigation.dart';
import 'widgets/review_analytics_view.dart';
import 'widgets/review_dialog_components.dart';
import 'widgets/review_empty_state.dart';

class ReviewAnswerDetailScreen extends StatefulWidget {
  final String assessmentTitle;
  final List<TestQuestion> questions;
  final Map<String, TestAttemptAnswer> attemptStates;
  final VoidCallback onBack;
  final int initialQuestionIndex;

  const ReviewAnswerDetailScreen({
    super.key,
    required this.assessmentTitle,
    required this.questions,
    required this.attemptStates,
    required this.onBack,
    this.initialQuestionIndex = 0,
  });

  @override
  State<ReviewAnswerDetailScreen> createState() =>
      _ReviewAnswerDetailScreenState();
}

class _ReviewAnswerDetailScreenState extends State<ReviewAnswerDetailScreen>
    with ReviewStateLogic {
  late int _currentQuestionIndex;
  ReviewFilter _activeFilter = ReviewFilter.all;

  @override
  Map<String, TestAttemptAnswer> get attemptStates => widget.attemptStates;
  @override
  List<TestQuestion> get allQuestions => widget.questions;

  @override
  void initState() {
    super.initState();
    _currentQuestionIndex = widget.initialQuestionIndex;
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = AppLocalizations.of(context)!;
    final filtered = getFilteredQuestions(_activeFilter);
    final currentQuestion = filtered.isNotEmpty
        ? filtered[_currentQuestionIndex]
        : null;

    return Container(
      color: design.colors.surface,
      child: Column(
        children: [
          ReviewHeader(
            l10n: l10n,
            assessmentTitle: widget.assessmentTitle,
            onBack: widget.onBack,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ReviewFilterBar(
                    l10n: l10n,
                    activeFilter: _activeFilter,
                    onFilterChanged: (f) => setState(() {
                      _activeFilter = f;
                      _currentQuestionIndex = 0;
                    }),
                    countAll: countFor(ReviewFilter.all),
                    countCorrect: countFor(ReviewFilter.correct),
                    countIncorrect: countFor(ReviewFilter.incorrect),
                    countUnanswered: countFor(ReviewFilter.unanswered),
                  ),
                  if (currentQuestion != null) ...[
                    ReviewQuestionCard(
                      question: currentQuestion,
                      attemptState: widget.attemptStates[currentQuestion.id],
                      l10n: l10n,
                      isCorrect: isAnswerCorrect(currentQuestion),
                      isUnanswered: isUnanswered(currentQuestion),
                    ),
                    ReviewFooterActions(
                      l10n: l10n,
                      onAskDoubt: () =>
                          _showAskDoubtDialog(currentQuestion, design, l10n),
                      onComment: () =>
                          _showCommentDialog(currentQuestion, design, l10n),
                      onReport: () =>
                          _showReportDialog(currentQuestion, design, l10n),
                    ),
                    ReviewNavigation(
                      l10n: l10n,
                      currentIndex: _currentQuestionIndex,
                      totalCount: filtered.length,
                      onPrevious: () => setState(() => _currentQuestionIndex--),
                      onNext: () => setState(() => _currentQuestionIndex++),
                    ),
                  ] else
                    ReviewEmptyState(l10n: l10n),
                  ReviewOverallSummary(
                    l10n: l10n,
                    correct: countFor(ReviewFilter.correct),
                    incorrect: countFor(ReviewFilter.incorrect),
                    unanswered: countFor(ReviewFilter.unanswered),
                    total: widget.questions.length,
                  ),

                  SizedBox(height: design.spacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAskDoubtDialog(
    TestQuestion question,
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    final truncatedText = question.text.length > 50
        ? "${question.text.substring(0, 50)}..."
        : question.text;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: l10n.labelAskDoubt,
      barrierColor: design.colors.shadow.withValues(alpha: 0.6),
      pageBuilder: (context, anim1, anim2) => BaseReviewDialog(
        title: l10n.reviewAskDoubtTitle,
        design: design,
        submitLabel: l10n.reviewSubmitDoubt,
        submitColor: design.colors.accent2,
        onCancel: () => Navigator.pop(context),
        onSubmit: (val) => Navigator.pop(context),
        contentBuilder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.body(
              "${l10n.reviewQuestionLabel(question.number.toString())}: $truncatedText",
              color: design.colors.textSecondary,
              maxLines: 2,
            ),
            SizedBox(height: design.spacing.md),
            ReviewTextField(
              hint: l10n.reviewDescribeDoubtHint,
              design: design,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentDialog(
    TestQuestion question,
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: l10n.reviewAddCommentTitle,
      barrierColor: design.colors.shadow.withValues(alpha: 0.6),
      pageBuilder: (context, anim1, anim2) => BaseReviewDialog(
        title: l10n.reviewAddCommentTitle,
        design: design,
        submitLabel: l10n.reviewPostComment,
        submitColor: design.colors.primary,
        onCancel: () => Navigator.pop(context),
        onSubmit: (val) => Navigator.pop(context),
        contentBuilder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.body(
              l10n.reviewShareThoughtsOnQuestion(question.number),
              color: design.colors.textSecondary,
            ),
            SizedBox(height: design.spacing.md),
            ReviewTextField(
              hint: l10n.reviewWriteCommentHint,
              design: design,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(
    TestQuestion question,
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: l10n.reviewReportIssueTitle,
      barrierColor: design.colors.shadow.withValues(alpha: 0.6),
      pageBuilder: (context, anim1, anim2) => ReportReviewDialog(
        questionNumber: question.number,
        design: design,
        l10n: l10n,
        onSubmit: (index, text) => Navigator.pop(context),
      ),
    );
  }
}
