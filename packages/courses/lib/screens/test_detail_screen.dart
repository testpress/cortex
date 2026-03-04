import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../models/test_model.dart';
import '../data/mock_tests.dart';
import '../widgets/test_detail/test_header.dart';
import '../widgets/test_detail/question_palette.dart';
import '../widgets/test_detail/test_result_view.dart';
import '../widgets/test_detail/test_progress_section.dart';
import '../widgets/test_detail/test_question_card.dart';
import '../widgets/test_detail/test_navigation_actions.dart';
import '../widgets/test_detail/test_palette_trigger.dart';

class TestDetailScreen extends ConsumerStatefulWidget {
  final String testId;
  final VoidCallback onClose;

  const TestDetailScreen({
    super.key,
    required this.testId,
    required this.onClose,
  });

  @override
  ConsumerState<TestDetailScreen> createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends ConsumerState<TestDetailScreen> {
  int _currentQuestionIndex = 0;
  final Map<String, TestAttemptAnswer> _answers = {};
  bool _showPalette = false;
  bool _testCompleted = false;
  late int _timeRemaining;
  Timer? _timer;

  // Flash "Saved" indicator
  bool _isSavedVisible = false;
  Timer? _savedTimer;

  // Data
  late final Test _test;
  late final List<TestQuestion> _questions;
  late final Map<String, TestQuestion> _questionsMap;
  late final Map<String, List<String>> _scoringKey;

  @override
  void initState() {
    super.initState();
    _test = MockTestFactory.createMockTest();
    _questions = MockTestFactory.createMockQuestions();
    _questionsMap = {for (var q in _questions) q.id: q};
    _scoringKey = MockTestFactory.createScoringKey();
    _timeRemaining = _test.timeLimitMinutes * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _savedTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        timer.cancel();
        _handleFinishTest();
      }
    });
  }

  void _showSavedIndicator() {
    _savedTimer?.cancel();
    setState(() => _isSavedVisible = true);
    _savedTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isSavedVisible = false);
    });
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _handleFinishTest() {
    _savedTimer?.cancel();
    setState(() {
      _isSavedVisible = false;
      _testCompleted = true;
    });
  }

  void _navigateToQuestion(int index) {
    _savedTimer?.cancel();
    setState(() {
      _isSavedVisible = false;
      _currentQuestionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    if (_testCompleted) {
      return TestResultView(
        correctCount: _calculateCorrectAnswers(),
        totalCount: _questions.length,
        onRetake: _handleRetakeTest,
        onClose: widget.onClose,
      );
    }

    final question = _questions[_currentQuestionIndex];
    final answer = _answers[question.id];
    final answeredCount = _answers.values
        .where((a) => a.selectedOptions.isNotEmpty)
        .length;

    return Container(
      color: design.colors.surface,
      child: Stack(
        children: [
          Column(
            children: [
              TestHeader(
                test: _test,
                timeFormatted: _formatTime(_timeRemaining),
                onExit: widget.onClose,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TestProgressSection(
                        currentQuestionIndex: _currentQuestionIndex,
                        totalQuestions: _questions.length,
                        isSavedVisible: _isSavedVisible,
                      ),
                      TestQuestionCard(
                        question: question,
                        answer: answer,
                        onOptionSelect: _handleOptionSelect,
                      ),
                      TestNavigationActions(
                        isMarked: answer?.isMarked ?? false,
                        canGoPrevious: _currentQuestionIndex > 0,
                        isLastQuestion:
                            _currentQuestionIndex == _questions.length - 1,
                        onToggleMark: _handleToggleMark,
                        onPrevious: () =>
                            _navigateToQuestion(_currentQuestionIndex - 1),
                        onNext: () {
                          if (_currentQuestionIndex < _questions.length - 1) {
                            _navigateToQuestion(_currentQuestionIndex + 1);
                          } else {
                            _handleFinishTest();
                          }
                        },
                      ),
                      SizedBox(height: design.spacing.md),
                      TestPaletteTrigger(
                        answeredCount: answeredCount,
                        totalQuestions: _questions.length,
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
              questions: _questions,
              answers: _answers,
              currentIndex: _currentQuestionIndex,
              onClose: () => setState(() => _showPalette = false),
              onQuestionSelected: (index) {
                _navigateToQuestion(index);
                setState(() => _showPalette = false);
              },
            ),
        ],
      ),
    );
  }

  void _handleOptionSelect(String optionId) {
    final question = _questions[_currentQuestionIndex];
    setState(() {
      final currentAnswer =
          _answers[question.id] ??
          TestAttemptAnswer(questionId: question.id, selectedOptions: []);

      List<String> newSelections;
      if (question.type == QuestionType.multipleSelect) {
        newSelections = List.from(currentAnswer.selectedOptions);
        if (newSelections.contains(optionId)) {
          newSelections.remove(optionId);
        } else {
          newSelections.add(optionId);
        }
      } else {
        newSelections = [optionId];
      }

      _answers[question.id] = currentAnswer.copyWith(
        selectedOptions: newSelections,
      );
    });
    _showSavedIndicator();
  }

  void _handleToggleMark() {
    final question = _questions[_currentQuestionIndex];
    setState(() {
      final currentAnswer =
          _answers[question.id] ??
          TestAttemptAnswer(questionId: question.id, selectedOptions: []);
      _answers[question.id] = currentAnswer.copyWith(
        isMarked: !currentAnswer.isMarked,
      );
    });
  }

  int _calculateCorrectAnswers() {
    int count = 0;
    _answers.forEach((qId, answer) {
      final q = _questionsMap[qId];
      if (q == null) return;

      final userAnswers = List<String>.from(answer.selectedOptions)..sort();
      final correctAnswers = List<String>.from(_scoringKey[qId] ?? [])..sort();

      if (listEquals(userAnswers, correctAnswers)) {
        count++;
      }
    });
    return count;
  }

  void _handleRetakeTest() {
    setState(() {
      _answers.clear();
      _currentQuestionIndex = 0;
      _testCompleted = false;
      _timeRemaining = _test.timeLimitMinutes * 60;
      _startTimer();
    });
  }
}
