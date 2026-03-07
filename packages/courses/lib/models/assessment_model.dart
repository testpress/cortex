class Assessment {
  final String id;
  final String title;
  final String? description;
  final List<String> questionIds;

  const Assessment({
    required this.id,
    required this.title,
    this.description,
    required this.questionIds,
  });
}

enum AssessmentQuestionType { mcq, multipleSelect }

class AssessmentQuestion {
  final String id;
  final String text;
  final AssessmentQuestionType type;
  final List<AssessmentOption> options;
  final List<String> correctOptionIds;
  final String? explanation;

  const AssessmentQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.correctOptionIds,
    this.explanation,
  });
}

class AssessmentOption {
  final String id;
  final String text;

  const AssessmentOption({required this.id, required this.text});
}

class AssessmentAttemptState {
  final String questionId;
  final List<String> selectedOptions;
  final bool isChecked;

  const AssessmentAttemptState({
    required this.questionId,
    required this.selectedOptions,
    this.isChecked = false,
  });

  bool get isAnswered => selectedOptions.isNotEmpty;

  AssessmentAttemptState copyWith({
    List<String>? selectedOptions,
    bool? isChecked,
  }) {
    return AssessmentAttemptState(
      questionId: questionId,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
