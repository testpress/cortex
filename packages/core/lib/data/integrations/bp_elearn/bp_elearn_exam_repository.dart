import 'models/bp_elearn_paginated_response_dto.dart';
import 'bp_elearn_exam_api_service.dart';

/// Exam results repository for Brilliant Pala Elearn specific integration.
///
/// **Offline caching: intentionally omitted.**
/// Exam results are real-time academic data that must always reflect the
/// latest server state. Caching them locally via Drift would risk showing
/// stale scores to students. This feature is therefore online-only by design
/// and does not integrate with the Drift layer.
class BPElearnExamRepository {
  final BPElearnExamApiService _apiService;

  BPElearnExamRepository(this._apiService);

  Future<BPElearnPaginatedResponseDto> getModelExamResults({
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

  Future<BPElearnPaginatedResponseDto> getWeeklyExamResults({
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
