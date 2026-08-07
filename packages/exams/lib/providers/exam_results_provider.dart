import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import '../data/repositories/exam_results_repository.dart';
import '../models/exam_result_response_dto.dart';

part 'exam_results_provider.g.dart';

@riverpod
Future<ExamResultResponseDto> modelExamResults(
  ModelExamResultsRef ref, {
  required int page,
  required int limit,
}) async {
  final user = await ref.watch(userProvider.future);
  final username = user?.username ?? '';

  if (username.isEmpty) {
    return ExamResultResponseDto();
  }

  final repository = ref.watch(examResultsRepositoryProvider);
  return repository.getModelExamResults(
    studentNo: username,
    page: page,
    limit: limit,
  );
}

@riverpod
Future<ExamResultResponseDto> weeklyExamResults(
  WeeklyExamResultsRef ref, {
  required int page,
  required int limit,
}) async {
  final user = await ref.watch(userProvider.future);
  final username = user?.username ?? '';

  if (username.isEmpty) {
    return ExamResultResponseDto();
  }

  final repository = ref.watch(examResultsRepositoryProvider);
  return repository.getWeeklyExamResults(
    studentNo: username,
    page: page,
    limit: limit,
  );
}
