import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import '../data/db/app_database.dart';
import '../data/sources/http_data_source.dart';
import '../data/services/offline_exam_sync_service.dart';
import '../data/auth/auth_local_data_source.dart';
import '../network/dio_provider.dart';
import '../data/services/sentry_service.dart';

/// Top-level function required by workmanager to run in a background isolate.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Sentry explicitly for this background isolate
    final sentryService = SentryService();
    await sentryService.initialize();

    if (task == OfflineExamSyncWorker.syncTaskName) {
      try {
        debugPrint("Background sync running for offline exams...");

        final authLocalDataSource = AuthLocalDataSource();

        final dio = DioFactory.createBackgroundDio(
          getToken: () => authLocalDataSource.getToken(),
          onUnauthorized: () {},
        );

        final db = AppDatabase();
        try {
          final api = HttpDataSource(dio: dio);
          final service = OfflineExamSyncService(db, api, sentryService);

          await service.syncPendingExams();
          debugPrint("Background sync completed successfully.");
        } finally {
          await db.close();
        }
      } catch (err, stackTrace) {
        debugPrint("Background sync failed: $err");
        sentryService.captureException(err, stackTrace: stackTrace);
        return Future.value(false); // Retries based on workmanager config
      }
      return Future.value(true);
    }
    return Future.value(true);
  });
}

/// Helper class to manage the lifecycle and scheduling of the background sync worker.
class OfflineExamSyncWorker {
  static const String syncTaskName = 'syncOfflineExams';

  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  /// Schedules a one-off sync task that will execute as soon as network is available.
  static void scheduleSync() {
    Workmanager().registerOneOffTask(
      "offlineExamSyncTask_${DateTime.now().millisecondsSinceEpoch}",
      syncTaskName,
      constraints: Constraints(
        networkType:
            NetworkType.connected, // Only run when connected to the internet
      ),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 5),
    );
  }
}
