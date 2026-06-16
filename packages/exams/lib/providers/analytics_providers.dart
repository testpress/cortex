import 'dart:async';
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
  yield* repository.watchSubjectAnalytics(parentId);
}

@riverpod
Stream<SubjectAnalyticsDto?> subjectAnalyticsById(Ref ref, int id) async* {
  final repository = await ref.watch(subjectAnalyticsRepositoryProvider.future);
  yield* repository.watchSubjectById(id);
}

@riverpod
class SubjectAnalyticsPagination extends _$SubjectAnalyticsPagination {
  int _nextPage = 2;

  @override
  Future<({bool hasMore, bool isLoadingMore})> build(int? parentId) async {
    ref.keepAlive();
    // Rebuild the pagination state if the logged-in user changes (e.g. logout)
    ref.watch(userIdProvider);

    final repository = await ref.watch(
      subjectAnalyticsRepositoryProvider.future,
    );
    final response = await repository.fetchSubjectAnalyticsPage(
      page: 1,
      parentId: parentId,
    );

    final serviceState = const PaginationService().calculateNextState(
      response: response,
      currentPage: 1,
    );

    _nextPage = serviceState.nextPage;
    return (hasMore: serviceState.hasMore, isLoadingMore: false);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData((hasMore: current.hasMore, isLoadingMore: true));
    try {
      final repository = await ref.read(
        subjectAnalyticsRepositoryProvider.future,
      );
      final response = await repository.fetchSubjectAnalyticsPage(
        page: _nextPage,
        parentId: parentId,
      );

      final serviceState = const PaginationService().calculateNextState(
        response: response,
        currentPage: _nextPage,
      );

      _nextPage = serviceState.nextPage;
      state = AsyncData((hasMore: serviceState.hasMore, isLoadingMore: false));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
