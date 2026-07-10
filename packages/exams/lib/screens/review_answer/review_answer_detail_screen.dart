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
import 'widgets/review_dialog_components.dart';
import 'widgets/review_empty_state.dart';
import '../../widgets/test_detail/question_palette.dart';
import '../../widgets/test_detail/question_palette_strategy.dart';
import '../../widgets/test_detail/test_palette_trigger.dart';

class ReviewAnswerDetailScreen extends ConsumerStatefulWidget {
  final String assessmentTitle;
  final List<QuestionDto> questions;
  final Map<String, AnswerDto> attemptStates;
  final AttemptDto? attempt;
  final VoidCallback onBack;
  final String? initialQuestionId;
  final bool skipFetch;

  const ReviewAnswerDetailScreen({
    super.key,
    required this.assessmentTitle,
    required this.questions,
    required this.attemptStates,
    this.attempt,
    required this.onBack,
    this.initialQuestionId,
    this.skipFetch = false,
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
  bool _showPalette = false;

  bool _isLoading = true;
  List<QuestionDto> _questions = [];
  Map<String, AnswerDto> _attemptStates = {};
  String? _errorMessage;
  bool _isBookmarkSheetOpen = false;
  bool _isCreateFolderDialogOpen = false;

  @override
  Map<String, AnswerDto> get attemptStates => _attemptStates;
  @override
  List<QuestionDto> get allQuestions => _questions;

  @override
  void initState() {
    super.initState();
    _currentQuestionIndex = 0;
    _initializeData();
  }

  void _navigateToQuestion(int index) {
    setState(() {
      _activeFilter = ReviewFilter.all;
      _currentQuestionIndex = index;
      _showPalette = false;
    });
  }

  void _initializeData() {
    if (widget.skipFetch) {
      setState(() {
        _questions = widget.questions;
        _attemptStates = widget.attemptStates;
        if (widget.initialQuestionId != null) {
          final idx = _questions.indexWhere(
            (q) => q.id == widget.initialQuestionId,
          );
          if (idx != -1) _currentQuestionIndex = idx;
        }
        _isLoading = false;
      });
      return;
    }
    final attempt = widget.attempt;
    if (attempt == null) {
      // Backwards compatible fallback
      setState(() {
        _questions = widget.questions;
        _attemptStates = widget.attemptStates;
        if (widget.initialQuestionId != null) {
          final idx = _questions.indexWhere(
            (q) => q.id == widget.initialQuestionId,
          );
          if (idx != -1) _currentQuestionIndex = idx;
        }
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
        if (widget.initialQuestionId != null) {
          final idx = _questions.indexWhere(
            (q) => q.id == widget.initialQuestionId,
          );
          if (idx != -1) _currentQuestionIndex = idx;
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e is ApiException ? e.message : e.toString();
        _isLoading = false;
      });
    }
  }

  void _onBookmarkToggle(QuestionDto question) {
    if (question.bookmarkId != null) {
      _removeBookmark(question);
    } else {
      setState(() => _isBookmarkSheetOpen = true);
    }
  }

  Future<void> _removeBookmark(QuestionDto question) async {
    final bookmarkId = question.bookmarkId;
    if (bookmarkId == null) return;

    final l10n = AppLocalizations.of(context)!;
    AppToast.show(context, message: l10n.bookmarkRemoved);

    try {
      await ref.read(
        removeBookmarkProvider(
          bookmarkId: int.tryParse(bookmarkId) ?? 0,
          lessonId:
              int.tryParse(question.userSelectedAnswerId ?? question.id) ?? 0,
        ).future,
      );

      if (!mounted) return;
      setState(() {
        final idx = _questions.indexWhere((q) => q.id == question.id);
        if (idx != -1) {
          _questions[idx] = question.copyWith(bookmarkId: null);
        }
      });
    } catch (e, stack) {
      debugPrint('Error removing bookmark: $e\n$stack');
      if (mounted) {
        AppToast.show(
          context,
          message: L10n.of(context).errorFailedToRemoveBookmark,
          isError: true,
        );
      }
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

    final parsedLessonId = currentQuestion != null
        ? int.tryParse(
                currentQuestion.userSelectedAnswerId ?? currentQuestion.id,
              ) ??
              0
        : 0;

    ref.listen(bookmarksForLessonProvider(parsedLessonId), (prev, next) {
      next.whenOrNull(
        data: (bookmarks) {
          if (!mounted || currentQuestion == null) return;
          final newBookmarkId = bookmarks.isNotEmpty
              ? bookmarks.first.id
              : null;
          if (newBookmarkId != null &&
              newBookmarkId.toString() != currentQuestion.bookmarkId) {
            setState(() {
              final idx = _questions.indexWhere(
                (q) => q.id == currentQuestion.id,
              );
              if (idx != -1) {
                _questions[idx] = _questions[idx].copyWith(
                  bookmarkId: newBookmarkId.toString(),
                );
              }
            });
          }
        },
      );
    });

    return Stack(
      children: [
        Container(
          color: design.colors.surface,
          child: Stack(
            children: [
              Column(
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
                              onBookmarkToggle: () =>
                                  _onBookmarkToggle(currentQuestion),
                            ),
                            ReviewFooterActions(
                              l10n: l10n,
                              isReported: ref
                                  .watch(examAttemptProvider)
                                  .reportedQuestions
                                  .contains(currentQuestion.id),
                              onAskDoubt: () => context.push(
                                '/home/discussions/doubts/ask?question_id=${Uri.encodeComponent(currentQuestion.id)}',
                              ),
                              onReport: () => _showReportDialog(
                                currentQuestion,
                                design,
                                l10n,
                              ),
                            ),
                            ReviewNavigation(
                              l10n: l10n,
                              currentIndex: _currentQuestionIndex,
                              totalCount: filtered.length,
                              onPrevious: () =>
                                  setState(() => _currentQuestionIndex--),
                              onNext: () =>
                                  setState(() => _currentQuestionIndex++),
                            ),
                          ] else
                            ReviewEmptyState(l10n: l10n),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: design.spacing.md,
                            ),
                            child: TestPaletteTrigger(
                              totalQuestions: _questions.length,
                              onTap: () => setState(() => _showPalette = true),
                            ),
                          ),

                          SizedBox(height: design.spacing.xl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_showPalette)
                QuestionPalette(
                  questions: _questions,
                  answers: _attemptStates,
                  onClose: () => setState(() => _showPalette = false),
                  onQuestionSelected: _navigateToQuestion,
                  strategy: ReviewStrategy(
                    isAnswerCorrect: isAnswerCorrect,
                    isUnanswered: isUnanswered,
                  ),
                ),
            ],
          ),
        ),
        AppBottomSheet(
          isOpen: _isBookmarkSheetOpen,
          onClose: () => setState(() => _isBookmarkSheetOpen = false),
          child: BookmarkFoldersSheet(
            lessonId: parsedLessonId,
            category: 'user_selected_answer',
            parentContext: context,
            onClose: () => setState(() => _isBookmarkSheetOpen = false),
            onCreateFolderRequest: () {
              setState(() {
                _isBookmarkSheetOpen = false;
                _isCreateFolderDialogOpen = true;
              });
            },
            attemptId: widget.attempt?.id,
          ),
        ),
        if (_isCreateFolderDialogOpen)
          CreateFolderDialog(
            lessonId: parsedLessonId,
            category: 'user_selected_answer',
            onClose: () => setState(() => _isCreateFolderDialogOpen = false),
            attemptId: widget.attempt?.id,
          ),
      ],
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
      pageBuilder: (dialogContext, anim1, anim2) => ReportReviewDialog(
        questionId: question.id,
        questionNumber: (_questions.indexOf(question) + 1),
        design: design,
        l10n: l10n,
        parentContext: context,
      ),
    );
  }
}
