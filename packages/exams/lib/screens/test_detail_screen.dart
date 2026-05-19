import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../providers/exam_providers.dart';
import '../repositories/exam_repository.dart';
import '../models/review_route_payload.dart';
import '../widgets/test_detail/test_header.dart';
import '../widgets/test_detail/question_palette.dart';
import '../widgets/test_detail/test_result_view.dart';
import '../widgets/test_detail/test_progress_section.dart';
import '../widgets/test_detail/test_question_card.dart';
import '../widgets/test_detail/submit_confirmation_dialog.dart';
import '../widgets/test_detail/exam_instructions_view.dart';
import '../widgets/test_detail/sections_tab_bar.dart';

class TestDetailScreen extends ConsumerStatefulWidget {
  final String testId;
  final LessonDto? lesson;
  final VoidCallback onClose;

  const TestDetailScreen({
    super.key,
    required this.testId,
    this.lesson,
    required this.onClose,
  });

  @override
  ConsumerState<TestDetailScreen> createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends ConsumerState<TestDetailScreen> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  int _activeSubjectIndex = 0;
  bool _isSectionsTabBarExpanded = true;
  bool _showPalette = false;
  bool _showSubmitConfirmation = false;

  // Flash "Saved" indicator
  bool _isSavedVisible = false;
  Timer? _savedTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        _initializeExam();
      }
    });
  }

  void _initializeExam() {
    var state = ref.read(examAttemptProvider);
    final status = state.status;

    if (status != ExamAttemptStatus.idle && status != ExamAttemptStatus.error && state.exam?.id == widget.testId) {
      return;
    }

    if (state.exam != null && state.exam?.id != widget.testId) {
      ref.read(examAttemptProvider.notifier).reset();
      state = ref.read(examAttemptProvider);
    }

    if (status == ExamAttemptStatus.idle || (status == ExamAttemptStatus.loading && state.exam == null)) {
      final lessonDetailAsync = ref.read(lessonDetailProvider(widget.testId));
      final fetchedLesson = lessonDetailAsync.valueOrNull?.toDto();
      final lesson = widget.lesson ?? fetchedLesson;
      
      final attemptsUrl = widget.lesson?.attemptsUrl ?? fetchedLesson?.attemptsUrl;
      final slug = widget.lesson?.slug ?? fetchedLesson?.slug;

      if (lesson != null && attemptsUrl != null && attemptsUrl.isNotEmpty) {
        ref.read(examAttemptProvider.notifier).startCourseLinkedExam(
              ExamDto(
                id: lesson.id,
                title: lesson.title,
                duration: lesson.duration,
                questionCount: 0,
                attemptsUrl: attemptsUrl,
              ),
              attemptsUrl,
            );
      } else if (slug != null && slug.isNotEmpty) {
        ref.read(examAttemptProvider.notifier).loadExam(slug);
      } else if (widget.lesson == null && !lessonDetailAsync.isLoading && lessonDetailAsync.value == null) {
        ref.read(examAttemptProvider.notifier).loadExam(widget.testId);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _savedTimer?.cancel();
    super.dispose();
  }

  void _showSavedIndicator() {
    _savedTimer?.cancel();
    setState(() => _isSavedVisible = true);
    _savedTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isSavedVisible = false);
    });
  }

  String _formatTime(int seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return h == '00' ? '$m:$s' : '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final state = ref.watch(examAttemptProvider);
    final lessonDetailAsync = ref.watch(lessonDetailProvider(widget.testId));

    ref.listen<AsyncValue<Lesson?>>(lessonDetailProvider(widget.testId), (previous, next) {
      next.whenData((lesson) {
        if (lesson != null) {
          _initializeExam();
        }
      });
    });

    ref.listen<ExamAttemptState>(examAttemptProvider, (previous, next) {
      if (previous != null && previous.currentSectionIndex != next.currentSectionIndex) {
        setState(() {
          _currentQuestionIndex = 0;
        });
        if (_pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      }
    });

    if (state.status == ExamAttemptStatus.idle ||
        state.status == ExamAttemptStatus.loading) {
      return lessonDetailAsync.when(
        data: (lesson) =>
            Container(color: design.colors.surface, child: const Center(child: AppLoadingIndicator())),
        loading: () =>
            Container(color: design.colors.surface, child: const Center(child: AppLoadingIndicator())),
        error: (err, stack) =>
            Container(color: design.colors.surface, child: Center(child: AppText.body('Error loading lesson: $err'))),
      );
    }

    if (state.status == ExamAttemptStatus.instructions) {
      return ExamInstructionsView(
        exam: state.exam,
        onClose: widget.onClose,
        onStartExam: () {
          ref.read(examAttemptProvider.notifier).startStandaloneExam(state.exam!);
        },
      );
    }

    if (state.status == ExamAttemptStatus.error) {
      return Container(
        color: design.colors.surface,
        padding: EdgeInsets.all(design.spacing.xl),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.alertCircle, size: 48, color: design.colors.accent5),
              SizedBox(height: design.spacing.lg),
              AppText.title('Oops! Cannot start exam', textAlign: TextAlign.center),
              SizedBox(height: design.spacing.sm),
              AppText.body(
                state.errorMessage ?? 'An unknown error occurred.',
                textAlign: TextAlign.center,
                color: design.colors.textSecondary,
              ),
              SizedBox(height: design.spacing.xl),
              AppButton(
                label: 'Go Back',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      );
    }

    final List<String> subjects = [];
    for (final q in state.questions) {
      if (!subjects.contains(q.subject)) {
        subjects.add(q.subject);
      }
    }

    // Use all questions for the PageView to maintain KeepAlive state across the entire exam
    final allQuestions = state.questions;
    
    if (allQuestions.isEmpty) {
      return Container(
          color: design.colors.surface,
          child: Center(child: AppText.body('No questions found.')));
    }

    final safeIndex = _currentQuestionIndex < allQuestions.length ? _currentQuestionIndex : 0;
    final question = allQuestions[safeIndex];
    
    // Map the current question to its subject for the UI
    final currentSubject = question.subject;
    final currentSubjectIndex = subjects.indexOf(currentSubject);

    // Count answered questions overall (across all sections)
    final answeredCount = state.answers.entries
        .where((e) => e.value.selectedOptions.isNotEmpty)
        .length;

    // Count answered questions for the current section only
    final sectionAnsweredCount = allQuestions
        .where((q) => state.answers[q.id]?.selectedOptions.isNotEmpty ?? false)
        .length;

    // Calculate global question position and total question count across all sections
    int globalOffset = 0;
    for (int i = 0; i < state.currentSectionIndex; i++) {
      if (i < state.sections.length) {
        globalOffset += state.sections[i].questionsCount ?? 0;
      }
    }
    final globalCurrentIndex = globalOffset + safeIndex;

    final globalTotalCount = state.attempt?.totalQuestions ?? 
        state.sections.fold<int>(0, (sum, s) => sum + (s.questionsCount ?? 0));
    final displayTotalCount = globalTotalCount > 0 ? globalTotalCount : allQuestions.length;

    // Determine whether there are more tabs to navigate to after this one.
    final isMultiSection = state.sections.length > 1;
    final hasNextSection = isMultiSection &&
        state.currentSectionIndex < state.sections.length - 1;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(examAttemptProvider.notifier).reset();
        }
      },
      child: Container(
        color: design.colors.surface,
        child: Stack(
          children: [
          Column(
            children: [
              TestHeader(
                exam: state.exam!,
                timeFormatted: _formatTime(state.remainingSeconds),
                onExit: widget.onClose,
              ),
              SectionsTabBar(
                state: state,
                activeSubjectIndex: currentSubjectIndex != -1 ? currentSubjectIndex : _activeSubjectIndex,
                isExpanded: _isSectionsTabBarExpanded,
                onExpandChanged: (val) => setState(() => _isSectionsTabBarExpanded = val),
                onTabSelected: (index) {
                  if (state.sections.length > 1) {
                    ref.read(examAttemptProvider.notifier).switchSection(index);
                  } else {
                    // Jump to the first question of this subject
                    final targetSubject = subjects[index];
                    final targetIndex = allQuestions.indexWhere((q) => q.subject == targetSubject);
                    if (targetIndex != -1) {
                      _pageController.jumpToPage(targetIndex);
                    }
                  }
                },
              ),
              Expanded(
                child: Column(
                  children: [
                    TestProgressSection(
                      currentQuestionIndex: globalCurrentIndex,
                      totalQuestions: displayTotalCount,
                      isSavedVisible: _isSavedVisible,
                      answeredCount: answeredCount,
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        allowImplicitScrolling: true,
                        onPageChanged: (index) {
                          setState(() {
                            _currentQuestionIndex = index;
                            // Sync subject index if needed
                            final q = allQuestions[index];
                            final sIdx = subjects.indexOf(q.subject);
                            if (sIdx != -1) _activeSubjectIndex = sIdx;
                          });
                        },
                        itemCount: allQuestions.length,
                        itemBuilder: (context, index) {
                          final q = allQuestions[index];
                          final a = state.answers[q.id];
                          final isLast = index == allQuestions.length - 1;
                          
                          return TestQuestionCard(
                            key: ValueKey(q.id),
                            question: q,
                            answer: a,
                            isMarked: a?.isMarked ?? false,
                            canGoPrevious: index > 0,
                            isLastQuestion: isLast,
                            finishLabel: isLast && hasNextSection 
                                ? l10n.nextSection
                                : null,
                            answeredCount: sectionAnsweredCount,
                            totalQuestions: allQuestions.length,
                            onPaletteTap: () => setState(() => _showPalette = true),
                            onToggleMark: () => _handleToggleMark(state, q),
                            onPrevious: () {
                              if (index > 0) {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            onNext: () {
                              if (index < allQuestions.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else if (hasNextSection) {
                                ref
                                    .read(examAttemptProvider.notifier)
                                    .switchSection(state.currentSectionIndex + 1);
                              } else {
                                setState(() => _showSubmitConfirmation = true);
                              }
                            },
                            onOptionSelect: (optionId) =>
                                _handleOptionSelect(state, q, optionId),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + design.spacing.md),
                  ],
                ),
              ),
            ],
          ),
          if (_showPalette)
            QuestionPalette(
              questions: allQuestions,
              answers: state.answers,
              currentIndex: safeIndex,
              onClose: () => setState(() => _showPalette = false),
              onQuestionSelected: (index) {
                setState(() {
                  _currentQuestionIndex = index;
                  _showPalette = false;
                });
                _pageController.jumpToPage(index);
              },
            ),
          if (_showSubmitConfirmation)
            SubmitConfirmationDialog(
              answeredCount: answeredCount,
              totalCount: displayTotalCount,
              onCancel: () =>
                  setState(() => _showSubmitConfirmation = false),
              onSubmit: () {
                setState(() => _showSubmitConfirmation = false);
                ref
                    .read(examAttemptProvider.notifier)
                    .endExam(state.attempt!.endUrl);
              },
            ),
          if (state.status == ExamAttemptStatus.completed)
            TestResultView(
              score: state.attempt?.score,
              onReviewAnswers: () => _openReviewAnswers(state),
              onViewAnalytics: () => _openAnalytics(state),
              onClose: widget.onClose,
            ),
        ],
      ),
    ),);
  }

  void _handleOptionSelect(ExamAttemptState state, QuestionDto question, String optionId) {
    final currentAnswer = state.answers[question.id] ??
        AnswerDto(questionId: question.id, selectedOptions: []);

    List<String> newSelections;
    if (question.type == 'multipleSelect') {
      newSelections = List.from(currentAnswer.selectedOptions);
      if (newSelections.contains(optionId)) {
        newSelections.remove(optionId);
      } else {
        newSelections.add(optionId);
      }
    } else {
      newSelections = [optionId];
    }

    final newAnswer = AnswerDto(
      questionId: question.id,
      selectedOptions: newSelections,
      isMarked: currentAnswer.isMarked,
    );

    ref.read(examAttemptProvider.notifier).submitAnswer(question.answerUrl, newAnswer);
    _showSavedIndicator();
  }

  void _handleToggleMark(ExamAttemptState state, QuestionDto question) {
    final currentAnswer = state.answers[question.id] ??
        AnswerDto(questionId: question.id, selectedOptions: []);

    final newAnswer = AnswerDto(
      questionId: question.id,
      selectedOptions: currentAnswer.selectedOptions,
      isMarked: !currentAnswer.isMarked,
    );

    ref.read(examAttemptProvider.notifier).submitAnswer(question.answerUrl, newAnswer);
  }

  void _openReviewAnswers(ExamAttemptState state) {
    context.push(
      '/exams/test/${state.exam!.id}/review-answers',
      extra: ReviewRoutePayload(
        assessmentTitle: state.exam!.title,
        questions: state.questions,
        attemptStates: state.answers,
        attempt: state.attempt,
      ),
    );
  }

  void _openAnalytics(ExamAttemptState state) {
    context.push(
      '/exams/test/${state.exam!.id}/review-analytics',
      extra: ReviewRoutePayload(
        assessmentTitle: state.exam!.title,
        questions: state.questions,
        attemptStates: state.answers,
        attempt: state.attempt,
      ),
    );
  }

}
