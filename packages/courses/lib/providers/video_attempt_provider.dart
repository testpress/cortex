import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'course_list_provider.dart';

part 'video_attempt_provider.g.dart';

@Riverpod(keepAlive: true)
class VideoAttemptNotifier extends _$VideoAttemptNotifier {
  Timer? _periodicSyncTimer;
  Timer? _debounceTimer;

  int? _chapterContentId;
  String _lastWatchPosition = "0.0";
  List<List<double>> _watchedTimeRanges = [];

  @override
  void build() {
    ref.onDispose(() {
      _periodicSyncTimer?.cancel();
      _debounceTimer?.cancel();
    });
  }

  void initialize(int chapterContentId) {
    _chapterContentId = chapterContentId;
    _watchedTimeRanges.clear();
    _lastWatchPosition = "0.0";
    _startPeriodicSync();
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

  Future<void> _syncToServer() async {
    if (_chapterContentId == null || _watchedTimeRanges.isEmpty) return;

    try {
      final repository = await ref.read(courseRepositoryProvider.future);
      
      // Save current state locally before sending, so we know what we sent
      final rangesToSend = List<List<double>>.from(_watchedTimeRanges);
      
      await repository.updateVideoAttempt(
        chapterContentId: _chapterContentId!,
        lastWatchPosition: _lastWatchPosition,
        watchedTimeRanges: rangesToSend,
      );

      // Successfully sent! Now we can clear the delta ranges that were sent
      // We must compare by value because Dart lists use identity equality
      _watchedTimeRanges.removeWhere((r1) => 
        rangesToSend.any((r2) => r1.isNotEmpty && r2.isNotEmpty && r1[0] == r2[0] && r1.last == r2.last)
      );
      
    } catch (e) {
      // Ignore network errors during background sync
    }
  }

  Future<void> forceSync() async {
    _debounceTimer?.cancel();
    await _syncToServer();
  }
}
