import 'dart:async';
import 'dart:developer' as dev;
import 'package:core/data/data.dart';
import '../models/test_dto.dart';
import '../data/mock_tests.dart';
import 'package:core/data/exceptions/api_exception.dart';

enum ExamAttemptStatus {
  idle,
  loading,
  instructions,
  inProgress,
  submitting,
  completed,
  error,
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
  final int remainingSeconds;
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
    this.remainingSeconds = 0,
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
    int? remainingSeconds,
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
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ExamRepository {
  final DataSource _dataSource;
  Timer? _heartbeatTimer;
  final _stateController = StreamController<ExamAttemptState>.broadcast();
  ExamAttemptState _currentState = const ExamAttemptState();

  final Map<String, Timer> _submitTimers = {};
  final Map<String, AnswerDto> _pendingAnswers = {};
  final Map<String, String> _pendingAnswerUrls = {};
  final Map<String, List<QuestionDto>> _sectionQuestionsCache = {};

  ExamRepository({required DataSource dataSource}) : _dataSource = dataSource;

  Stream<ExamAttemptState> get stateStream => _stateController.stream;
  Stream<ExamAttemptState> watchState() async* {
    yield _currentState;
    yield* _stateController.stream;
  }
  ExamAttemptState get state => _currentState;

  Future<void> _flushPendingAnswers() async {
    final futures = <Future<void>>[];
    
    final timers = Map<String, Timer>.from(_submitTimers);
    final pending = Map<String, AnswerDto>.from(_pendingAnswers);
    final urls = Map<String, String>.from(_pendingAnswerUrls);
    
    for (final timer in timers.values) {
      timer.cancel();
    }
    _submitTimers.clear();
    _pendingAnswers.clear();
    _pendingAnswerUrls.clear();

    for (final entry in pending.entries) {
      final questionId = entry.key;
      final answer = entry.value;
      final url = urls[questionId];
      if (url != null) {
        futures.add(
          _dataSource.submitAnswer(url, answer).catchError((e, stackTrace) {
            dev.log('Failed to flush answer for $questionId', name: 'ExamRepository', error: e, stackTrace: stackTrace);
          }),
        );
      }
    }
    
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  void reset() {
    _flushPendingAnswers().catchError((e) {});
    stopHeartbeat();
    stopCountdown();
    _sectionQuestionsCache.clear();
    _emit(const ExamAttemptState());
  }

  // ─── Real-time Attempt Management ──────────────────────────────────────────

  Future<void> loadExam(String slug) async {
    _emit(const ExamAttemptState(status: ExamAttemptStatus.loading));
    try {
      final exam = await _dataSource.getExam(slug);
      if (exam.hasInstructions) {
        _emit(ExamAttemptState(status: ExamAttemptStatus.instructions, exam: exam));
      } else {
        await startStandaloneExam(exam);
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : e.toString();
      _emit(ExamAttemptState(status: ExamAttemptStatus.error, errorMessage: msg));
    }
  }

  Future<void> startStandaloneExam(ExamDto exam) async {
    _emit(ExamAttemptState(status: ExamAttemptStatus.loading, exam: exam));
    try {
      if (exam.pausedAttemptsCount > 0) {
        final attempts = await _dataSource.getAttempts(exam.attemptsUrl);
        if (attempts.isEmpty) {
          final attempt = await _dataSource.createAttempt(exam.attemptsUrl);
          await _initializeAttempt(exam, attempt);
        } else {
          final runningAttempt = attempts.firstWhere(
            (a) => a.state == 'Running',
            orElse: () => attempts.first,
          );
          AttemptDto attemptToInitialize = runningAttempt;
          if (runningAttempt.startUrl != null) {
            try {
              attemptToInitialize = await _dataSource.startAttempt(
                runningAttempt.startUrl!,
              );
            } catch (e) {
              dev.log(
                'Failed to call startUrl on resumed attempt',
                name: 'ExamRepository',
                error: e,
              );
            }
          }
          await _initializeAttempt(exam, attemptToInitialize, isResume: true);
        }
      } else {
        final attempt = await _dataSource.createAttempt(exam.attemptsUrl);
        await _initializeAttempt(exam, attempt);
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : e.toString();
      _emit(ExamAttemptState(status: ExamAttemptStatus.error, exam: exam, errorMessage: msg));
    }
  }

  Future<void> startCourseLinkedExam(ExamDto exam, String contentAttemptsUrl) async {
    _emit(ExamAttemptState(status: ExamAttemptStatus.loading, exam: exam));
    try {
      if (exam.pausedAttemptsCount > 0) {
        final attempts = await _dataSource.getAttempts(contentAttemptsUrl);
        if (attempts.isEmpty) {
          final attempt = await _dataSource.createAttempt(contentAttemptsUrl);
          await _initializeAttempt(exam, attempt);
        } else {
          final runningAttempt = attempts.firstWhere(
            (a) => a.state == 'Running',
            orElse: () => attempts.first,
          );
          AttemptDto attemptToInitialize = runningAttempt;
          if (runningAttempt.startUrl != null) {
            try {
              attemptToInitialize = await _dataSource.startAttempt(
                runningAttempt.startUrl!,
              );
            } catch (e) {
              dev.log(
                'Failed to call startUrl on resumed course attempt',
                name: 'ExamRepository',
                error: e,
              );
            }
          }
          await _initializeAttempt(exam, attemptToInitialize, isResume: true);
        }
      } else {
        final attempt = await _dataSource.createContentAttempt(
          contentAttemptsUrl,
        );
        await _initializeAttempt(exam, attempt);
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : e.toString();
      _emit(ExamAttemptState(status: ExamAttemptStatus.error, exam: exam, errorMessage: msg));
    }
  }

  Timer? _countdownTimer;

  Future<void> _initializeAttempt(
    ExamDto exam,
    AttemptDto attempt, {
    bool isResume = false,
  }) async {
    AttemptDto currentAttempt = attempt;
    bool heartbeatFetched = false;

    // If we are resuming and sections are missing, fetch the full details via heartbeat first.
    if (isResume && (attempt.sections == null || attempt.sections!.isEmpty) && attempt.heartbeatUrl.isNotEmpty) {
      try {
        currentAttempt = await _dataSource.sendHeartbeat(attempt.heartbeatUrl);
        heartbeatFetched = true;
      } catch (_) {}
    }

    // Kick off background heartbeat query concurrently if remainingTime is null OR it's a resumed attempt
    // and we haven't already fetched the fresh details above.
    final Future<AttemptDto?> heartbeatFuture =
        (!heartbeatFetched &&
         (attempt.remainingTime == null || isResume) &&
         attempt.heartbeatUrl.isNotEmpty)
        ? _dataSource
              .sendHeartbeat(attempt.heartbeatUrl)
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
      remainingSeconds = _parseDuration(activeSection.remainingTime ?? activeSection.duration ?? exam.duration);
      
      final String targetQuestionsUrl = currentAttempt.hasSectionalLock 
          ? activeSection.questionsUrl 
          : currentAttempt.questionsUrl;
          
      final Future<List<QuestionDto>> questionsFuture = remainingSeconds > 0
          ? (_sectionQuestionsCache.containsKey(targetQuestionsUrl)
              ? Future.value(_sectionQuestionsCache[targetQuestionsUrl]!)
              : _dataSource.getQuestions(targetQuestionsUrl).then((q) {
                  _sectionQuestionsCache[targetQuestionsUrl] = q;
                  return q;
                }))
          : Future.value(<QuestionDto>[]);

      // Await both operations concurrently
      final List<dynamic> results = await Future.wait([heartbeatFuture, questionsFuture]);
      final AttemptDto heartbeatAttempt = results[0] as AttemptDto? ?? currentAttempt;
      // Merge the heartbeat details while preserving the original attempt's context (like the course-linked endUrl).
      final AttemptDto updatedAttempt = currentAttempt.copyWith(
        state: heartbeatAttempt.state,
        remainingTime: heartbeatAttempt.remainingTime,
        sections: heartbeatAttempt.sections,
        lastViewedQuestionId: heartbeatAttempt.lastViewedQuestionId,
        // Update any other fields that heartbeat might have refreshed, but preserve critical URLs.
        score: heartbeatAttempt.score,
        correctCount: heartbeatAttempt.correctCount,
        incorrectCount: heartbeatAttempt.incorrectCount,
      );
      questions = results[1] as List<QuestionDto>;

      // Resolve the actual synchronized remainingSeconds from heartbeat
      final updatedSections = updatedAttempt.sections ?? [];
      final syncSection = updatedSections.isNotEmpty && activeIndex < updatedSections.length
          ? updatedSections[activeIndex]
          : activeSection;
      remainingSeconds = _parseDuration(syncSection.remainingTime ?? syncSection.duration ?? exam.duration);

      final initialAnswers = Map<String, AnswerDto>.from(_currentState.answers);
      for (final q in questions) {
        if (q.selectedOptionIds.isNotEmpty || (q.shortText != null && q.shortText!.isNotEmpty) || (q.essayText != null && q.essayText!.isNotEmpty)) {
          initialAnswers[q.id] = AnswerDto(
            questionId: q.id,
            selectedOptions: q.selectedOptionIds,
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

      final baseSections = updatedSections.isNotEmpty ? updatedSections : sections;
      final initializedSections = baseSections.asMap().map((idx, s) {
        if (idx == activeIndex) {
          return MapEntry(idx, SectionDto(
            id: s.id,
            name: s.name,
            state: 'Running',
            questionsUrl: s.questionsUrl,
            startUrl: s.startUrl,
            endUrl: s.endUrl,
            remainingTime: s.remainingTime,
            duration: s.duration,
            order: s.order,
            instructions: s.instructions,
            questionsCount: s.questionsCount,
          ));
        }
        return MapEntry(idx, s);
      }).values.toList();

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
      );
      _emit(state);
    } else {
      remainingSeconds = _parseDuration(attempt.remainingTime ?? exam.duration);
      
      final Future<List<QuestionDto>> questionsFuture = remainingSeconds > 0
          ? (_sectionQuestionsCache.containsKey(attempt.questionsUrl)
              ? Future.value(_sectionQuestionsCache[attempt.questionsUrl]!)
              : _dataSource.getQuestions(attempt.questionsUrl).then((q) {
                  _sectionQuestionsCache[attempt.questionsUrl] = q;
                  return q;
                }))
          : Future.value(<QuestionDto>[]);

      // Await both operations concurrently
      final List<dynamic> results = await Future.wait([heartbeatFuture, questionsFuture]);
      final AttemptDto updatedAttempt = results[0] as AttemptDto? ?? attempt;
      questions = results[1] as List<QuestionDto>;

      remainingSeconds = _parseDuration(updatedAttempt.remainingTime ?? exam.duration);

      final initialAnswers = Map<String, AnswerDto>.from(_currentState.answers);
      for (final q in questions) {
        if (q.selectedOptionIds.isNotEmpty) {
          initialAnswers[q.id] = AnswerDto(
            questionId: q.id,
            selectedOptions: q.selectedOptionIds,
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
      );
      _emit(state);
    }
    
    if (remainingSeconds > 0) {
      _startCountdown();
      _startHeartbeat(attempt.heartbeatUrl);
    } else {
      _handleTimeOut();
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentState.remainingSeconds > 0) {
        _emit(_currentState.copyWith(
          remainingSeconds: _currentState.remainingSeconds - 1,
        ));
      } else {
        _handleTimeOut();
      }
    });
  }

  void _handleTimeOut() {
    stopCountdown();
    if (_currentState.sections.isNotEmpty && _currentState.currentSectionIndex < _currentState.sections.length - 1) {
      switchSection(_currentState.currentSectionIndex + 1);
    } else {
      endExam(_currentState.attempt?.endUrl ?? '');
    }
  }

  void stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  Future<void> switchSection(int index) async {
    if (index < 0 || index >= _currentState.sections.length) return;
    
    _emit(_currentState.copyWith(status: ExamAttemptStatus.loading));
    try {
      final currentSection = _currentState.sections[_currentState.currentSectionIndex];
      final nextSection = _currentState.sections[index];

      // Perform all section lifecycle transitions and question loading concurrently
      final List<Future<dynamic>> futures = [];

      if (currentSection.state == 'Running' && currentSection.endUrl != null) {
        futures.add(
          _dataSource.endSection(currentSection.endUrl!).catchError((e, stackTrace) {
            dev.log('Failed to end section on server, proceeding anyway', name: 'ExamRepository', error: e, stackTrace: stackTrace);
            return const SectionDto(id: '', name: '', state: '', questionsUrl: '', order: 0);
          })
        );
      } else {
        futures.add(Future.value(null));
      }

      if (nextSection.state != 'Running' && nextSection.startUrl != null) {
        futures.add(
          _dataSource.startSection(nextSection.startUrl!).catchError((e, stackTrace) {
            dev.log('Failed to start section on server, proceeding anyway', name: 'ExamRepository', error: e, stackTrace: stackTrace);
            return const SectionDto(id: '', name: '', state: '', questionsUrl: '', order: 0);
          })
        );
      } else {
        futures.add(Future.value(null));
      }

      if (_sectionQuestionsCache.containsKey(nextSection.questionsUrl)) {
        futures.add(Future.value(_sectionQuestionsCache[nextSection.questionsUrl]!));
      } else {
        futures.add(
          _dataSource.getQuestions(nextSection.questionsUrl).then((q) {
            _sectionQuestionsCache[nextSection.questionsUrl] = q;
            return q;
          })
        );
      }

      final results = await Future.wait(futures);
      final List<QuestionDto> questions = results[2] as List<QuestionDto>;

      final remainingSeconds = _parseDuration(nextSection.remainingTime ?? nextSection.duration ?? _currentState.exam!.duration);
      
      final updatedSections = _currentState.sections.map((s) {
        if (s.id == currentSection.id) {
          return SectionDto(
            id: s.id, name: s.name, state: 'Completed', questionsUrl: s.questionsUrl,
            startUrl: s.startUrl, endUrl: s.endUrl, remainingTime: s.remainingTime,
            duration: s.duration, order: s.order, instructions: s.instructions,
            questionsCount: s.questionsCount,
          );
        } else if (s.id == nextSection.id) {
          return SectionDto(
            id: s.id, name: s.name, state: 'Running', questionsUrl: s.questionsUrl,
            startUrl: s.startUrl, endUrl: s.endUrl, remainingTime: s.remainingTime,
            duration: s.duration, order: s.order, instructions: s.instructions,
            questionsCount: s.questionsCount,
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

      _emit(_currentState.copyWith(
        status: ExamAttemptStatus.inProgress,
        sections: updatedSections,
        currentSectionIndex: index,
        questions: questions,
        currentQuestionIndex: 0,
        answers: currentAnswers,
        remainingSeconds: remainingSeconds,
      ));
      
      _startCountdown();
    } catch (e) {
      _emit(_currentState.copyWith(
        status: ExamAttemptStatus.error,
        errorMessage: 'Failed to switch section: $e',
      ));
    }
  }

  void _startHeartbeat(String url) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        final attempt = await _dataSource.sendHeartbeat(url);
        if (attempt.remainingTime != null) {
          // Sync timer with server
          _emit(_currentState.copyWith(
            remainingSeconds: _parseDuration(attempt.remainingTime!),
          ));
        }
      } catch (e, stackTrace) {
        dev.log('Heartbeat failure', name: 'ExamRepository', error: e, stackTrace: stackTrace);
      }
    });
  }

  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  Future<void> submitAnswer(String answerUrl, AnswerDto answer) async {
    final questionId = answer.questionId;
    final previousAnswers = Map<String, AnswerDto>.from(_currentState.answers);

    // 1. Optimistic Update (Immediate)
    final newAnswers = Map<String, AnswerDto>.from(_currentState.answers);
    newAnswers[questionId] = answer;
    _emit(_currentState.copyWith(answers: newAnswers));

    // 2. Debounce Network Request
    _submitTimers[questionId]?.cancel();
    _pendingAnswers[questionId] = answer;
    _pendingAnswerUrls[questionId] = answerUrl;

    _submitTimers[questionId] = Timer(const Duration(seconds: 1), () async {
      _submitTimers.remove(questionId);
      final pendingAns = _pendingAnswers.remove(questionId);
      final pendingUrl = _pendingAnswerUrls.remove(questionId);

      if (pendingAns != null && pendingUrl != null) {
        try {
          await _dataSource.submitAnswer(pendingUrl, pendingAns);
        } catch (e, stackTrace) {
          // Rollback on failure
          final currentAnswers = Map<String, AnswerDto>.from(_currentState.answers);
          if (currentAnswers[questionId] == pendingAns) {
            currentAnswers[questionId] = previousAnswers[questionId] ?? AnswerDto(questionId: questionId, selectedOptions: []);
            _emit(_currentState.copyWith(answers: currentAnswers));
          }
          dev.log('Failed to submit answer', name: 'ExamRepository', error: e, stackTrace: stackTrace);
        }
      }
    });
  }

  void updateShortText(String questionId, String answerUrl, String text) {
    final currentAnswer = _currentState.answers[questionId] ??
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
    _pendingAnswerUrls[questionId] = answerUrl;
  }

  void updateEssayText(String questionId, String answerUrl, String text) {
    final currentAnswer = _currentState.answers[questionId] ??
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
    _pendingAnswerUrls[questionId] = answerUrl;
  }

  Future<void> endExam(String endUrl) async {
    _emit(_currentState.copyWith(status: ExamAttemptStatus.submitting));
    try {
      await _flushPendingAnswers();
      if (_currentState.sections.isNotEmpty &&
          _currentState.currentSectionIndex >= 0 &&
          _currentState.currentSectionIndex < _currentState.sections.length) {
        final currentSection = _currentState.sections[_currentState.currentSectionIndex];
        if (currentSection.state == 'Running' && currentSection.endUrl != null) {
          try {
            await _dataSource.endSection(currentSection.endUrl!);
          } catch (_) {}
        }
      }
      final finalAttempt = await _dataSource.endExam(endUrl);
      stopHeartbeat();
      stopCountdown();
      _emit(_currentState.copyWith(
        status: ExamAttemptStatus.completed,
        attempt: finalAttempt,
      ));
    } catch (e) {
      _emit(_currentState.copyWith(
        status: ExamAttemptStatus.error,
        errorMessage: 'Failed to end exam: ${e.toString()}',
      ));
    }
  }

  // ─── Solutions & Analytics ──────────────────────────────────────────────────

  Future<List<ReviewItemDto>> getReviewItems(String reviewUrl) async {
    return _dataSource.getReviewItems(reviewUrl);
  }

  Future<List<SubjectAnalyticsDto>> getSubjectAnalytics(String analyticsUrl) async {
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

  void _emit(ExamAttemptState state) {
    _currentState = state;
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }

  int _parseDuration(String duration) {
    final parts = duration.split(':');
    if (parts.length != 3) return 3600;
    return int.parse(parts[0]) * 3600 + int.parse(parts[1]) * 60 + int.parse(parts[2]);
  }

  void dispose() {
    _flushPendingAnswers().catchError((e) {});
    stopHeartbeat();
    stopCountdown();
    _stateController.close();
  }
}
