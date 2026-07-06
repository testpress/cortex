import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../workers/offline_exam_sync_worker.dart';
import 'offline_exam_sync_service.dart';

part 'sync_manager.g.dart';

/// Aggressively listens to network connectivity changes in the foreground
/// and triggers syncing when the user regains a connection.
class SyncManager {
  final Connectivity _connectivity;
  final SyncManagerRef _ref;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  SyncManager(this._connectivity, this._ref) {
    _initListener();
  }

  void _initListener() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.ethernet)) {
        // We regained connection, schedule a one-off sync task.
        // Workmanager handles ensuring this runs even if the app closes shortly after.
        OfflineExamSyncWorker.scheduleSync();

        // Immediate foreground sync attempt
        try {
          final syncService = await _ref.read(
            offlineExamSyncServiceProvider.future,
          );
          await syncService.syncPendingExams();
        } catch (e) {
          debugPrint("Foreground sync attempt failed: $e");
        }
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}

@Riverpod(keepAlive: true)
SyncManager syncManager(SyncManagerRef ref) {
  final manager = SyncManager(Connectivity(), ref);
  ref.onDispose(() => manager.dispose());
  return manager;
}
