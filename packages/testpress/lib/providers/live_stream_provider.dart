import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../screens/live_streams/widgets/live_stream_card.dart';

part 'live_stream_provider.g.dart';

/// Tracks if the initial page of live streams is currently syncing.
@riverpod
class IsSyncingInitialPage extends _$IsSyncingInitialPage {
  @override
  bool build() => false;

  void setSyncing(bool value) {
    state = value;
  }
}

/// Tracks network sync errors.
@riverpod
class LiveStreamSyncError extends _$LiveStreamSyncError {
  @override
  Object? build() => null;

  void setError(Object? value) {
    state = value;
  }
}

@riverpod
class LiveStreamList extends _$LiveStreamList {
  Future<void>? _initialFetch;
  int _syncToken = 0;

  @override
  Stream<List<LiveStreamItem>> build() async* {
    final repository = await ref.watch(liveClassesRepositoryProvider.future);

    // Auto-trigger sync on load and store the Future
    _initialFetch = _syncLiveStreams(clearCache: true).catchError((e) {
      ref.read(liveStreamSyncErrorProvider.notifier).setError(e);
    });

    yield* repository.watchLiveClasses().map((dtos) {
      return dtos.map((dto) {
        final statusVal = switch (dto.status) {
          LiveClassStatus.live => LiveStreamStatus.live,
          LiveClassStatus.completed => LiveStreamStatus.completed,
          LiveClassStatus.cancelled => LiveStreamStatus.cancelled,
          _ => LiveStreamStatus.upcoming,
        };
        // Parse time string (stored as ISO-8601 in time column)
        final startDt =
            DateTime.tryParse(dto.time)?.toLocal() ?? DateTime.now();

        return LiveStreamItem(
          id: dto.id,
          title: dto.topic,
          courseName: dto.subject,
          start: startDt,
          status: statusVal,
        );
      }).toList();
    });
  }

  Future<void> _syncLiveStreams({bool clearCache = false}) async {
    final token = ++_syncToken;
    ref.read(isSyncingInitialPageProvider.notifier).setSyncing(true);
    ref.read(liveStreamSyncErrorProvider.notifier).setError(null);

    try {
      final repository = await ref.read(liveClassesRepositoryProvider.future);
      final response = await repository.fetchLiveClasses(
        page: 1,
        clearCache: clearCache,
      );

      if (token == _syncToken && response.next != null) {
        _syncRemainingPages(token, repository, response.next);
      }
    } finally {
      if (token == _syncToken) {
        ref.read(isSyncingInitialPageProvider.notifier).setSyncing(false);
      }
    }
  }

  Future<void> _syncRemainingPages(
    int token,
    LiveClassesRepository repository,
    String? nextUrl,
  ) async {
    String? currentNext = nextUrl;
    int currentPage = 2;

    while (token == _syncToken &&
        currentNext != null &&
        currentNext.isNotEmpty) {
      try {
        final response = await repository.fetchLiveClasses(
          page: currentPage,
          clearCache: false,
        );
        currentNext = response.next;
        currentPage++;
      } catch (e) {
        // Silently stop background sync on error to avoid polluting the log/UI
        break;
      }
    }
  }

  /// Refreshes lists by clearing database cache and re-fetching page 1.
  Future<void> refresh() async {
    _initialFetch = _syncLiveStreams(clearCache: true);
    await _initialFetch;
  }
}
