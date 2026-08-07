import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/exam_result_response_dto.dart';
import '../network/exam_results_api_service.dart';

part 'exam_results_repository.g.dart';

/// Exam results repository.
///
/// **Offline caching: intentionally omitted.**
/// Exam results are real-time academic data that must always reflect the
/// latest server state. Caching them locally via Drift would risk showing
/// stale scores to students. This feature is therefore online-only by design
/// and does not integrate with the Drift layer.
class ExamResultsRepository {
  final ExamResultApiService _apiService;

  ExamResultsRepository(this._apiService);

  Future<ExamResultResponseDto> getModelExamResults({
    required String studentNo,
    required int page,
    required int limit,
  }) {
    return _apiService.fetchExamResults(
      studentNo: studentNo,
      pageNo: page,
      limit: limit,
      examType: 'Model',
    );
  }

  Future<ExamResultResponseDto> getWeeklyExamResults({
    required String studentNo,
    required int page,
    required int limit,
  }) {
    return _apiService.fetchExamResults(
      studentNo: studentNo,
      pageNo: page,
      limit: limit,
      examType: 'Weekly',
    );
  }
}

@riverpod
ExamResultsRepository examResultsRepository(ExamResultsRepositoryRef ref) {
  final apiService = ref.watch(examResultApiServiceProvider);
  return ExamResultsRepository(apiService);
}
