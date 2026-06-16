import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../repositories/subject_analytics_repository.dart';
import 'subject_analytics_pagination_state.dart';

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

@Riverpod(keepAlive: true)
class SubjectAnalyticsPagination extends _$SubjectAnalyticsPagination {
  SubjectAnalyticsPaginationState _paginationState =
      SubjectAnalyticsPaginationState(
        currentPage: 1,
        hasMorePages: true,
        isFetchingNextPage: false,
        isFetchingInitial: true,
      );
  final _paginationService = const PaginationService();
  Future<List<SubjectAnalyticsDto>>? _initialFetch;

  @override
  SubjectAnalyticsPaginationState build(int? parentId) {
    // Rebuild the pagination state if the logged-in user changes (e.g. logout)
    ref.watch(userIdProvider);

    _paginationState = SubjectAnalyticsPaginationState(
      currentPage: 1,
      hasMorePages: true,
      isFetchingNextPage: false,
      isFetchingInitial: true,
    );

    Future.microtask(() => fetchInitial());

    return _paginationState;
  }

  Future<void> fetchInitial() async {
    _paginationState = _paginationState.copyWith(isFetchingInitial: true);
    state = _paginationState;

    _initialFetch = _fetchPage(1, clearCache: true);
    await _initialFetch;

    _paginationState = _paginationState.copyWith(isFetchingInitial: false);
    state = _paginationState;
  }

  Future<List<SubjectAnalyticsDto>> _fetchPage(
    int page, {
    bool clearCache = false,
  }) async {
    final repository = await ref.read(
      subjectAnalyticsRepositoryProvider.future,
    );
    final response = await repository.fetchSubjectAnalyticsPage(
      page: page,
      parentId: parentId,
    );

    final serviceState = _paginationService.calculateNextState(
      response: response,
      currentPage: page,
    );

    _paginationState = _paginationState.copyWith(
      currentPage: serviceState.nextPage,
      hasMorePages: serviceState.hasMore,
    );
    state = _paginationState;

    return response.results;
  }

  Future<void> fetchNextPage() async {
    await _initialFetch;

    if (!_paginationState.hasMorePages) return;
    if (_paginationState.isFetchingNextPage) return;

    _paginationState = _paginationState.copyWith(isFetchingNextPage: true);
    state = _paginationState;

    try {
      await _fetchPage(_paginationState.currentPage);
    } catch (e, stack) {
      Error.throwWithStackTrace(e, stack);
    } finally {
      _paginationState = _paginationState.copyWith(isFetchingNextPage: false);
      state = _paginationState;
    }
  }
}
