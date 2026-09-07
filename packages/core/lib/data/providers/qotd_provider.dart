import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/qotd_dto.dart';
import '../repositories/qotd_repository.dart';

part 'qotd_provider.g.dart';

/// Provider to fetch the Question of the Day list from the repository.
@riverpod
Future<List<QotdDto>> qotd(QotdRef ref) async {
  final repository = ref.watch(qotdRepositoryProvider);
  return repository.getQuestions();
}

/// Provider to fetch overall QOTD statistics/summary.
@riverpod
Future<QotdSummaryDto> qotdSummary(QotdSummaryRef ref) async {
  final repository = ref.watch(qotdRepositoryProvider);
  return repository.getSummary();
}
