import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/downloads_repository.dart';
import '../../data/db/app_database.dart';
import '../../data/db/database_provider.dart';
import '../../data/services/sentry_service.dart';

part 'app_reset_use_case.g.dart';

class AppResetUseCase {
  final Future<AppDatabase> _database;
  final DownloadsRepository _downloadsRepository;
  final SentryService _sentryService;

  AppResetUseCase(
    this._database,
    this._downloadsRepository,
    this._sentryService,
  );

  Future<void> execute() async {
    await purgeDownloads();
    await purgeDatabase();
  }

  Future<void> purgeDownloads() async {
    try {
      await _downloadsRepository.purgeAllDownloads();
    } catch (e, stackTrace) {
      _sentryService.captureException(e, stackTrace: stackTrace);
    }
  }

  Future<void> purgeDatabase() async {
    try {
      final db = await _database;
      await db.purgeAllData();
    } catch (e, stackTrace) {
      _sentryService.captureException(e, stackTrace: stackTrace);
    }
  }
}

@riverpod
Future<AppResetUseCase> appResetUseCase(AppResetUseCaseRef ref) async {
  final database = ref.watch(appDatabaseProvider.future);
  final downloadsRepo = await ref.watch(downloadsRepositoryProvider.future);
  final sentryService = ref.watch(sentryServiceProvider);
  return AppResetUseCase(database, downloadsRepo, sentryService);
}
