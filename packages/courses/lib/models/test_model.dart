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
  final String subject;
  final QuestionType type;
  final List<QuestionOption> options;
  final List<String> correctOptionIds;
  final String? explanation;

  const TestQuestion({
    required this.id,
    required this.number,
    required this.text,
    required this.subject,
    required this.type,
    required this.options,
    this.correctOptionIds = const [],
    this.explanation,
  });
}

class TestAttemptAnswer {
  final String questionId;
  final List<String> selectedOptions;
  final bool hasAttempted;
  final bool isMarked;

  const TestAttemptAnswer({
    required this.questionId,
    required this.selectedOptions,
    this.hasAttempted = false,
    this.isMarked = false,
  });

  TestAttemptAnswer copyWith({
    List<String>? selectedOptions,
    bool? hasAttempted,
    bool? isMarked,
  }) {
    return TestAttemptAnswer(
      questionId: questionId,
      selectedOptions: selectedOptions ?? this.selectedOptions,
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
