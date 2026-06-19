import 'dart:async';
import 'dart:convert';
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
import '../widgets/test_detail/quiz_result_view.dart';
import '../widgets/test_detail/test_progress_section.dart';
import '../widgets/test_detail/test_question_card.dart';
import '../widgets/test_detail/submit_confirmation_dialog.dart';
import '../widgets/test_detail/pause_confirmation_dialog.dart';
import '../widgets/test_detail/exam_instructions_view.dart';
import '../widgets/test_detail/sections_tab_bar.dart';

class TestDetailScreen extends ConsumerStatefulWidget {
  final String testId;
  final LessonDto? lesson;
  final bool isQuizMode;
  final VoidCallback onClose;

  const TestDetailScreen({
    super.key,
    required this.testId,
    this.lesson,
    this.isQuizMode = false,
    required this.onClose,
  });

  @override
  ConsumerState<TestDetailScreen> createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends ConsumerState<TestDetailScreen> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  int _activeSubjectIndex = 0;
  bool _showPalette = false;
  bool _showSubmitConfirmation = false;
  bool _showPauseConfirmation = false;

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

    if (status != ExamAttemptStatus.idle &&
        status != ExamAttemptStatus.error &&
        state.exam?.id == widget.testId) {
      return;
    }

    if (state.exam != null && state.exam?.id != widget.testId) {
      ref.read(examAttemptProvider.notifier).reset();
      state = ref.read(examAttemptProvider);
    }

    if (status == ExamAttemptStatus.idle ||
        (status == ExamAttemptStatus.loading && state.exam == null)) {
      final lessonDetailAsync = ref.read(lessonDetailProvider(widget.testId));
      final fetchedLesson = lessonDetailAsync.valueOrNull?.toDto();
      final lesson = widget.lesson?.mergeWith(fetchedLesson) ?? fetchedLesson;

      final attemptsUrl =
          widget.lesson?.attemptsUrl ?? fetchedLesson?.attemptsUrl;
      final slug = widget.lesson?.slug ?? fetchedLesson?.slug;

      final cachedExam = slug != null
          ? ref.read(examDetailProvider(slug)).valueOrNull
          : null;

      if (lesson != null && attemptsUrl != null && attemptsUrl.isNotEmpty) {
        ref
            .read(examAttemptProvider.notifier)
            .startCourseLinkedExam(
              ExamDto(
                id: lesson.id,
                title: lesson.title,
                duration: cachedExam?.duration ?? lesson.duration,
                questionCount: 0,
                attemptsUrl: attemptsUrl,
                markPerQuestion: cachedExam?.markPerQuestion,
                negativeMarks: cachedExam?.negativeMarks,
                pausedAttemptsCount: lesson.pausedAttemptsCount > 0
                    ? lesson.pausedAttemptsCount
                    : (cachedExam?.pausedAttemptsCount ?? 0),
                disableAttemptResume:
                    lesson.disableAttemptResume ||
                    (cachedExam?.disableAttemptResume ?? false),
                allowRetake:
                    lesson.allowRetake && (cachedExam?.allowRetake ?? true),
                maxRetakes: lesson.maxRetakes != -1
                    ? lesson.maxRetakes
                    : (cachedExam?.maxRetakes ?? -1),
              ),
              attemptsUrl,
              isQuizMode: widget.isQuizMode,
            );
      } else if (slug != null && slug.isNotEmpty) {
        ref
            .read(examAttemptProvider.notifier)
            .loadExam(slug, isQuizMode: widget.isQuizMode);
      } else if (widget.lesson == null &&
          !lessonDetailAsync.isLoading &&
          lessonDetailAsync.value == null) {
        ref
            .read(examAttemptProvider.notifier)
            .loadExam(widget.testId, isQuizMode: widget.isQuizMode);
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

    ref.listen<AsyncValue<Lesson?>>(lessonDetailProvider(widget.testId), (
      previous,
      next,
    ) {
      next.whenData((lesson) {
        if (lesson != null) {
          _initializeExam();
        }
      });
    });

    ref.listen<ExamAttemptState>(examAttemptProvider, (previous, next) {
      final slug = widget.lesson?.slug ?? lessonDetailAsync.valueOrNull?.slug;

      if (previous?.status != ExamAttemptStatus.inProgress &&
          next.status == ExamAttemptStatus.inProgress) {
        if (slug != null && slug.isNotEmpty) {
          ref
              .read(examDetailProvider(slug).notifier)
              .setPausedAttemptsCount(slug, 1);
        }

        // Just loaded the exam (or resumed it), jump to the initial question index
        setState(() {
          _currentQuestionIndex = next.currentQuestionIndex;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.jumpToPage(next.currentQuestionIndex);
          }
        });
      } else if (previous != null &&
          previous.status == ExamAttemptStatus.inProgress &&
          previous.currentSectionIndex != next.currentSectionIndex) {
        // User changed sections, reset to 0
        setState(() {
          _currentQuestionIndex = 0;
        });
        if (_pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      } else if (previous?.status != ExamAttemptStatus.completed &&
          next.status == ExamAttemptStatus.completed) {
        if (slug != null && slug.isNotEmpty) {
          ref
              .read(examDetailProvider(slug).notifier)
              .setPausedAttemptsCount(slug, 0);
        }
      }
    });

    if (state.status == ExamAttemptStatus.idle ||
        state.status == ExamAttemptStatus.loading) {
      return lessonDetailAsync.when(
        data: (lesson) => Container(
          color: design.colors.surface,
          child: const Center(child: AppLoadingIndicator()),
        ),
        loading: () => Container(
          color: design.colors.surface,
          child: const Center(child: AppLoadingIndicator()),
        ),
        error: (err, stack) => Container(
          color: design.colors.surface,
          child: Center(child: AppText.body('Error loading lesson: $err')),
        ),
      );
    }

    if (state.status == ExamAttemptStatus.submitting) {
      return Container(
        color: design.colors.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLoadingIndicator(),
              SizedBox(height: design.spacing.md),
              AppText.body(
                'Submitting test...',
                color: design.colors.textSecondary,
              ),
            ],
          ),
        ),
      );
    }

    if (state.status == ExamAttemptStatus.instructions) {
      return ExamInstructionsView(
        exam: state.exam,
        onClose: widget.onClose,
        onStartExam: () {
          ref
              .read(examAttemptProvider.notifier)
              .startStandaloneExam(state.exam!, isQuizMode: widget.isQuizMode);
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
              Icon(
                LucideIcons.alertCircle,
                size: 48,
                color: design.colors.accent5,
              ),
              SizedBox(height: design.spacing.lg),
              AppText.title(
                'Oops! Cannot start exam',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: design.spacing.sm),
              AppText.body(
                state.errorMessage ?? 'An unknown error occurred.',
                textAlign: TextAlign.center,
                color: design.colors.textSecondary,
              ),
              SizedBox(height: design.spacing.xl),
              AppButton(label: 'Go Back', onPressed: () => context.pop()),
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

    final bool useSections =
        state.sections.length > 1 && state.attempt?.hasSectionalLock == true;
    final bool useFlexibleSections =
        state.sections.length > 1 && state.attempt?.hasSectionalLock == false;

    // --- Parse and Group Questions for Flexible Sections ---
    List<QuestionDto> allQuestions = List.of(state.questions);
    List<SectionDto> localSections = List.of(state.sections);

    if (useFlexibleSections && allQuestions.isNotEmpty) {
      final sectionGroups = <String, List<QuestionDto>>{};
      for (final q in state.questions) {
        final secName = q.sectionName ?? 'General';
        sectionGroups.putIfAbsent(secName, () => []).add(q);
      }

      allQuestions = [];
      localSections = [];
      for (final entry in sectionGroups.entries) {
        allQuestions.addAll(entry.value);
        localSections.add(
          SectionDto(
            id: '',
            name: entry.key,
            state: 'Not Started',
            questionsUrl: '',
            order: localSections.length,
            questionsCount: entry.value.length,
          ),
        );
      }
    }

    if (allQuestions.isEmpty) {
      return Container(
        color: design.colors.surface,
        child: Center(child: AppText.body('No questions found.')),
      );
    }

    final safeIndex = _currentQuestionIndex < allQuestions.length
        ? _currentQuestionIndex
        : 0;
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
    if (useSections) {
      for (int i = 0; i < state.currentSectionIndex; i++) {
        if (i < localSections.length) {
          globalOffset += localSections[i].questionsCount ?? 0;
        }
      }
    }
    final globalCurrentIndex = globalOffset + safeIndex;

    final globalTotalCount =
        state.attempt?.totalQuestions ??
        localSections.fold<int>(0, (sum, s) => sum + (s.questionsCount ?? 0));
    final displayTotalCount = globalTotalCount > 0
        ? globalTotalCount
        : allQuestions.length;

    // Determine whether there are more tabs to navigate to after this one.
    final hasNextSection =
        useSections && state.currentSectionIndex < localSections.length - 1;

    // --- Compute Tabs & Active Index ---
    final List<String> tabNames = [];
    int activeTabIndex = 0;

    if (useSections || useFlexibleSections) {
      tabNames.addAll(localSections.map((s) => s.name));

      if (useSections) {
        activeTabIndex = state.currentSectionIndex;
      } else {
        // Flexible sections: calculate which section we are in based on safeIndex
        int offset = 0;
        for (int i = 0; i < localSections.length; i++) {
          offset += localSections[i].questionsCount ?? 0;
          if (safeIndex < offset) {
            activeTabIndex = i;
            break;
          }
        }
      }
    } else {
      if (subjects.length > 1) {
        tabNames.addAll(subjects);
      }
      activeTabIndex = currentSubjectIndex != -1
          ? currentSubjectIndex
          : _activeSubjectIndex;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() => _showPauseConfirmation = true);
      },
      child: Container(
        color: design.colors.surface,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    border: Border(
                      bottom: BorderSide(color: design.colors.border, width: 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TestHeader(
                        exam: state.exam!,
                        timeFormatted: _formatTime(state.remainingSeconds),
                        isQuizMode: state.isQuizMode,
                        onExit: () =>
                            setState(() => _showPauseConfirmation = true),
                      ),
                      if (!state.isQuizMode)
                        SectionsTabBar(
                          tabNames: tabNames,
                          activeIndex: activeTabIndex,
                          onTabSelected: (index) {
                            if (useSections) {
                              ref
                                  .read(examAttemptProvider.notifier)
                                  .switchSection(index);
                            } else if (useFlexibleSections) {
                              // Jump to the first question of the selected flexible section
                              int targetIndex = 0;
                              for (int i = 0; i < index; i++) {
                                targetIndex +=
                                    localSections[i].questionsCount ?? 0;
                              }
                              if (targetIndex < allQuestions.length) {
                                _pageController.jumpToPage(targetIndex);
                              }
                            } else {
                              // Jump to the first question of this subject
                              final targetSubject = subjects[index];
                              final targetIndex = allQuestions.indexWhere(
                                (q) => q.subject == targetSubject,
                              );
                              if (targetIndex != -1) {
                                _pageController.jumpToPage(targetIndex);
                              }
                            }
                          },
                        ),
                    ],
                  ),
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
                              onPaletteTap: () =>
                                  setState(() => _showPalette = true),
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
                                      .switchSection(
                                        state.currentSectionIndex + 1,
                                      );
                                } else {
                                  setState(
                                    () => _showSubmitConfirmation = true,
                                  );
                                }
                              },
                              onOptionSelect: (message) {
                                if (state.checkedQuestions.contains(q.id)) {
                                  return;
                                }
                                _handleHtmlMessage(state, q, message);
                              },
                              isQuizMode: state.isQuizMode,
                              isQuizChecked: state.checkedQuestions.contains(
                                q.id,
                              ),
                              quizReview: state.quizReviews[q.id],
                              onCheck: () async {
                                if (a != null) {
                                  try {
                                    await ref
                                        .read(examAttemptProvider.notifier)
                                        .checkQuizAnswer(q.answerUrl, a);
                                  } catch (e) {
                                    if (context.mounted) {
                                      AppToast.show(
                                        context,
                                        message:
                                            "Failed to check answer. Please try again.",
                                        isError: true,
                                      );
                                    }
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height:
                            MediaQuery.of(context).padding.bottom +
                            design.spacing.md,
                      ),
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
                onCancel: () => setState(() => _showSubmitConfirmation = false),
                onSubmit: () {
                  setState(() => _showSubmitConfirmation = false);
                  ref
                      .read(examAttemptProvider.notifier)
                      .endExam(state.attempt!.endUrl);
                },
              ),
            if (_showPauseConfirmation)
              PauseConfirmationDialog(
                disablePause:
                    state.exam?.disableAttemptResume ??
                    widget.lesson?.disableAttemptResume ??
                    false,
                onCancel: () => setState(() => _showPauseConfirmation = false),
                onPause: () {
                  setState(() => _showPauseConfirmation = false);
                  ref.read(examAttemptProvider.notifier).reset();
                  widget.onClose();
                },
                onEnd: () {
                  setState(() => _showPauseConfirmation = false);
                  ref
                      .read(examAttemptProvider.notifier)
                      .endExam(state.attempt!.endUrl);
                },
              ),
            if (state.status == ExamAttemptStatus.completed)
              state.isQuizMode
                  ? QuizResultView(
                      score: state.attempt?.score,
                      allowRetake:
                          widget.lesson?.allowRetake != false &&
                          (state.exam?.allowRetake ?? true),
                      onRetake: () {
                        ref.read(examAttemptProvider.notifier).reset();
                        setState(() {
                          _currentQuestionIndex = 0;
                          _showPalette = false;
                          _showSubmitConfirmation = false;
                          _showPauseConfirmation = false;
                        });
                        final lesson = widget.lesson;
                        if (lesson != null && lesson.attemptsUrl != null) {
                          ref
                              .read(examAttemptProvider.notifier)
                              .startCourseLinkedExam(
                                state.exam!,
                                lesson.attemptsUrl!,
                                isQuizMode: true,
                              );
                        } else {
                          ref
                              .read(examAttemptProvider.notifier)
                              .startStandaloneExam(
                                state.exam!,
                                isQuizMode: true,
                              );
                        }
                      },
                      onClose: widget.onClose,
                    )
                  : TestResultView(
                      score: state.attempt?.score,
                      onReview: () => _openAnalytics(state),
                      onClose: widget.onClose,
                    ),
          ],
        ),
      ),
    );
  }

  void _handleHtmlMessage(
    ExamAttemptState state,
    QuestionDto question,
    String message,
  ) {
    try {
      final data = jsonDecode(message);
      if (data is Map<String, dynamic>) {
        if (data['type'] == 'optionSelect') {
          _handleOptionSelect(state, question, data['id'].toString());
          return;
        } else if (data['type'] == 'inputChange') {
          _handleInputChange(state, question, data['value'].toString());
          return;
        }
      }
    } catch (_) {}
    _handleOptionSelect(state, question, message);
  }

  void _handleInputChange(
    ExamAttemptState state,
    QuestionDto question,
    String value,
  ) {
    if (question.type == 'essay') {
      ref
          .read(examAttemptProvider.notifier)
          .updateEssayText(question.id, question.answerUrl, value);
    } else {
      ref
          .read(examAttemptProvider.notifier)
          .updateShortText(question.id, question.answerUrl, value);
    }
    // Don't show the saved indicator for every keystroke since it doesn't trigger immediate network submission
  }

  void _handleOptionSelect(
    ExamAttemptState state,
    QuestionDto question,
    String optionId,
  ) {
    final currentAnswer =
        state.answers[question.id] ??
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
    if (state.isQuizMode) {
      ref
          .read(examAttemptProvider.notifier)
          .updateLocalAnswer(question.id, newAnswer);
    } else {
      ref
          .read(examAttemptProvider.notifier)
          .submitAnswer(question.answerUrl, newAnswer);
      _showSavedIndicator();
    }
  }

  void _handleToggleMark(ExamAttemptState state, QuestionDto question) {
    final currentAnswer =
        state.answers[question.id] ??
        AnswerDto(questionId: question.id, selectedOptions: []);

    final newAnswer = AnswerDto(
      questionId: question.id,
      selectedOptions: currentAnswer.selectedOptions,
      isMarked: !currentAnswer.isMarked,
    );

    ref
        .read(examAttemptProvider.notifier)
        .submitAnswer(question.answerUrl, newAnswer);
  }

  void _openAnalytics(ExamAttemptState state) {
    context.push(
      '/exams/test/${state.exam!.id}/review-analytics',
      extra: ReviewRoutePayload(
        assessmentTitle: state.exam!.title,
        questions: state.questions,
        attemptStates: state.answers,
        attempt: state.attempt,
        exam: state.exam,
      ),
    );
  }
}
