import 'dart:async';
import 'package:core/data/data.dart';
import '../models/test_dto.dart';
import '../data/mock_tests.dart';

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
  final List<QuestionDto> questions;
  final int currentQuestionIndex;
  final Map<String, AnswerDto> answers;
  final int remainingSeconds;
  final String? errorMessage;

  const ExamAttemptState({
    this.status = ExamAttemptStatus.idle,
    this.exam,
    this.attempt,
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
  ExamAttemptState get state => _currentState;

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
      _emit(ExamAttemptState(status: ExamAttemptStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> startStandaloneExam(ExamDto exam) async {
    _emit(ExamAttemptState(status: ExamAttemptStatus.loading, exam: exam));
    try {
      final attempt = await _dataSource.createAttempt(exam.attemptsUrl);
      await _initializeAttempt(exam, attempt);
    } catch (e) {
      _emit(ExamAttemptState(status: ExamAttemptStatus.error, exam: exam, errorMessage: e.toString()));
    }
  }

  Future<void> startCourseLinkedExam(ExamDto exam, String contentAttemptsUrl) async {
    _emit(ExamAttemptState(status: ExamAttemptStatus.loading, exam: exam));
    try {
      final attempt = await _dataSource.createContentAttempt(contentAttemptsUrl);
      await _initializeAttempt(exam, attempt);
    } catch (e) {
      _emit(ExamAttemptState(status: ExamAttemptStatus.error, exam: exam, errorMessage: e.toString()));
    }
  }

  Future<void> _initializeAttempt(ExamDto exam, AttemptDto attempt) async {
    final questions = await _dataSource.getQuestions(attempt.questionsUrl);
    final remainingSeconds = _parseDuration(attempt.remainingTime ?? exam.duration);
    
    final state = ExamAttemptState(
      status: ExamAttemptStatus.inProgress,
      exam: exam,
      attempt: attempt,
      questions: questions,
      remainingSeconds: remainingSeconds,
    );
    
    _emit(state);
    _startHeartbeat(attempt.heartbeatUrl);
  }

  void _startHeartbeat(String url) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        await _dataSource.sendHeartbeat(url);
      } catch (e) {
        // Silently fail heartbeat or retry
      }
    });
  }

  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  Future<void> submitAnswer(String answerUrl, AnswerDto answer) async {
    try {
      await _dataSource.submitAnswer(answerUrl, answer);
    } catch (e) {
      // Handle submission error
    }
  }

  Future<void> endExam(String endUrl) async {
    _emit(_currentState.copyWith(status: ExamAttemptStatus.submitting));
    try {
      final finalAttempt = await _dataSource.endExam(endUrl);
      stopHeartbeat();
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
    _stateController.close();
  }
}
