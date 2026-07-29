class CustomExamQuestionnaireBlockDto {
  final List<int> subjects;
  final List<String> difficultyLevels;
  final List<String> questionTypes;
  final int numberOfQuestions;

  const CustomExamQuestionnaireBlockDto({
    this.subjects = const [],
    this.difficultyLevels = const [],
    this.questionTypes = const [],
    required this.numberOfQuestions,
  });

  Map<String, dynamic> toJson() {
    return {
      if (subjects.isNotEmpty) 'subjects': subjects,
      if (difficultyLevels.isNotEmpty) 'difficulty_levels': difficultyLevels,
      if (questionTypes.isNotEmpty) 'question_types': questionTypes,
      'no_of_questions': numberOfQuestions,
    };
  }
}

class CustomExamGenerationRequestDto {
  final String courseId;
  final String testMode;
  final List<CustomExamQuestionnaireBlockDto> questionnaires;

  const CustomExamGenerationRequestDto({
    required this.courseId,
    this.testMode = '',
    required this.questionnaires,
  });

  Map<String, dynamic> toJson() {
    return {
      if (testMode.isNotEmpty) 'test_mode': testMode,
      'questionnaires': questionnaires.map((q) => q.toJson()).toList(),
    };
  }
}
