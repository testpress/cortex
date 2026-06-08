import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../repositories/subject_analytics_repository.dart';

part 'analytics_providers.g.dart';

@riverpod
Stream<List<SubjectAnalyticsDto>> subjectAnalytics(SubjectAnalyticsRef ref, int? parentId) async* {
  final repository = await ref.watch(subjectAnalyticsRepositoryProvider.future);
  
  // Trigger background sync (Stale-While-Revalidate pattern)
  repository.refreshSubjectAnalytics('').catchError((_) {});
  
  yield* repository.watchSubjectAnalytics(parentId);
}

@riverpod
Stream<SubjectAnalyticsDto?> subjectAnalyticsById(SubjectAnalyticsByIdRef ref, int id) async* {
  final repository = await ref.watch(subjectAnalyticsRepositoryProvider.future);
  yield* repository.watchSubjectById(id);
}
