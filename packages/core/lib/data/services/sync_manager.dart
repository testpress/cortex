import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  Connectivity get connectivity => _connectivity;
  SyncManagerRef get ref => _ref;

  void _initListener() {
    // Automatic background/connectivity syncing is disabled to give users
    // full awareness via explicit manual sync on the Offline Exams screen.
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
