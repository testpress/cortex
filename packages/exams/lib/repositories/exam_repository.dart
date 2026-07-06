import 'dart:async';
import 'dart:developer' as dev;
import 'package:core/data/data.dart';
import '../models/test_dto.dart';
import '../data/mock_tests.dart';

import 'package:flutter/foundation.dart';

enum ExamAttemptStatus {
  idle,
  loading,
  instructions,
  inProgress,
  submitting,
  completed,
  error,
}

class ExamErrorCodes {
  static const String offlineDataNotFound = 'error_offline_data_not_found';
}

class ExamAttemptState {
  final ExamAttemptStatus status;
  final ExamDto? exam;
  final AttemptDto? attempt;
  final List<SectionDto> sections;
  final int currentSectionIndex;
  final List<QuestionDto> questions;
  final int currentQuestionIndex;
  final Map<String, AnswerDto> answers;
  final Set<String> checkedQuestions;
  final Map<String, QuizReviewResultDto> quizReviews;
  final int remainingSeconds;
  final bool isQuizMode;
  final String? errorMessage;

  const ExamAttemptState({
    this.status = ExamAttemptStatus.idle,
    this.exam,
    this.attempt,
    this.sections = const [],
    this.currentSectionIndex = 0,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.checkedQuestions = const {},
    this.quizReviews = const {},
    this.remainingSeconds = 0,
    this.isQuizMode = false,
    this.errorMessage,
  });

  ExamAttemptState copyWith({
    ExamAttemptStatus? status,
    ExamDto? exam,
    AttemptDto? attempt,
    List<SectionDto>? sections,
    int? currentSectionIndex,
    List<QuestionDto>? questions,
    int? currentQuestionIndex,
    Map<String, AnswerDto>? answers,
    Set<String>? checkedQuestions,
    Map<String, QuizReviewResultDto>? quizReviews,
    int? remainingSeconds,
    bool? isQuizMode,
    String? errorMessage,
  }) {
    return ExamAttemptState(
      status: status ?? this.status,
      exam: exam ?? this.exam,
      attempt: attempt ?? this.attempt,
      sections: sections ?? this.sections,
      currentSectionIndex: currentSectionIndex ?? this.currentSectionIndex,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      checkedQuestions: checkedQuestions ?? this.checkedQuestions,
      quizReviews: quizReviews ?? this.quizReviews,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isQuizMode: isQuizMode ?? this.isQuizMode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

abstract class ExamRepository {
  Stream<ExamAttemptState> get stateStream;
  Stream<ExamAttemptState> watchState();
  ExamAttemptState get state;

  void reset();
  Future<List<AttemptDto>> getAttempts(String attemptsUrl);
  Future<void> startStandaloneExam(
    ExamDto exam, {
    bool isQuizMode = false,
    bool isPartial = false,
  });
  Future<void> startCourseLinkedExam(
    ExamDto exam,
    String contentAttemptsUrl, {
    bool isQuizMode = false,
    bool isPartial = false,
  });
  Future<void> stopCountdown();
  void stopHeartbeat();

  Future<void> switchSection(int index);
  Future<void> submitAnswer(String questionId, AnswerDto answer);
  void updateLocalAnswer(String questionId, AnswerDto answer);
  Future<void> checkQuizAnswer(String questionId, AnswerDto answer);
  void updateShortText(String questionId, String text);
  void updateEssayText(String questionId, String text);
  void markQuestionAsChecked(String questionId);
  Future<void> endExam();
  Future<void> pauseExam();

  Future<List<ReviewItemDto>> getReviewItems(String reviewUrl);
  Future<List<SubjectAnalyticsDto>> getSubjectAnalytics(String analyticsUrl);
}

class OnlineExamRepository implements ExamRepository {
  final DataSource _dataSource;
  final Future<AppDatabase> _dbFuture;
  Timer? _heartbeatTimer;
  final _stateController = StreamController<ExamAttemptState>.broadcast();
  ExamAttemptState _currentState = const ExamAttemptState();

  final Map<String, Timer> _submitTimers = {};
  final Map<String, AnswerDto> _pendingAnswers = {};
  final Map<String, List<QuestionDto>> _sectionQuestionsCache = {};

  OnlineExamRepository({
    required DataSource dataSource,
    required Future<AppDatabase> dbFuture,
  }) : _dataSource = dataSource,
       _dbFuture = dbFuture;

  @override
  Future<List<AttemptDto>> getAttempts(String attemptsUrl) async {
    return _dataSource.getAttempts(attemptsUrl);
  }

  @override
  Stream<ExamAttemptState> get stateStream => _stateController.stream;
  @override
  Stream<ExamAttemptState> watchState() async* {
    yield _currentState;
    yield* _stateController.stream;
  }

  @override
  ExamAttemptState get state => _currentState;

  Future<void> _flushPendingAnswers() async {
    final futures = <Future<void>>[];

    final timers = Map<String, Timer>.from(_submitTimers);
    final pending = Map<String, AnswerDto>.from(_pendingAnswers);

    for (final timer in timers.values) {
      timer.cancel();
    }
    _submitTimers.clear();
    _pendingAnswers.clear();

    final attemptId = _currentState.attempt?.id.toString();
    if (attemptId == null) return;

    for (final entry in pending.entries) {
      final questionId = entry.key;
      final answer = entry.value;
      futures.add(
        _dataSource.submitAnswer(attemptId, questionId, answer).catchError((
          e,
          stackTrace,
        ) {
          dev.log(
            'Failed to flush answer for $questionId',
            name: 'ExamRepository',
            error: e,
            stackTrace: stackTrace,
          );
          return null;
        }),
      );
    }

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  @override
  void reset() {
    _flushPendingAnswers().catchError((e) {});
    stopHeartbeat();
    stopCountdown();
    _sectionQuestionsCache.clear();
    _emit(const ExamAttemptState());
  }

  // ─── Real-time Attempt Management ──────────────────────────────────────────

  @override
  Future<void> startStandaloneExam(
    ExamDto exam, {
    bool isQuizMode = false,
    bool isPartial = false,
  }) async {
    _emit(ExamAttemptState(status: ExamAttemptStatus.loading, exam: exam));
    try {
      if (exam.pausedAttemptsCount > 0) {
        final attempts = await _dataSource.getAttempts(exam.attemptsUrl);
        if (attempts.isEmpty) {
          final attempt = await _dataSource.createAttempt(
            exam.attemptsUrl,
            data: (isQuizMode || isPartial)
                ? {
                    if (isQuizMode) 'attempt_type': 1,
                    if (isPartial) 'is_partial': true,
                  }
                : null,
          );
          if (isQuizMode) {
            final db = await _dbFuture;
            await db.setQuizModeAttempt(attempt.id.toString());
          }
          await _initializeAttempt(exam, attempt, isQuizMode: isQuizMode);
        } else {
          final runningAttempt = attempts
              .where((a) => a.state == 'Running')
              .firstOrNull;
          if (runningAttempt != null) {
            await _initializeAttempt(
              exam,
              runningAttempt,
              isResume: true,
              isQuizMode: isQuizMode,
            );
          } else {
            final newAttempt = await _dataSource.createAttempt(
              exam.attemptsUrl,
              data: (isQuizMode || isPartial)
                  ? {
                      if (isQuizMode) 'attempt_type': 1,
                      if (isPartial) 'is_partial': true,
                    }
                  : null,
            );
            if (isQuizMode) {
              final db = await _dbFuture;
              await db.setQuizModeAttempt(newAttempt.id.toString());
            }
            await _initializeAttempt(exam, newAttempt, isQuizMode: isQuizMode);
          }
        }
      } else {
        final attempt = await _dataSource.createAttempt(
          exam.attemptsUrl,
          data: (isQuizMode || isPartial)
              ? {
                  if (isQuizMode) 'attempt_type': 1,
                  if (isPartial) 'is_partial': true,
                }
              : null,
        );
        if (isQuizMode) {
          final db = await _dbFuture;
          await db.setQuizModeAttempt(attempt.id.toString());
        }
        await _initializeAttempt(exam, attempt, isQuizMode: isQuizMode);
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : e.toString();
      _emit(
        ExamAttemptState(
          status: ExamAttemptStatus.error,
          exam: exam,
          errorMessage: msg,
        ),
      );
    }
  }

  @override
  Future<void> startCourseLinkedExam(
    ExamDto exam,
    String contentAttemptsUrl, {
    bool isQuizMode = false,
    bool isPartial = false,
  }) async {
    _emit(ExamAttemptState(status: ExamAttemptStatus.loading, exam: exam));
    try {
      if (exam.pausedAttemptsCount > 0) {
        final attempts = await _dataSource.getAttempts(contentAttemptsUrl);
        if (attempts.isEmpty) {
          final attempt = await _dataSource.createContentAttempt(
            contentAttemptsUrl,
            data: (isQuizMode || isPartial)
                ? {
                    if (isQuizMode) 'attempt_type': 1,
                    if (isPartial) 'is_partial': true,
                  }
                : null,
          );
          if (isQuizMode) {
            final db = await _dbFuture;
            await db.setQuizModeAttempt(attempt.id.toString());
          }
          await _initializeAttempt(exam, attempt, isQuizMode: isQuizMode);
        } else {
          final runningAttempt = attempts
              .where((a) => a.state == 'Running')
              .firstOrNull;
          if (runningAttempt != null) {
            await _initializeAttempt(
              exam,
              runningAttempt,
              isResume: true,
              isQuizMode: isQuizMode,
            );
          } else {
            final newAttempt = await _dataSource.createContentAttempt(
              contentAttemptsUrl,
              data: (isQuizMode || isPartial)
                  ? {
                      if (isQuizMode) 'attempt_type': 1,
                      if (isPartial) 'is_partial': true,
                    }
                  : null,
            );
            if (isQuizMode) {
              final db = await _dbFuture;
              await db.setQuizModeAttempt(newAttempt.id.toString());
            }
            await _initializeAttempt(exam, newAttempt, isQuizMode: isQuizMode);
          }
        }
      } else {
        final attempt = await _dataSource.createContentAttempt(
          contentAttemptsUrl,
          data: (isQuizMode || isPartial)
              ? {
                  if (isQuizMode) 'attempt_type': 1,
                  if (isPartial) 'is_partial': true,
                }
              : null,
        );
        if (isQuizMode) {
          final db = await _dbFuture;
          await db.setQuizModeAttempt(attempt.id.toString());
        }
        await _initializeAttempt(exam, attempt, isQuizMode: isQuizMode);
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : e.toString();
      _emit(
        ExamAttemptState(
          status: ExamAttemptStatus.error,
          exam: exam,
          errorMessage: msg,
        ),
      );
    }
  }

  Timer? _countdownTimer;

  Future<void> _initializeAttempt(
    ExamDto exam,
    AttemptDto attempt, {
    bool isResume = false,
    bool isQuizMode = false,
  }) async {
    AttemptDto currentAttempt = attempt;
    // Short-circuit: skip the DB read if the attempt or caller already tells us it's a quiz.
    // The DB check is only needed as a fallback when the backend drops attempt_type.
    final effectiveQuizMode = isResume
        ? (isQuizMode ||
              attempt.isQuizMode ||
              await _dbFuture.then(
                (db) => db.isQuizModeAttempt(attempt.id.toString()),
              ))
        : isQuizMode;
    if (effectiveQuizMode) {
      final db = await _dbFuture;
      await db.setQuizModeAttempt(attempt.id.toString());
    }
    bool heartbeatFetched = false;

    // If we are resuming and sections are missing, fetch the full details via heartbeat first.
    if (isResume && (attempt.sections == null || attempt.sections!.isEmpty)) {
      try {
        currentAttempt = await _dataSource.sendHeartbeat(attempt.id.toString());
        heartbeatFetched = true;
      } catch (_) {}
    }

    // Kick off background heartbeat query concurrently if remainingTime is null OR it's a resumed attempt
    // and we haven't already fetched the fresh details above.
    final Future<AttemptDto?> heartbeatFuture =
        (!heartbeatFetched && (attempt.remainingTime == null || isResume))
        ? _dataSource
              .sendHeartbeat(attempt.id.toString())
              .then<AttemptDto?>((val) => val)
              .catchError((e) {
                dev.log(
                  'Failed to fetch initial heartbeat remaining time',
                  name: 'ExamRepository',
                  error: e,
                );
                return null;
              })
        : Future.value(null);

    final List<SectionDto> sections = currentAttempt.sections ?? [];
    int remainingSeconds = 0;
    List<QuestionDto> questions = [];

    if (sections.isNotEmpty) {
      int activeIndex = sections.indexWhere((s) => s.state == 'Running');
      if (activeIndex == -1) activeIndex = 0;

      final activeSection = sections[activeIndex];
      remainingSeconds = _parseDuration(
        activeSection.remainingTime ?? activeSection.duration ?? exam.duration,
      );

      final attemptIdStr = currentAttempt.id.toString();

      final Future<List<QuestionDto>> questionsFuture =
          _sectionQuestionsCache.containsKey(attemptIdStr)
          ? Future.value(_sectionQuestionsCache[attemptIdStr]!)
          : _dataSource.getQuestions(attemptIdStr).then((q) {
              _sectionQuestionsCache[attemptIdStr] = q;
              return q;
            });
      // Await both operations concurrently
      final List<dynamic> results = await Future.wait([
        heartbeatFuture,
        questionsFuture,
      ]);
      final AttemptDto heartbeatAttempt =
          results[0] as AttemptDto? ?? currentAttempt;
      // Merge the heartbeat details while preserving the original attempt's context (like the course-linked endUrl).
      final AttemptDto updatedAttempt = currentAttempt.copyWith(
        state: heartbeatAttempt.state,
        remainingTime: heartbeatAttempt.remainingTime,
        sections: heartbeatAttempt.sections,
        lastViewedQuestionId: heartbeatAttempt.lastViewedQuestionId,
        score: heartbeatAttempt.score,
        correctCount: heartbeatAttempt.correctCount,
        incorrectCount: heartbeatAttempt.incorrectCount,
      );
      final allQuestions = List<QuestionDto>.from(
        results[1] as List<QuestionDto>,
      );
      // Local filter: only show questions for the active section if we have sectional locks
      if (updatedAttempt.hasSectionalLock) {
        questions = allQuestions
            .where(
              (q) =>
                  q.sectionId == activeSection.id.toString() ||
                  q.sectionId == activeSection.id,
            )
            .toList();
      } else {
        questions = allQuestions;
      }

      // Resolve the actual synchronized remainingSeconds from heartbeat
      final updatedSections = updatedAttempt.sections ?? [];
      final syncSection =
          updatedSections.isNotEmpty && activeIndex < updatedSections.length
          ? updatedSections[activeIndex]
          : activeSection;
      remainingSeconds = _parseDuration(
        syncSection.remainingTime ?? syncSection.duration ?? exam.duration,
      );

      final initialAnswers = Map<String, AnswerDto>.from(_currentState.answers);
      for (final q in questions) {
        if (q.selectedOptionIds.isNotEmpty ||
            q.isMarked ||
            (q.shortText != null && q.shortText!.isNotEmpty) ||
            (q.essayText != null && q.essayText!.isNotEmpty)) {
          initialAnswers[q.id] = AnswerDto(
            questionId: q.id,
            selectedOptions: q.selectedOptionIds,
            isMarked: q.isMarked,
            shortText: q.shortText,
            essayText: q.essayText,
          );
        }
      }
      int initialQuestionIndex = 0;
      if (updatedAttempt.lastViewedQuestionId != null) {
        final index = questions.indexWhere(
          (q) => q.id == updatedAttempt.lastViewedQuestionId.toString(),
        );
        if (index != -1) {
          initialQuestionIndex = index;
        }
      }

      final baseSections = updatedSections.isNotEmpty
          ? updatedSections
          : sections;
      final initializedSections = baseSections
          .asMap()
          .map((idx, s) {
            if (idx == activeIndex) {
              return MapEntry(
                idx,
                SectionDto(
                  id: s.id,
                  name: s.name,
                  state: 'Running',

                  remainingTime: s.remainingTime,
                  duration: s.duration,
                  order: s.order,
                  instructions: s.instructions,
                  questionsCount: s.questionsCount,
                  infoId: s.infoId,
                ),
              );
            }
            return MapEntry(idx, s);
          })
          .values
          .toList();

      _sortQuestions(questions, initializedSections);

      final state = ExamAttemptState(
        status: ExamAttemptStatus.inProgress,
        exam: exam,
        attempt: updatedAttempt,
        sections: initializedSections,
        currentSectionIndex: activeIndex,
        questions: questions,
        currentQuestionIndex: initialQuestionIndex,
        answers: initialAnswers,
        remainingSeconds: remainingSeconds,
        isQuizMode: effectiveQuizMode,
      );
      _emit(state);
    } else {
      remainingSeconds = _parseDuration(attempt.remainingTime ?? exam.duration);

      final attemptIdStr = attempt.id.toString();
      final Future<List<QuestionDto>> questionsFuture =
          _sectionQuestionsCache.containsKey(attemptIdStr)
          ? Future.value(_sectionQuestionsCache[attemptIdStr]!)
          : _dataSource.getQuestions(attemptIdStr).then((q) {
              _sectionQuestionsCache[attemptIdStr] = q;
              return q;
            });
      // Await both operations concurrently
      final List<dynamic> results = await Future.wait([
        heartbeatFuture,
        questionsFuture,
      ]);
      final AttemptDto updatedAttempt = results[0] as AttemptDto? ?? attempt;
      questions = List<QuestionDto>.from(results[1] as List<QuestionDto>);
      _sortQuestions(questions, updatedAttempt.sections);

      remainingSeconds = _parseDuration(
        updatedAttempt.remainingTime ?? exam.duration,
      );

      final initialAnswers = Map<String, AnswerDto>.from(_currentState.answers);
      for (final q in questions) {
        if (q.selectedOptionIds.isNotEmpty ||
            q.isMarked ||
            (q.shortText != null && q.shortText!.isNotEmpty) ||
            (q.essayText != null && q.essayText!.isNotEmpty)) {
          initialAnswers[q.id] = AnswerDto(
            questionId: q.id,
            selectedOptions: q.selectedOptionIds,
            isMarked: q.isMarked,
            shortText: q.shortText,
            essayText: q.essayText,
          );
        }
      }
      int initialQuestionIndex = 0;
      if (updatedAttempt.lastViewedQuestionId != null) {
        final index = questions.indexWhere(
          (q) => q.id == updatedAttempt.lastViewedQuestionId.toString(),
        );
        if (index != -1) {
          initialQuestionIndex = index;
        }
      }

      final state = ExamAttemptState(
        status: ExamAttemptStatus.inProgress,
        exam: exam,
        attempt: updatedAttempt,
        questions: questions,
        currentQuestionIndex: initialQuestionIndex,
        answers: initialAnswers,
        remainingSeconds: remainingSeconds,
        isQuizMode: isQuizMode || currentAttempt.isQuizMode,
      );
      _emit(state);
    }

    if (effectiveQuizMode) {
      // In Quiz Mode, we do not start countdown or heartbeat, and we don't handle timeout.
    } else if (remainingSeconds > 0) {
      _startCountdown();
      _startHeartbeat(attempt.id.toString());
    } else if (attempt.state == 'Running' || attempt.state == 'running') {
      // Unlimited time exam (remainingSeconds == 0 but attempt is still running)
      _startHeartbeat(attempt.id.toString());
    } else {
      _handleTimeOut();
    }
  }

  void _startCountdown() {
    if (_currentState.isQuizMode) return;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentState.remainingSeconds > 0) {
        _emit(
          _currentState.copyWith(
            remainingSeconds: _currentState.remainingSeconds - 1,
          ),
        );
      } else {
        _handleTimeOut();
      }
    });
  }

  void _handleTimeOut() {
    stopCountdown();
    if (_currentState.sections.isNotEmpty &&
        _currentState.currentSectionIndex < _currentState.sections.length - 1) {
      switchSection(_currentState.currentSectionIndex + 1);
    } else {
      endExam();
    }
  }

  @override
  Future<void> stopCountdown() async {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  @override
  Future<void> switchSection(int index) async {
    if (index < 0 || index >= _currentState.sections.length) return;

    _emit(_currentState.copyWith(status: ExamAttemptStatus.loading));
    try {
      final currentSection =
          _currentState.sections[_currentState.currentSectionIndex];
      final nextSection = _currentState.sections[index];

      // Perform all section lifecycle transitions and question loading concurrently
      final List<Future<dynamic>> futures = [];

      if (currentSection.state == 'Running') {
        futures.add(
          _dataSource
              .endSection(
                _currentState.attempt!.id.toString(),
                currentSection.order.toString(),
              )
              .catchError((e, stackTrace) {
                dev.log(
                  'Failed to end section on server, proceeding anyway',
                  name: 'ExamRepository',
                  error: e,
                  stackTrace: stackTrace,
                );
                return SectionDto(
                  id: currentSection.id,
                  name: currentSection.name,
                  state: 'Completed',

                  order: currentSection.order,
                );
              }),
        );
      } else {
        futures.add(Future.value(null));
      }

      if (nextSection.state != 'Running') {
        futures.add(
          _dataSource
              .startSection(
                _currentState.attempt!.id.toString(),
                nextSection.order.toString(),
              )
              .catchError((e, stackTrace) {
                dev.log(
                  'Failed to start section on server, proceeding anyway',
                  name: 'ExamRepository',
                  error: e,
                  stackTrace: stackTrace,
                );
                return SectionDto(
                  id: nextSection.id,
                  name: nextSection.name,
                  state: 'Running',

                  order: nextSection.order,
                );
              }),
        );
      } else {
        futures.add(Future.value(null));
      }

      await Future.wait(futures);

      final attemptIdStr = _currentState.attempt!.id.toString();
      final allQuestions = _sectionQuestionsCache[attemptIdStr] ?? [];
      final List<QuestionDto> questions = allQuestions
          .where(
            (q) =>
                q.sectionId == nextSection.id.toString() ||
                q.sectionId == nextSection.id,
          )
          .toList();

      final remainingSeconds = _parseDuration(
        nextSection.remainingTime ??
            nextSection.duration ??
            _currentState.exam!.duration,
      );

      final updatedSections = _currentState.sections.map((s) {
        if (s.id == currentSection.id) {
          return SectionDto(
            id: s.id,
            name: s.name,
            state: 'Completed',
            remainingTime: s.remainingTime,
            duration: s.duration,
            order: s.order,
            instructions: s.instructions,
            questionsCount: s.questionsCount,
            infoId: s.infoId,
          );
        } else if (s.id == nextSection.id) {
          return SectionDto(
            id: s.id,
            name: s.name,
            state: 'Running',
            remainingTime: s.remainingTime,
            duration: s.duration,
            order: s.order,
            instructions: s.instructions,
            questionsCount: s.questionsCount,
            infoId: s.infoId,
          );
        }
        return s;
      }).toList();

      final currentAnswers = Map<String, AnswerDto>.from(_currentState.answers);
      for (final q in questions) {
        if (q.selectedOptionIds.isNotEmpty) {
          currentAnswers[q.id] = AnswerDto(
            questionId: q.id,
            selectedOptions: q.selectedOptionIds,
          );
        }
      }

      _emit(
        _currentState.copyWith(
          status: ExamAttemptStatus.inProgress,
          sections: updatedSections,
          currentSectionIndex: index,
          questions: questions,
          currentQuestionIndex: 0,
          answers: currentAnswers,
          remainingSeconds: remainingSeconds,
        ),
      );

      _startCountdown();
    } catch (e) {
      _emit(
        _currentState.copyWith(
          status: ExamAttemptStatus.error,
          errorMessage: 'Failed to switch section: $e',
        ),
      );
    }
  }

  void _startHeartbeat(String url) {
    if (_currentState.isQuizMode) return;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (
      timer,
    ) async {
      try {
        await _dataSource.sendHeartbeat(url);
        // We no longer sync the local timer with the server's heartbeat remaining_time
        // because the V3 API heartbeat endpoint dynamically returns 0:00:00 or static times,
        // which incorrectly overrides our local ticking timer.
      } catch (e, stackTrace) {
        dev.log(
          'Heartbeat failure',
          name: 'ExamRepository',
          error: e,
          stackTrace: stackTrace,
        );
      }
    });
  }

  @override
  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  @override
  Future<void> submitAnswer(String questionId, AnswerDto answer) async {
    if (_currentState.attempt?.id == null) return;

    final updatedAnswers = Map<String, AnswerDto>.from(_currentState.answers);
    final updatedAnswer = AnswerDto(
      questionId: questionId,
      selectedOptions: answer.selectedOptions,
      shortText: answer.shortText,
      essayText: answer.essayText,
      review: answer.review,
      result: answer.result,
    );
    updatedAnswers[questionId] = updatedAnswer;

    _emit(_currentState.copyWith(answers: updatedAnswers));

    // Queue the submission
    _pendingAnswers[questionId] = updatedAnswer;

    // Throttle the actual network request
    _submitTimers[questionId]?.cancel();
    _submitTimers[questionId] = Timer(
      const Duration(milliseconds: 1000),
      () async {
        final attemptId = _currentState.attempt!.id.toString();
        final pendingAns = _pendingAnswers.remove(questionId);

        if (pendingAns != null) {
          try {
            await _dataSource.submitAnswer(attemptId, questionId, pendingAns);
          } catch (e, stackTrace) {
            // Rollback on failure
            final currentAnswers = Map<String, AnswerDto>.from(
              _currentState.answers,
            );
            currentAnswers.remove(questionId);
            _emit(_currentState.copyWith(answers: currentAnswers));
            dev.log(
              'Failed to submit answer',
              name: 'ExamRepository',
              error: e,
              stackTrace: stackTrace,
            );
          }
        }
      },
    );
  }

  @override
  void updateLocalAnswer(String questionId, AnswerDto answer) {
    final newAnswers = Map<String, AnswerDto>.from(_currentState.answers);
    newAnswers[questionId] = answer;
    _emit(_currentState.copyWith(answers: newAnswers));
  }

  @override
  Future<void> checkQuizAnswer(String questionId, AnswerDto answer) async {
    if (_currentState.attempt?.id == null) {
      return;
    }
    final attemptId = _currentState.attempt!.id.toString();

    // Flush any pending network debounce for this question to avoid conflicts
    _submitTimers[questionId]?.cancel();
    _submitTimers.remove(questionId);
    _pendingAnswers.remove(questionId);

    // Update local answer state
    updateLocalAnswer(questionId, answer);

    final question = _currentState.questions.firstWhere(
      (q) => q.id == questionId,
    );
    // ── Instant UI Reaction ──────────────────────────────────────────────────
    final result = listEquals(
      List<String>.from(answer.selectedOptions)..sort(),
      List<String>.from(question.correctOptionIds)..sort(),
    );

    final quizReview = QuizReviewResultDto(
      questionId: questionId,
      selectedAnswers: answer.selectedOptions,
      correctAnswers: question.correctOptionIds,
      result: result,
      review: question.explanation,
      explanationHtml: question.explanation,
    );

    final newQuizReviews = Map<String, QuizReviewResultDto>.from(
      _currentState.quizReviews,
    );
    newQuizReviews[questionId] = quizReview;

    final newChecked = Set<String>.from(_currentState.checkedQuestions)
      ..add(questionId);

    _emit(
      _currentState.copyWith(
        quizReviews: newQuizReviews,
        checkedQuestions: newChecked,
      ),
    );
    // ───────────────────────────────────────────────────────────────────────

    // Fire and forget submission
    _dataSource.submitAnswer(attemptId, questionId, answer).catchError((
      e,
      stackTrace,
    ) {
      dev.log(
        'Background submission failed for $questionId',
        name: 'ExamRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    });
  }

  @override
  void updateShortText(String questionId, String text) {
    final currentAnswer =
        _currentState.answers[questionId] ??
        AnswerDto(questionId: questionId, selectedOptions: []);

    final newAnswer = AnswerDto(
      questionId: questionId,
      selectedOptions: currentAnswer.selectedOptions,
      isMarked: currentAnswer.isMarked,
      shortText: text,
      essayText: currentAnswer.essayText,
    );

    // Update optimistic state only, do not trigger immediate network submission
    final newAnswers = Map<String, AnswerDto>.from(_currentState.answers);
    newAnswers[questionId] = newAnswer;
    _emit(_currentState.copyWith(answers: newAnswers));

    // Keep it in pending so flush handles it on heartbeat or exam end
    _pendingAnswers[questionId] = newAnswer;
  }

  @override
  void updateEssayText(String questionId, String text) {
    final currentAnswer =
        _currentState.answers[questionId] ??
        AnswerDto(questionId: questionId, selectedOptions: []);

    final newAnswer = AnswerDto(
      questionId: questionId,
      selectedOptions: currentAnswer.selectedOptions,
      isMarked: currentAnswer.isMarked,
      shortText: currentAnswer.shortText,
      essayText: text,
    );

    // Update optimistic state only, do not trigger immediate network submission
    final newAnswers = Map<String, AnswerDto>.from(_currentState.answers);
    newAnswers[questionId] = newAnswer;
    _emit(_currentState.copyWith(answers: newAnswers));

    // Keep it in pending so flush handles it on heartbeat or exam end
    _pendingAnswers[questionId] = newAnswer;
  }

  @override
  void markQuestionAsChecked(String questionId) {
    final newChecked = Set<String>.from(_currentState.checkedQuestions)
      ..add(questionId);
    _emit(_currentState.copyWith(checkedQuestions: newChecked));
  }

  @override
  Future<void> endExam() async {
    final attemptId = _currentState.attempt!.id.toString();

    _emit(_currentState.copyWith(status: ExamAttemptStatus.submitting));
    stopCountdown();
    stopHeartbeat();
    await _flushPendingAnswers();

    try {
      if (_currentState.sections.isNotEmpty &&
          _currentState.currentSectionIndex >= 0 &&
          _currentState.currentSectionIndex < _currentState.sections.length) {
        final currentSection =
            _currentState.sections[_currentState.currentSectionIndex];
        if (currentSection.state == 'Running') {
          try {
            await _dataSource.endSection(
              attemptId,
              currentSection.order.toString(),
            );
          } catch (_) {}
        }
      }
      final finalAttempt = await _dataSource.endExam(attemptId);
      stopHeartbeat();
      stopCountdown();
      _emit(
        _currentState.copyWith(
          status: ExamAttemptStatus.completed,
          attempt: finalAttempt,
        ),
      );
    } catch (e) {
      _emit(
        _currentState.copyWith(
          status: ExamAttemptStatus.error,
          errorMessage: 'Failed to end exam: ${e.toString()}',
        ),
      );
    }
  }

  // ─── Solutions & Analytics ──────────────────────────────────────────────────

  @override
  Future<void> pauseExam() async {
    // Online API relies on user dropping off to naturally pause the timer server-side
    stopCountdown();
    stopHeartbeat();
  }

  @override
  Future<List<ReviewItemDto>> getReviewItems(String reviewUrl) async {
    return _dataSource.getReviewItems(reviewUrl);
  }

  @override
  Future<List<SubjectAnalyticsDto>> getSubjectAnalytics(
    String analyticsUrl,
  ) async {
    return _dataSource.getSubjectAnalytics(analyticsUrl);
  }

  // ─── Dashboard / Discovery Support ─────────────────────────────────────────

  /// Placeholder: returns empty exam list.
  Stream<List<CourseDto>> watchExams() => const Stream.empty();

  /// Placeholder: no-op refresh.
  Future<void> refreshExams() async {}

  Future<List<TestDto>> getUpcomingTests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockTests;
  }

  Future<List<TestDto>> getPopularTests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockPopularTests;
  }

  // ─── Internal Helpers ──────────────────────────────────────────────────────

  void _sortQuestions(List<QuestionDto> questions, List<SectionDto>? sections) {
    if (sections == null || sections.isEmpty) {
      questions.sort((a, b) => a.order.compareTo(b.order));
      return;
    }
    final Map<String, int> sectionOrders = {};
    for (final s in sections) {
      sectionOrders[s.id] = s.order;
      if (s.infoId != null) {
        sectionOrders[s.infoId!] = s.order;
      }
    }
    questions.sort((a, b) {
      final aSecOrder = a.sectionId != null ? sectionOrders[a.sectionId] : null;
      final bSecOrder = b.sectionId != null ? sectionOrders[b.sectionId] : null;
      final aVal = aSecOrder ?? 999;
      final bVal = bSecOrder ?? 999;
      if (aVal != bVal) {
        return aVal.compareTo(bVal);
      }
      return a.order.compareTo(b.order);
    });
  }

  void _emit(ExamAttemptState state) {
    _currentState = state;
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }

  int _parseDuration(String duration) {
    final parts = duration.split(':');
    if (parts.length != 3) return 3600;
    return int.parse(parts[0]) * 3600 +
        int.parse(parts[1]) * 60 +
        double.parse(parts[2]).toInt();
  }

  void dispose() {
    _flushPendingAnswers().catchError((e) {});
    stopHeartbeat();
    stopCountdown();
    _stateController.close();
  }
}
