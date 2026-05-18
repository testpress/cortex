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

  ExamRepository({required DataSource dataSource}) : _dataSource = dataSource;

  Stream<ExamAttemptState> get stateStream => _stateController.stream;
  Stream<ExamAttemptState> watchState() async* {
    yield _currentState;
    yield* _stateController.stream;
  }
  ExamAttemptState get state => _currentState;

  void reset() {
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
      final attempt = await _dataSource.createAttempt(exam.attemptsUrl);
      await _initializeAttempt(exam, attempt);
    } catch (e) {
      final msg = e is ApiException ? e.message : e.toString();
      _emit(ExamAttemptState(status: ExamAttemptStatus.error, exam: exam, errorMessage: msg));
    }
  }

  Future<void> startCourseLinkedExam(ExamDto exam, String contentAttemptsUrl) async {
    _emit(ExamAttemptState(status: ExamAttemptStatus.loading, exam: exam));
    try {
      final attempt = await _dataSource.createContentAttempt(contentAttemptsUrl);
      await _initializeAttempt(exam, attempt);
    } catch (e) {
      final msg = e is ApiException ? e.message : e.toString();
      _emit(ExamAttemptState(status: ExamAttemptStatus.error, exam: exam, errorMessage: msg));
    }
  }

  Timer? _countdownTimer;

  Future<void> _initializeAttempt(ExamDto exam, AttemptDto attempt) async {
    final List<SectionDto> sections = attempt.sections ?? [];
    List<QuestionDto> questions = [];
    int remainingSeconds = 0;

    if (sections.isNotEmpty) {
      int activeIndex = sections.indexWhere((s) => s.state == 'Running');
      if (activeIndex == -1) activeIndex = 0;
      
      final activeSection = sections[activeIndex];
      questions = await _dataSource.getQuestions(activeSection.questionsUrl);
      remainingSeconds = _parseDuration(activeSection.remainingTime ?? activeSection.duration ?? exam.duration);
      
      final state = ExamAttemptState(
        status: ExamAttemptStatus.inProgress,
        exam: exam,
        attempt: attempt,
        sections: sections,
        currentSectionIndex: activeIndex,
        questions: questions,
        remainingSeconds: remainingSeconds,
      );
      _emit(state);
    } else {
      questions = await _dataSource.getQuestions(attempt.questionsUrl);
      remainingSeconds = _parseDuration(attempt.remainingTime ?? exam.duration);
      
      final state = ExamAttemptState(
        status: ExamAttemptStatus.inProgress,
        exam: exam,
        attempt: attempt,
        questions: questions,
        remainingSeconds: remainingSeconds,
      );
      _emit(state);
    }
    
    _startCountdown();
    _startHeartbeat(attempt.heartbeatUrl);
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
      if (currentSection.state == 'Running' && currentSection.endUrl != null) {
        await _dataSource.endSection(currentSection.endUrl!);
      }

      final nextSection = _currentState.sections[index];
      if (nextSection.state != 'Running' && nextSection.startUrl != null) {
        await _dataSource.startSection(nextSection.startUrl!);
      }

      final questions = await _dataSource.getQuestions(nextSection.questionsUrl);
      final remainingSeconds = _parseDuration(nextSection.remainingTime ?? nextSection.duration ?? _currentState.exam!.duration);
      
      final updatedSections = _currentState.sections.map((s) {
        if (s.id == currentSection.id) {
          return SectionDto(
            id: s.id, name: s.name, state: 'Completed', questionsUrl: s.questionsUrl,
            startUrl: s.startUrl, endUrl: s.endUrl, remainingTime: s.remainingTime,
            duration: s.duration, order: s.order, instructions: s.instructions,
          );
        } else if (s.id == nextSection.id) {
          return SectionDto(
            id: s.id, name: s.name, state: 'Running', questionsUrl: s.questionsUrl,
            startUrl: s.startUrl, endUrl: s.endUrl, remainingTime: s.remainingTime,
            duration: s.duration, order: s.order, instructions: s.instructions,
          );
        }
        return s;
      }).toList();

      _emit(_currentState.copyWith(
        status: ExamAttemptStatus.inProgress,
        sections: updatedSections,
        currentSectionIndex: index,
        questions: questions,
        currentQuestionIndex: 0,
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
    final previousAnswers = Map<String, AnswerDto>.from(_currentState.answers);
    try {
      final newAnswers = Map<String, AnswerDto>.from(_currentState.answers);
      newAnswers[answer.questionId] = answer;
      _emit(_currentState.copyWith(answers: newAnswers));

      await _dataSource.submitAnswer(answerUrl, answer);
    } catch (e, stackTrace) {
      // Rollback on failure
      _emit(_currentState.copyWith(answers: previousAnswers));
      dev.log('Failed to submit answer', name: 'ExamRepository', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> endExam(String endUrl) async {
    _emit(_currentState.copyWith(status: ExamAttemptStatus.submitting));
    try {
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
    stopHeartbeat();
    stopCountdown();
    _stateController.close();
  }
}
