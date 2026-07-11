import 'package:core/data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/custom_exam_repository.dart';

part 'custom_exam_config_provider.g.dart';

@riverpod
class CustomExamConfig extends _$CustomExamConfig {
  @override
  FutureOr<CustomTestConfigDto> build(String courseId) async {
    final repository = ref.watch(customExamRepositoryProvider);
    return await repository.getCustomTestConfig(courseId);
  }
}

/// Stores the user's selected parameters for the custom exam.
class CustomExamSelectionState {
  final List<String> selectedSubjects;
  final List<String> selectedDifficulties;
  final List<String> selectedQuestionTypes;
  final String? selectedTestMode;
  final int numberOfQuestions;

  const CustomExamSelectionState({
    this.selectedSubjects = const [],
    this.selectedDifficulties = const [],
    this.selectedQuestionTypes = const [],
    this.selectedTestMode,
    this.numberOfQuestions = 15,
  });

  CustomExamSelectionState copyWith({
    List<String>? selectedSubjects,
    List<String>? selectedDifficulties,
    List<String>? selectedQuestionTypes,
    String? selectedTestMode,
    int? numberOfQuestions,
  }) {
    return CustomExamSelectionState(
      selectedSubjects: selectedSubjects ?? this.selectedSubjects,
      selectedDifficulties: selectedDifficulties ?? this.selectedDifficulties,
      selectedQuestionTypes:
          selectedQuestionTypes ?? this.selectedQuestionTypes,
      selectedTestMode: selectedTestMode ?? this.selectedTestMode,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
    );
  }
}

@riverpod
class CustomExamSelection extends _$CustomExamSelection {
  @override
  CustomExamSelectionState build(String courseId) {
    return const CustomExamSelectionState();
  }

  void toggleSubject(String subject) {
    final list = List<String>.from(state.selectedSubjects);
    if (list.contains(subject)) {
      list.remove(subject);
    } else {
      list.add(subject);
    }
    state = state.copyWith(selectedSubjects: list);
  }

  void toggleDifficulty(String difficulty) {
    final list = List<String>.from(state.selectedDifficulties);
    if (list.contains(difficulty)) {
      list.remove(difficulty);
    } else {
      list.add(difficulty);
    }
    state = state.copyWith(selectedDifficulties: list);
  }

  void toggleQuestionType(String type) {
    final list = List<String>.from(state.selectedQuestionTypes);
    if (list.contains(type)) {
      list.remove(type);
    } else {
      list.add(type);
    }
    state = state.copyWith(selectedQuestionTypes: list);
  }

  void setTestMode(String mode) {
    state = state.copyWith(selectedTestMode: mode);
  }

  void setNumberOfQuestions(int count) {
    state = state.copyWith(numberOfQuestions: count);
  }

  CustomExamGenerationRequestDto toGenerationRequest() {
    return CustomExamGenerationRequestDto(
      courseId: courseId,
      subjects: state.selectedSubjects,
      difficultyLevels: state.selectedDifficulties,
      questionTypes: state.selectedQuestionTypes,
      testMode: state.selectedTestMode ?? '',
      numberOfQuestions: state.numberOfQuestions,
    );
  }
}

@riverpod
class GenerateCustomExam extends _$GenerateCustomExam {
  @override
  FutureOr<AttemptDto?> build() {
    return null; // Initial state is null (no generation attempted yet)
  }

  Future<void> generate(CustomExamGenerationRequestDto request) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(customExamRepositoryProvider);
      final attempt = await repository.generateCustomExam(request);
      state = AsyncValue.data(attempt);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
