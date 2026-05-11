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
import '../widgets/test_detail/test_navigation_actions.dart';
import '../widgets/test_detail/test_palette_trigger.dart';
import '../widgets/test_detail/submit_confirmation_dialog.dart';

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
      final lesson = widget.lesson ?? lessonDetailAsync.valueOrNull?.toDto();

      if (lesson != null && lesson.attemptsUrl != null && lesson.attemptsUrl!.isNotEmpty) {
        ref.read(examAttemptProvider.notifier).startCourseLinkedExam(
              ExamDto(
                id: lesson.id,
                title: lesson.title,
                duration: lesson.duration,
                questionCount: 0,
                attemptsUrl: lesson.attemptsUrl!,
              ),
              lesson.attemptsUrl!,
            );
      } else if (lesson != null && lesson.slug != null && lesson.slug!.isNotEmpty) {
        ref.read(examAttemptProvider.notifier).loadExam(lesson.slug!);
      } else if (widget.lesson == null && !lessonDetailAsync.isLoading && lessonDetailAsync.value == null) {
        ref.read(examAttemptProvider.notifier).loadExam(widget.testId);
      }
    }
  }

  @override
  void dispose() {
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
      return Container(
        color: design.colors.surface,
        child: Column(
          children: [
            AppHeader(
              title: state.exam?.title ?? 'Instructions',
              leading: GestureDetector(
                onTap: widget.onClose,
                child: const Icon(LucideIcons.x),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(design.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText.headline(l10n.examInstructions),
                    SizedBox(height: design.spacing.md),
                    Expanded(
                      child: SingleChildScrollView(
                        child: AppText.body(
                          'Please read the instructions carefully before starting the exam...',
                        ),
                      ),
                    ),
                    AppButton(
                      onPressed: () {
                        ref
                            .read(examAttemptProvider.notifier)
                            .startStandaloneExam(state.exam!);
                      },
                      label: l10n.startExam,
                      fullWidth: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.status == ExamAttemptStatus.error) {
      return Container(
          color: design.colors.surface,
          child: Center(child: AppText.body('Error: ${state.errorMessage}')));
    }

    final List<String> subjects = [];
    for (final q in state.questions) {
      if (!subjects.contains(q.subject)) {
        subjects.add(q.subject);
      }
    }

    final List<QuestionDto> activeQuestions;
    if (subjects.length > 1) {
      final activeSubject = subjects[_activeSubjectIndex < subjects.length ? _activeSubjectIndex : 0];
      activeQuestions = state.questions.where((q) => q.subject == activeSubject).toList();
    } else {
      activeQuestions = state.questions;
    }

    if (activeQuestions.isEmpty) {
      return Container(
          color: design.colors.surface,
          child: Center(child: AppText.body('No questions found.')));
    }
    final safeIndex = _currentQuestionIndex < activeQuestions.length ? _currentQuestionIndex : 0;
    final question = activeQuestions[safeIndex];
    final answer = state.answers[question.id];
    // Only count answers for questions in the active section/view,
    // so the palette trigger always shows "X/N answered" for THIS section.
    final activeQuestionIds = activeQuestions.map((q) => q.id).toSet();
    final answeredCount = state.answers.entries
        .where((e) => activeQuestionIds.contains(e.key) && e.value.selectedOptions.isNotEmpty)
        .length;

    // Determine whether there are more tabs to navigate to after this one.
    final isMultiSection = state.sections.length > 1;
    final hasNextSection = isMultiSection &&
        state.currentSectionIndex < state.sections.length - 1;

    final hasNextSubject = _activeSubjectIndex < subjects.length - 1;
    final hasNextTab = hasNextSubject || hasNextSection;
    final isLastQuestion = safeIndex == activeQuestions.length - 1;

    return Container(
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
              _buildSectionsTabBar(state),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TestProgressSection(
                        currentQuestionIndex: safeIndex,
                        totalQuestions: activeQuestions.length,
                        isSavedVisible: _isSavedVisible,
                      ),
                      TestQuestionCard(
                        question: question,
                        answer: answer,
                        onOptionSelect: (optionId) =>
                            _handleOptionSelect(state, question, optionId),
                      ),
                      TestNavigationActions(
                        isMarked: answer?.isMarked ?? false,
                        canGoPrevious: safeIndex > 0 || _activeSubjectIndex > 0,
                        // Show "Finish" only on the true last question of the last tab.
                        isLastQuestion: isLastQuestion,
                        // Relabel when there are more tabs to move through.
                        finishLabel: isLastQuestion && hasNextTab 
                            ? (hasNextSubject ? l10n.nextSubject : l10n.nextSection) 
                            : null,
                        onToggleMark: () => _handleToggleMark(state, question),
                        onPrevious: () {
                          if (safeIndex > 0) {
                            setState(() => _currentQuestionIndex = safeIndex - 1);
                          } else if (_activeSubjectIndex > 0) {
                            setState(() {
                              _activeSubjectIndex = _activeSubjectIndex - 1;
                              final prevSubject = subjects[_activeSubjectIndex];
                              final prevQuestionsCount = state.questions.where((q) => q.subject == prevSubject).length;
                              _currentQuestionIndex = prevQuestionsCount - 1;
                            });
                          }
                        },
                        onNext: () {
                          if (safeIndex < activeQuestions.length - 1) {
                            setState(() => _currentQuestionIndex = safeIndex + 1);
                          } else if (hasNextSubject) {
                            setState(() {
                              _currentQuestionIndex = 0;
                              _activeSubjectIndex = _activeSubjectIndex + 1;
                            });
                          } else if (hasNextSection) {
                            // Real API section switch
                            setState(() {
                              _currentQuestionIndex = 0;
                              _activeSubjectIndex = 0;
                            });
                            ref
                                .read(examAttemptProvider.notifier)
                                .switchSection(state.currentSectionIndex + 1);
                          } else {
                            setState(() => _showSubmitConfirmation = true);
                          }
                        },
                      ),
                      SizedBox(height: design.spacing.md),
                      TestPaletteTrigger(
                        answeredCount: answeredCount,
                        totalQuestions: activeQuestions.length,
                        onTap: () => setState(() => _showPalette = true),
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
              questions: activeQuestions,
              answers: state.answers,
              currentIndex: safeIndex,
              onClose: () => setState(() => _showPalette = false),
              onQuestionSelected: (index) {
                setState(() {
                  _currentQuestionIndex = index;
                  _showPalette = false;
                });
              },
            ),
          if (_showSubmitConfirmation)
            SubmitConfirmationDialog(
              answeredCount: answeredCount,
              totalCount: activeQuestions.length,
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
    );
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
      ),
    );
  }

  Widget _buildSectionsTabBar(ExamAttemptState state) {
    final List<String> tabNames = [];
    final List<String> subjects = [];
    
    if (state.sections.length > 1) {
      tabNames.addAll(state.sections.map((s) => s.name));
    } else {
      for (final q in state.questions) {
        if (!subjects.contains(q.subject)) {
          subjects.add(q.subject);
        }
      }
      if (subjects.length > 1) {
        tabNames.addAll(subjects);
      }
    }

    if (tabNames.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);
    final activeIndex = state.sections.length > 1 
        ? state.currentSectionIndex 
        : _activeSubjectIndex;
    final activeName = tabNames[activeIndex < tabNames.length ? activeIndex : 0];

    if (!_isSectionsTabBarExpanded) {
      return GestureDetector(
        onTap: () => setState(() => _isSectionsTabBarExpanded = true),
        child: Container(
          height: 32,
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          decoration: BoxDecoration(
            color: design.colors.card,
            border: Border(
              bottom: BorderSide(
                color: design.colors.border,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.caption(
                '${state.sections.length > 1 ? "Section" : "Subject"}: ${activeName.isEmpty ? "General" : activeName}',
                color: design.colors.textPrimary,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: design.spacing.xs),
              Icon(
                LucideIcons.chevronDown,
                size: 16,
                color: design.colors.textSecondary,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: design.colors.surface,
        border: Border(
          bottom: BorderSide(
            color: design.colors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0x00FFFFFF),
                  ],
                  stops: [0.80, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: design.spacing.md, vertical: design.spacing.xs),
                itemCount: tabNames.length,
                itemBuilder: (context, index) {
                  final tabName = tabNames[index];
                  final isActive = index == activeIndex;

                  return GestureDetector(
                    onTap: () {
                      if (!isActive) {
                        setState(() {
                          _currentQuestionIndex = 0;
                          if (state.sections.length <= 1) {
                            _activeSubjectIndex = index;
                          }
                        });
                        if (state.sections.length > 1) {
                          ref.read(examAttemptProvider.notifier).switchSection(index);
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: design.spacing.sm),
                      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive ? design.colors.primary : design.colors.card,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isActive ? design.colors.primary : design.colors.border,
                        ),
                      ),
                      child: AppText.body(
                        tabName.isEmpty ? 'General' : tabName,
                        color: isActive ? design.colors.onPrimary : design.colors.textPrimary,
                        style: TextStyle(
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isSectionsTabBarExpanded = false),
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
              alignment: Alignment.center,
              child: Icon(
                LucideIcons.chevronUp,
                size: 20,
                color: design.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
