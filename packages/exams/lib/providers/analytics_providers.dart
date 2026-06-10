import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../repositories/subject_analytics_repository.dart';

part 'analytics_providers.g.dart';

@Riverpod(keepAlive: true)
Future<SubjectAnalyticsRepository> subjectAnalyticsRepository(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final dataSource = ref.watch(dataSourceProvider);
  return SubjectAnalyticsRepository(dataSource: dataSource, db: db);
}

@riverpod
Stream<List<SubjectAnalyticsDto>> subjectAnalytics(
  Ref ref,
  int? parentId,
) async* {
  final repository = await ref.watch(subjectAnalyticsRepositoryProvider.future);

  // Trigger background sync (Stale-While-Revalidate pattern)
  repository.refreshSubjectAnalytics().catchError((_) {});

  yield* repository.watchSubjectAnalytics(parentId);
}

@riverpod
Stream<SubjectAnalyticsDto?> subjectAnalyticsById(Ref ref, int id) async* {
  final repository = await ref.watch(subjectAnalyticsRepositoryProvider.future);
  yield* repository.watchSubjectById(id);
}
