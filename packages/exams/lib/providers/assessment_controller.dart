import 'dart:async';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/assessment_model.dart';
import '../repositories/exam_repository.dart';
import 'exam_providers.dart';

part 'assessment_controller.g.dart';

/// Immutable UI state for the assessment screen.
class AssessmentState {
  final ExamAttemptStatus status;
  final String title;
  final List<AssessmentQuestion> questions;
  final int currentIndex;
  final Map<String, AssessmentAttemptState> attemptStates;
  final bool isCompleted;
  final String? errorMessage;
  final bool allowRetake;
  final bool disableAttemptResume;

  const AssessmentState({
    required this.status,
    required this.title,
    this.questions = const [],
    this.currentIndex = 0,
    this.attemptStates = const {},
    this.isCompleted = false,
    this.errorMessage,
    this.allowRetake = true,
    this.disableAttemptResume = false,
  });

  AssessmentQuestion? get currentQuestion => questions.isEmpty
      ? null
      : questions[currentIndex.clamp(0, questions.length - 1)];

  AssessmentAttemptState stateFor(String questionId) =>
      attemptStates[questionId] ??
      AssessmentAttemptState(questionId: questionId, selectedOptions: []);

  bool isOptionCorrect(AssessmentQuestion q, String optionId) =>
      q.correctOptionIds.contains(optionId);

  bool isAnswerCorrect(AssessmentQuestion q) {
    final state = stateFor(q.id);
    final selected = List<String>.from(state.selectedOptions)..sort();
    final correct = List<String>.from(q.correctOptionIds)..sort();
    return listEquals(selected, correct);
  }

  int get answeredCount =>
      attemptStates.values.where((s) => s.isAnswered).length;

  int get checkedCount => attemptStates.values.where((s) => s.isChecked).length;

  int get correctCount {
    int count = 0;
    for (final q in questions) {
      final state = stateFor(q.id);
      if (state.isChecked && isAnswerCorrect(q)) count++;
    }
    return count;
  }

  int get scorePercent =>
      questions.isEmpty ? 0 : (correctCount / questions.length * 100).round();

  bool get isLastQuestion =>
      questions.isNotEmpty && currentIndex >= questions.length - 1;

  Assessment get asAssessment => Assessment(
    id: title,
    title: title,
    questionIds: questions.map((q) => q.id).toList(),
  );

  AssessmentState copyWith({
    ExamAttemptStatus? status,
    String? title,
    List<AssessmentQuestion>? questions,
    int? currentIndex,
    Map<String, AssessmentAttemptState>? attemptStates,
    bool? isCompleted,
    String? errorMessage,
    bool? allowRetake,
    bool? disableAttemptResume,
  }) {
    return AssessmentState(
      status: status ?? this.status,
      title: title ?? this.title,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      attemptStates: attemptStates ?? this.attemptStates,
      isCompleted: isCompleted ?? this.isCompleted,
      errorMessage: errorMessage ?? this.errorMessage,
      allowRetake: allowRetake ?? this.allowRetake,
      disableAttemptResume: disableAttemptResume ?? this.disableAttemptResume,
    );
  }
}

/// Parameter class for assessment controller family.
class AssessmentParam {
  final String assessmentId;
  final LessonDto? lesson;

  const AssessmentParam({required this.assessmentId, this.lesson});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentParam &&
          runtimeType == other.runtimeType &&
          assessmentId == other.assessmentId;

  @override
  int get hashCode => assessmentId.hashCode;
}

/// Controller managing business logic, state mutations, and network interactions for assessments.
@riverpod
class AssessmentController extends _$AssessmentController {
  StreamSubscription<ExamAttemptState>? _attemptSubscription;
  bool _hasInitializedIndex = false;
  late AssessmentParam _param;

  @override
  AssessmentState build(AssessmentParam param) {
    _param = param;
    _hasInitializedIndex = false;

    // 1. Listen to repository attempt updates
    final examRepo = ref.read(examRepositoryProvider);
    _attemptSubscription = examRepo.stateStream.listen(_onAttemptStateChanged);

    // 2. Listen to lesson detail updates to start the attempt once URLs are loaded
    ref.listen<AsyncValue<LessonDto?>>(
      lessonDetailProvider(param.assessmentId),
      (prev, next) {
        next.when(
          data: (lesson) {
            if (lesson != null) _onLessonDetailLoaded(lesson);
          },
          loading: () {},
          error: (e, _) {
            state = state.copyWith(
              status: ExamAttemptStatus.error,
              errorMessage: e.toString(),
            );
          },
        );
      },
    );

    ref.onDispose(() {
      _attemptSubscription?.cancel();
      try {
        ref.read(examAttemptProvider.notifier).reset();
      } catch (_) {}
    });

    // 3. Trigger start if lesson is already available
    Future.microtask(() => _startAttemptIfReady());

    return AssessmentState(
      status: ExamAttemptStatus.loading,
      title: param.lesson?.title ?? '',
      allowRetake: param.lesson?.allowRetake ?? true,
      disableAttemptResume: param.lesson?.disableAttemptResume ?? false,
    );
  }

  void _onLessonDetailLoaded(LessonDto? fetchedLesson) {
    if (state.isCompleted || state.status == ExamAttemptStatus.completed) {
      return;
    }
    if (fetchedLesson != null) {
      state = state.copyWith(
        title: fetchedLesson.title,
        allowRetake: fetchedLesson.allowRetake,
      );
      _startAttemptIfReady(fetchedLesson);
    }
  }

  void _startAttemptIfReady([LessonDto? overrideLesson]) {
    if (state.isCompleted || state.status == ExamAttemptStatus.completed) {
      return;
    }
    final attemptState = ref.read(examAttemptProvider);
    final examId = _param.assessmentId;

    if (attemptState.status != ExamAttemptStatus.idle &&
        attemptState.status != ExamAttemptStatus.error &&
        (attemptState.exam?.id == examId ||
            attemptState.exam?.id == _param.lesson?.id.toString())) {
      _syncQuestionsFromAttempt(attemptState);
      return;
    }

    final lessonDetailAsync = ref.read(
      lessonDetailProvider(_param.assessmentId),
    );
    final fetchedLesson =
        overrideLesson ?? lessonDetailAsync.valueOrNull ?? _param.lesson;
    final lesson = fetchedLesson?.mergeWith(_param.lesson) ?? _param.lesson;

    final attemptsUrl =
        lesson?.attemptsUrl ??
        lesson?.exam?.attemptsUrl ??
        ApiEndpoints.lessonAttempts(_param.assessmentId);

    final embeddedExam = lesson?.exam;
    final exam =
        embeddedExam ??
        (lesson != null
            ? ExamDto(
                id: lesson.id.toString(),
                title: lesson.title,
                duration: lesson.duration,
                questionCount: 0,
                attemptsUrl: attemptsUrl,
              )
            : null);

    if (exam != null && attemptsUrl.isNotEmpty) {
      ref
          .read(examAttemptProvider.notifier)
          .startCourseLinkedExam(exam, attemptsUrl, isQuizMode: true);
    } else if (lesson == null && !lessonDetailAsync.isLoading) {
      state = state.copyWith(
        status: ExamAttemptStatus.error,
        errorMessage: lessonDetailAsync.error?.toString(),
      );
    }
  }

  void _onAttemptStateChanged(ExamAttemptState attemptState) {
    _syncQuestionsFromAttempt(attemptState);
  }

  void _syncQuestionsFromAttempt(ExamAttemptState attemptState) {
    if (state.isCompleted) return;
    if (attemptState.status == ExamAttemptStatus.loading) {
      state = state.copyWith(status: ExamAttemptStatus.loading);
      return;
    }

    if (attemptState.status == ExamAttemptStatus.error) {
      state = state.copyWith(
        status: ExamAttemptStatus.error,
        errorMessage: attemptState.errorMessage,
      );
      return;
    }

    if (attemptState.status == ExamAttemptStatus.completed) {
      state = state.copyWith(
        status: ExamAttemptStatus.completed,
        isCompleted: true,
      );
      return;
    }

    if (attemptState.questions.isNotEmpty) {
      final questions = attemptState.questions.map((q) {
        return AssessmentQuestion(
          id: q.id,
          text: q.text,
          type: q.type == 'multipleSelect'
              ? AssessmentQuestionType.multipleSelect
              : AssessmentQuestionType.mcq,
          options: q.options
              .map((o) => AssessmentOption(id: o.id, text: o.text))
              .toList(),
          correctOptionIds: q.correctOptionIds,
          explanation: q.explanation,
        );
      }).toList();

      final Map<String, AssessmentAttemptState> hydratedStates =
          Map<String, AssessmentAttemptState>.from(state.attemptStates);

      for (final q in questions) {
        final answer = attemptState.answers[q.id];
        final isChecked =
            attemptState.checkedQuestions.contains(q.id) ||
            (answer != null && answer.selectedOptions.isNotEmpty);
        if (answer != null || isChecked) {
          final existing = hydratedStates[q.id];
          hydratedStates[q.id] = AssessmentAttemptState(
            questionId: q.id,
            selectedOptions: existing?.selectedOptions.isNotEmpty == true
                ? existing!.selectedOptions
                : (answer?.selectedOptions ?? []),
            isChecked: isChecked || (existing?.isChecked ?? false),
          );
        }
      }

      int newIndex = state.currentIndex;
      if (!_hasInitializedIndex) {
        _hasInitializedIndex = true;
        final lastViewedIdx = attemptState.currentQuestionIndex;
        if (lastViewedIdx >= 0 &&
            lastViewedIdx < questions.length &&
            !(hydratedStates[questions[lastViewedIdx].id]?.isChecked ??
                false)) {
          newIndex = lastViewedIdx;
        } else {
          final firstUnanswered = questions.indexWhere(
            (q) => !(hydratedStates[q.id]?.isChecked ?? false),
          );
          if (firstUnanswered != -1) {
            newIndex = firstUnanswered;
          } else if (lastViewedIdx >= 0 && lastViewedIdx < questions.length) {
            newIndex = lastViewedIdx;
          }
        }
      }

      state = state.copyWith(
        status: ExamAttemptStatus.inProgress,
        title: attemptState.exam?.title ?? state.title,
        questions: questions,
        attemptStates: hydratedStates,
        currentIndex: newIndex,
        disableAttemptResume:
            attemptState.exam?.disableAttemptResume ??
            _param.lesson?.disableAttemptResume ??
            state.disableAttemptResume,
      );
    }
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  void selectOption(String questionId, String optionId) {
    final q = state.questions.firstWhere((item) => item.id == questionId);
    final currentState = state.stateFor(q.id);
    if (currentState.isChecked) return;

    List<String> newSelections;
    if (q.type == AssessmentQuestionType.multipleSelect) {
      newSelections = List.from(currentState.selectedOptions);
      if (newSelections.contains(optionId)) {
        newSelections.remove(optionId);
      } else {
        newSelections.add(optionId);
      }

      final newAttemptStates = Map<String, AssessmentAttemptState>.from(
        state.attemptStates,
      );
      newAttemptStates[q.id] = currentState.copyWith(
        selectedOptions: newSelections,
      );

      state = state.copyWith(attemptStates: newAttemptStates);

      ref
          .read(examAttemptProvider.notifier)
          .updateLocalAnswer(
            q.id,
            AnswerDto(questionId: q.id, selectedOptions: newSelections),
          );
    } else {
      newSelections = [optionId];

      final newAttemptStates = Map<String, AssessmentAttemptState>.from(
        state.attemptStates,
      );
      newAttemptStates[q.id] = currentState.copyWith(
        selectedOptions: newSelections,
        isChecked: true,
      );

      state = state.copyWith(attemptStates: newAttemptStates);

      ref
          .read(examAttemptProvider.notifier)
          .checkQuizAnswer(
            q.id,
            AnswerDto(questionId: q.id, selectedOptions: newSelections),
          );
      ref.read(examAttemptProvider.notifier).markQuestionAsChecked(q.id);
    }
  }

  Future<void> checkAnswer(String questionId) async {
    final currentState = state.stateFor(questionId);
    final newAttemptStates = Map<String, AssessmentAttemptState>.from(
      state.attemptStates,
    );
    newAttemptStates[questionId] = currentState.copyWith(isChecked: true);

    state = state.copyWith(attemptStates: newAttemptStates);

    await ref
        .read(examAttemptProvider.notifier)
        .checkQuizAnswer(
          questionId,
          AnswerDto(
            questionId: questionId,
            selectedOptions: currentState.selectedOptions,
          ),
        );
    ref.read(examAttemptProvider.notifier).markQuestionAsChecked(questionId);
  }

  void tryAgain(String questionId) {
    final newAttemptStates = Map<String, AssessmentAttemptState>.from(
      state.attemptStates,
    );
    newAttemptStates.remove(questionId);
    state = state.copyWith(attemptStates: newAttemptStates);
  }

  Future<void> next() async {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    } else {
      state = state.copyWith(
        isCompleted: true,
        status: ExamAttemptStatus.completed,
      );
      await endExam();
    }
  }

  void retake() {
    state = state.copyWith(
      currentIndex: 0,
      attemptStates: {},
      isCompleted: false,
      status: ExamAttemptStatus.loading,
    );
    ref.read(examAttemptProvider.notifier).reset();
    ref.invalidate(lessonDetailProvider(_param.assessmentId));
    ref.invalidate(
      examAttemptsProvider(ApiEndpoints.lessonAttempts(_param.assessmentId)),
    );
    _startAttemptIfReady();
  }

  Future<void> pauseExam() async {
    await ref.read(examAttemptProvider.notifier).pauseExam();
    ref.read(examAttemptProvider.notifier).reset();
    ref.invalidate(lessonDetailProvider(_param.assessmentId));
    ref.invalidate(
      examAttemptsProvider(ApiEndpoints.lessonAttempts(_param.assessmentId)),
    );
  }

  Future<void> endExam() async {
    state = state.copyWith(
      isCompleted: true,
      status: ExamAttemptStatus.completed,
    );
    await ref.read(examAttemptProvider.notifier).endExam();
    ref.invalidate(lessonDetailProvider(_param.assessmentId));
    ref.invalidate(
      examAttemptsProvider(ApiEndpoints.lessonAttempts(_param.assessmentId)),
    );
  }

  void retry() {
    state = state.copyWith(status: ExamAttemptStatus.loading);
    ref.invalidate(lessonDetailProvider(_param.assessmentId));
    _startAttemptIfReady();
  }
}
