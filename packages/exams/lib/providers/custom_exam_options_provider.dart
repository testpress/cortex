import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../models/custom_exam_options.dart';

part 'custom_exam_options_provider.g.dart';

class CustomExamOptionsState {
  final String? courseId;
  final String? courseName;
  final PracticeScope scope;

  final QuestionSource questionSource;
  final int questionCount;
  final DifficultyLevel difficulty;
  final AttemptMode attemptMode;

  const CustomExamOptionsState({
    this.courseId,
    this.courseName,
    this.scope = PracticeScope.fullCourse,
    this.questionSource = QuestionSource.previousYear,
    this.questionCount = 15,
    this.difficulty = DifficultyLevel.mixed,
    this.attemptMode = AttemptMode.quiz,
  });

  CustomExamOptionsState copyWith({
    String? courseId,
    String? courseName,
    PracticeScope? scope,

    QuestionSource? questionSource,
    int? questionCount,
    DifficultyLevel? difficulty,
    AttemptMode? attemptMode,
  }) {
    return CustomExamOptionsState(
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      scope: scope ?? this.scope,

      questionSource: questionSource ?? this.questionSource,
      questionCount: questionCount ?? this.questionCount,
      difficulty: difficulty ?? this.difficulty,
      attemptMode: attemptMode ?? this.attemptMode,
    );
  }

  bool get canCreate {
    if (scope == PracticeScope.selectCourse && courseId == null) {
      return false;
    }
    return true;
  }
}

@riverpod
class CustomExamOptionsNotifier extends _$CustomExamOptionsNotifier {
  @override
  CustomExamOptionsState build() {
    return const CustomExamOptionsState();
  }

  void setCourse(CourseDto course) {
    state = state.copyWith(
      courseId: course.id,
      courseName: course.title,
      scope: PracticeScope.selectCourse,
    );
  }

  void setScope(PracticeScope scope) {
    if (scope == PracticeScope.fullCourse) {
      state = CustomExamOptionsState(
        scope: scope,
        questionSource: state.questionSource,
        questionCount: state.questionCount,
        difficulty: state.difficulty,
        attemptMode: state.attemptMode,
      );
    } else {
      state = state.copyWith(scope: scope);
    }
  }

  void setQuestionSource(QuestionSource source) {
    state = state.copyWith(questionSource: source);
  }

  void setQuestionCount(int count) {
    state = state.copyWith(questionCount: count);
  }

  void setDifficulty(DifficultyLevel difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }

  void setAttemptMode(AttemptMode mode) {
    state = state.copyWith(attemptMode: mode);
  }

  CustomExamOptionsConfig buildConfig() {
    return CustomExamOptionsConfig(
      courseId: state.scope == PracticeScope.fullCourse ? null : state.courseId,
      courseName: state.scope == PracticeScope.fullCourse
          ? null
          : state.courseName,
      isFullCourse: state.scope == PracticeScope.fullCourse,
      selectedLessonIds: const [],
      questionSource: switch (state.questionSource) {
        QuestionSource.previousYear => 'pyq',
        QuestionSource.boardPapers => 'board',
        QuestionSource.important => 'important',
      },
      questionCount: state.questionCount,
      difficulty: switch (state.difficulty) {
        DifficultyLevel.easy => 'easy',
        DifficultyLevel.medium => 'medium',
        DifficultyLevel.hard => 'hard',
        DifficultyLevel.mixed => 'mixed',
      },
      isQuizMode: state.attemptMode == AttemptMode.quiz,
    );
  }
}
