import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/qotd_dto.dart';
import '../sources/data_source.dart';
import '../sources/data_source_provider.dart';

/// Repository for Question of the Day (QOTD) business logic and data access.
class QotdRepository {
  final DataSource _dataSource;

  const QotdRepository({required DataSource dataSource})
    : _dataSource = dataSource;

  /// Fetches the list of daily questions.
  Future<List<QotdDto>> getQuestions() async {
    return _dataSource.getQotdQuestions();
  }

  /// Submits an attempt for a specific question and options.
  Future<QotdSubmitResponseDto> submitAttempt({
    required int questionId,
    required List<int> optionIds,
  }) async {
    return _dataSource.submitQotdAttempt(questionId, optionIds);
  }

  /// Fetches the overall QOTD statistics and summary.
  Future<QotdSummaryDto> getSummary() async {
    return _dataSource.getQotdSummary();
  }
}

/// Provides the [QotdRepository] instance.
final qotdRepositoryProvider = Provider<QotdRepository>((ref) {
  final dataSource = ref.watch(dataSourceProvider);
  return QotdRepository(dataSource: dataSource);
});
