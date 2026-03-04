// No unused imports

enum QuestionType { mcq, multipleSelect, trueFalse }

class QuestionOption {
  final String id;
  final String text;

  const QuestionOption({required this.id, required this.text});
}

class TestQuestion {
  final String id;
  final int number;
  final String text;
  final QuestionType type;
  final List<QuestionOption> options;
  final List<String> correctAnswers;
  final String explanation;

  const TestQuestion({
    required this.id,
    required this.number,
    required this.text,
    required this.type,
    required this.options,
    required this.correctAnswers,
    required this.explanation,
  });
}

class TestAttemptAnswer {
  final String questionId;
  final List<String> selectedOptions;
  final bool isCorrect;
  final bool hasAttempted;
  final bool isMarked;

  const TestAttemptAnswer({
    required this.questionId,
    required this.selectedOptions,
    required this.isCorrect,
    this.hasAttempted = false,
    this.isMarked = false,
  });

  TestAttemptAnswer copyWith({
    List<String>? selectedOptions,
    bool? isCorrect,
    bool? hasAttempted,
    bool? isMarked,
  }) {
    return TestAttemptAnswer(
      questionId: questionId,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      isCorrect: isCorrect ?? this.isCorrect,
      hasAttempted: hasAttempted ?? this.hasAttempted,
      isMarked: isMarked ?? this.isMarked,
    );
  }
}

class Test {
  final String id;
  final String title;
  final String subject;
  final String description;
  final int totalQuestions;
  final int timeLimitMinutes;

  const Test({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.totalQuestions,
    required this.timeLimitMinutes,
  });
}
