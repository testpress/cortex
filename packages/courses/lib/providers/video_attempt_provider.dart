import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'course_list_provider.dart';

part 'video_attempt_provider.g.dart';

@riverpod
class VideoAttemptNotifier extends _$VideoAttemptNotifier {
  Timer? _periodicSyncTimer;
  Timer? _debounceTimer;
  KeepAliveLink? _keepAliveLink;
  DateTime? _lastSyncTime;

  String _lastWatchPosition = "0.0";
  final List<List<double>> _watchedTimeRanges = [];
  bool _isSyncing = false;

  @override
  void build(int chapterContentId) {
    _startPeriodicSync();
    
    ref.onDispose(() {
      _periodicSyncTimer?.cancel();
      _debounceTimer?.cancel();
      _keepAliveLink?.close();
    });
  }

  void updatePositionAndRanges(String position, List<List<double>> ranges) {
    _lastWatchPosition = position;
    _watchedTimeRanges.addAll(ranges);
    
    // Debounce the event-driven sync (e.g., pause, seek)
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 3), () {
      _syncToServer();
    });
  }

  void _startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _syncToServer();
    });
  }

  Future<void> _syncToServer({bool isForce = false}) async {
    if (_watchedTimeRanges.isEmpty) return;

    // Respect backend 1 request/min throttling unless it's a forced sync (e.g. Back button)
    if (!isForce && _lastSyncTime != null && DateTime.now().difference(_lastSyncTime!) < const Duration(seconds: 60)) {
      return;
    }

    // Prevent concurrent syncs for the same video
    if (_isSyncing) return;
    _isSyncing = true;
    _keepAliveLink ??= ref.keepAlive();

    try {
      final repository = await ref.read(courseRepositoryProvider.future);
      
      // Save current state locally before sending, so we know what we sent
      final rangesToSend = List<List<double>>.from(_watchedTimeRanges);
      
      await repository.updateVideoAttempt(
        chapterContentId: chapterContentId,
        lastWatchPosition: _lastWatchPosition,
        watchedTimeRanges: rangesToSend,
      );

      _lastSyncTime = DateTime.now();

      // Successfully sent! Now we can clear the delta ranges that were sent
      // We must compare by value because Dart lists use identity equality
      _watchedTimeRanges.removeWhere((r1) => 
        rangesToSend.any((r2) => r1.length >= 2 && r2.length >= 2 && r1[0] == r2[0] && r1[1] == r2[1])
      );
      
    } catch (e) {
      // Ignore network errors during background sync
    } finally {
      _isSyncing = false;
      // If we are done syncing and nobody is listening, the provider can safely dispose
      _keepAliveLink?.close();
      _keepAliveLink = null;
    }
  }

  Future<void> forceSync() async {
    _debounceTimer?.cancel();
    await _syncToServer(isForce: true);
  }
}
