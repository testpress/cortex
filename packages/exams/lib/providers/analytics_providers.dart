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

  // The pagination provider handles the initial background fetch and state
  // Watching it here ensures it is initialized and kept alive.
  ref.watch(subjectAnalyticsPaginationProvider(parentId));

  yield* repository.watchSubjectAnalytics(parentId);
}

@riverpod
Stream<SubjectAnalyticsDto?> subjectAnalyticsById(Ref ref, int id) async* {
  final repository = await ref.watch(subjectAnalyticsRepositoryProvider.future);
  yield* repository.watchSubjectById(id);
}

class SubjectAnalyticsPaginationState {
  final int currentPage;
  final bool hasMorePages;
  final bool isFetchingNextPage;

  SubjectAnalyticsPaginationState({
    required this.currentPage,
    required this.hasMorePages,
    required this.isFetchingNextPage,
  });

  SubjectAnalyticsPaginationState copyWith({
    int? currentPage,
    bool? hasMorePages,
    bool? isFetchingNextPage,
  }) {
    return SubjectAnalyticsPaginationState(
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isFetchingNextPage: isFetchingNextPage ?? this.isFetchingNextPage,
    );
  }
}

@riverpod
class SubjectAnalyticsPagination extends _$SubjectAnalyticsPagination {
  int? _parentId;

  @override
  SubjectAnalyticsPaginationState build(int? parentId) {
    _parentId = parentId;
    Future.microtask(() => fetchInitial());

    return SubjectAnalyticsPaginationState(
      currentPage: 1,
      hasMorePages: true,
      isFetchingNextPage: false,
    );
  }

  Future<void> fetchInitial() async {
    final repository = await ref.read(subjectAnalyticsRepositoryProvider.future);
    try {
      final response = await repository.fetchSubjectAnalyticsPage(
        page: 1,
        parentId: _parentId,
      );
      state = state.copyWith(
        currentPage: 1,
        hasMorePages: response.next != null,
      );
    } catch (e) {
      // Ignored intentionally for offline fallback
    }
  }

  Future<void> fetchNextPage() async {
    if (!state.hasMorePages || state.isFetchingNextPage) return;

    state = state.copyWith(isFetchingNextPage: true);

    try {
      final nextPage = state.currentPage + 1;
      final repository = await ref.read(subjectAnalyticsRepositoryProvider.future);
      final response = await repository.fetchSubjectAnalyticsPage(
        page: nextPage,
        parentId: _parentId,
      );

      state = state.copyWith(
        currentPage: nextPage,
        hasMorePages: response.next != null,
        isFetchingNextPage: false,
      );
    } catch (e) {
      state = state.copyWith(isFetchingNextPage: false);
    }
  }
}
