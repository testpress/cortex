import 'package:core/data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/custom_exam_repository.dart';

part 'custom_exam_config_provider.g.dart';

/// Fetches the configuration (subjects, difficulties, question types, limits)
/// for the custom exam builder. Cached per-course by Riverpod.
@riverpod
class CustomExamConfig extends _$CustomExamConfig {
  @override
  FutureOr<CustomTestConfigDto> build(String courseId) async {
    final repository = ref.watch(customExamRepositoryProvider);
    return await repository.getCustomTestConfig(courseId);
  }
}

/// Manages the API call to generate a custom exam from the built blocks.
@riverpod
class GenerateCustomExam extends _$GenerateCustomExam {
  @override
  FutureOr<AttemptDto?> build() {
    return null; // Initial state: no generation attempted yet.
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
