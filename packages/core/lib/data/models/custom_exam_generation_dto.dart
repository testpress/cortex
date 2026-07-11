class CustomExamGenerationRequestDto {
  final String courseId;
  final List<String> subjects;
  final List<String> difficultyLevels;
  final List<String> questionTypes;
  final String testMode;
  final int numberOfQuestions;

  const CustomExamGenerationRequestDto({
    required this.courseId,
    this.subjects = const [],
    this.difficultyLevels = const [],
    this.questionTypes = const [],
    this.testMode = '',
    required this.numberOfQuestions,
  });

  Map<String, dynamic> toJson() {
    return {
      if (testMode.isNotEmpty) 'test_mode': testMode,
      'questionnaire': {
        if (subjects.isNotEmpty) 'subjects': subjects,
        if (difficultyLevels.isNotEmpty) 'difficulty_levels': difficultyLevels,
        if (questionTypes.isNotEmpty) 'question_types': questionTypes,
        'no_of_questions': numberOfQuestions,
      },
    };
  }
}
