import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../providers/exam_providers.dart';
import 'review_state_logic.dart';
import 'widgets/review_header.dart';
import 'widgets/review_filter_bar.dart';
import 'widgets/review_question_view.dart';
import 'widgets/review_footer_actions.dart';
import 'widgets/review_navigation.dart';
import 'widgets/review_analytics_view.dart';
import 'widgets/review_dialog_components.dart';
import 'widgets/review_empty_state.dart';

class ReviewAnswerDetailScreen extends ConsumerStatefulWidget {
  final String assessmentTitle;
  final List<QuestionDto> questions;
  final Map<String, AnswerDto> attemptStates;
  final AttemptDto? attempt;
  final VoidCallback onBack;
  final int initialQuestionIndex;

  const ReviewAnswerDetailScreen({
    super.key,
    required this.assessmentTitle,
    required this.questions,
    required this.attemptStates,
    this.attempt,
    required this.onBack,
    this.initialQuestionIndex = 0,
  });

  @override
  ConsumerState<ReviewAnswerDetailScreen> createState() =>
      _ReviewAnswerDetailScreenState();
}

class _ReviewAnswerDetailScreenState
    extends ConsumerState<ReviewAnswerDetailScreen>
    with ReviewStateLogic {
  late int _currentQuestionIndex;
  ReviewFilter _activeFilter = ReviewFilter.all;

  bool _isLoading = true;
  List<QuestionDto> _questions = [];
  Map<String, AnswerDto> _attemptStates = {};
  String? _errorMessage;

  @override
  Map<String, AnswerDto> get attemptStates => _attemptStates;
  @override
  List<QuestionDto> get allQuestions => _questions;

  @override
  void initState() {
    super.initState();
    _currentQuestionIndex = widget.initialQuestionIndex;
    _initializeData();
  }

  void _initializeData() {
    final attempt = widget.attempt;
    if (attempt == null) {
      // Backwards compatible fallback
      setState(() {
        _questions = widget.questions;
        _attemptStates = widget.attemptStates;
        _isLoading = false;
      });
      return;
    }

    _fetchReviewItems();
  }

  Future<void> _fetchReviewItems() async {
    final attempt = widget.attempt;
    if (attempt == null) return;

    try {
      final String reviewUrl = ApiEndpoints.solutionsReview(
        attempt.id.toString(),
      );

      final reviewItems = await ref
          .read(examRepositoryProvider)
          .getReviewItems(reviewUrl);

      if (!mounted) return;

      final List<QuestionDto> mappedQs = [];
      final Map<String, AnswerDto> mappedStates = {};

      for (final item in reviewItems) {
        final q = item.toQuestionDto();
        mappedQs.add(q);
        mappedStates[q.id] = item.toAnswerDto();
      }

      setState(() {
        _questions = mappedQs;
        _attemptStates = mappedStates;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Container(
        color: design.colors.surface,
        child: Column(
          children: [
            ReviewHeader(
              l10n: l10n,
              assessmentTitle: widget.assessmentTitle,
              onBack: widget.onBack,
            ),
            const Expanded(child: Center(child: AppLoadingIndicator())),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AppText.body(
                    'Failed to load solutions: $_errorMessage',
                    color: design.colors.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

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
                      attemptState: _attemptStates[currentQuestion.id],
                      l10n: l10n,
                      isCorrect: isAnswerCorrect(currentQuestion),
                      isUnanswered: isUnanswered(currentQuestion),
                      questionNumber: (() {
                        final idx = _questions.indexWhere(
                          (q) => q.id == currentQuestion.id,
                        );
                        return (idx != -1 ? idx + 1 : 1).toString();
                      })(),
                    ),
                    ReviewFooterActions(
                      l10n: l10n,
                      onAskDoubt: () => context.push(
                        '/home/discussions/doubts/ask?question_id=${Uri.encodeComponent(currentQuestion.id)}',
                      ),
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
                    total: _questions.length,
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

  void _showCommentDialog(
    QuestionDto question,
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
              l10n.reviewShareThoughtsOnQuestion(
                _questions.indexOf(question) + 1,
              ),
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
    QuestionDto question,
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: l10n.reviewReportIssueTitle,
      barrierColor: design.colors.shadow.withValues(alpha: 0.6),
      pageBuilder: (context, anim1, anim2) => ReportReviewDialog(
        questionNumber: (_questions.indexOf(question) + 1),
        design: design,
        l10n: l10n,
        onSubmit: (index, text) => Navigator.pop(context),
      ),
    );
  }
}
