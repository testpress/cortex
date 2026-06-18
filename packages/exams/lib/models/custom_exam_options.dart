// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

enum PracticeScope { fullCourse, selectCourse }

enum QuestionSource { previousYear, boardPapers, important }

enum DifficultyLevel { easy, medium, hard, mixed }

enum AttemptMode { quiz, test }

// ---------------------------------------------------------------------------
// Config model (passed to the caller on confirm)
// ---------------------------------------------------------------------------

class CustomExamOptionsConfig {
  final String? courseId;
  final String? courseName;
  final bool isFullCourse;
  final List<String> selectedLessonIds;
  final String questionSource;
  final int questionCount;
  final String difficulty;
  final bool isQuizMode;

  const CustomExamOptionsConfig({
    required this.courseId,
    required this.courseName,
    required this.isFullCourse,
    required this.selectedLessonIds,
    required this.questionSource,
    required this.questionCount,
    required this.difficulty,
    required this.isQuizMode,
  });
}
