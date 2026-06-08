import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'course_list_provider.dart';

part 'info_providers.g.dart';

/// Notifier that manages the info-specific course list and its independent sync state.
/// This perfectly matches the pattern used in ExamList.
@Riverpod(keepAlive: true)
class InfoList extends _$InfoList {
  PaginationState _paginationTracker = const PaginationState();
  Future<void>? _pendingSyncRequest;
  bool _isInitialized = false;

  @override
  Stream<List<CourseDto>> build() async* {
    final repo = await ref.watch(courseRepositoryProvider.future);

    // Yield the filtered stream from the repository
    yield* repo.watchInfoCourses().map(
          (rows) => rows.map((row) => repo.rowToCourseDto(row)).toList(),
        );
  }

  /// Triggers an independent sync for the Info tab.
  Future<void> initialize() async {
    if (_isInitialized) return;

    if (_pendingSyncRequest != null) return _pendingSyncRequest;
    _isInitialized = true;

    _pendingSyncRequest = _performSync(isReset: true);
    try {
      await _pendingSyncRequest;
    } catch (_) {
      _isInitialized = false; // Allow retry on error
    } finally {
      _pendingSyncRequest = null;
    }
  }

  Future<void> loadMore() async {
    if (!_paginationTracker.hasMore || _pendingSyncRequest != null) return;

    _pendingSyncRequest = _performSync(isReset: false);
    try {
      await _pendingSyncRequest;
    } finally {
      _pendingSyncRequest = null;
    }
  }

  Future<void> _performSync({required bool isReset}) async {
    if (isReset) {
      _paginationTracker = const PaginationState();

      // Only show the initial loader if the local database is actually empty.
      final hasData = state.valueOrNull?.isNotEmpty ?? false;
      if (!hasData) {
        Future.microtask(() {
          ref.read(isSyncingInfoProvider.notifier).state = true;
        });
      }
    } else {
      ref.read(isSyncingMoreInfoProvider.notifier).state = true;
    }

    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      final response = await repo.refreshCourses(
        page: _paginationTracker.nextPage,
        tags: 'info',
      );

      if (response.results.isEmpty) {
        _paginationTracker = _paginationTracker.copyWith(hasMore: false);
      } else {
        const pagination = PaginationService();
        _paginationTracker = pagination.calculateNextState(
          response: response,
          currentPage: _paginationTracker.nextPage,
        );
      }
    } finally {
      if (isReset) {
        Future.microtask(() {
          ref.read(isSyncingInfoProvider.notifier).state = false;
        });
      } else {
        Future.microtask(() {
          ref.read(isSyncingMoreInfoProvider.notifier).state = false;
        });
      }
    }
  }
}

/// Simple provider to track the independent loading state of the Info tab.
final isSyncingInfoProvider = StateProvider<bool>((ref) => false);
final isSyncingMoreInfoProvider = StateProvider<bool>((ref) => false);
