import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/downloads_repository.dart';
import '../../data/db/app_database.dart';
import '../../data/db/database_provider.dart';

part 'app_reset_use_case.g.dart';

class AppResetUseCase {
  final Future<AppDatabase> _database;
  final DownloadsRepository _downloadsRepository;

  AppResetUseCase(this._database, this._downloadsRepository);

  Future<void> execute() async {
    await purgeDownloads();
    await purgeDatabase();
  }

  Future<void> purgeDownloads() async {
    try {
      await _downloadsRepository.purgeAllDownloads();
    } catch (_) {}
  }

  Future<void> purgeDatabase() async {
    try {
      final db = await _database;
      await db.purgeAllData();
    } catch (_) {}
  }
}

@riverpod
Future<AppResetUseCase> appResetUseCase(AppResetUseCaseRef ref) async {
  final database = ref.watch(appDatabaseProvider.future);
  final downloadsRepo = await ref.watch(downloadsRepositoryProvider.future);
  return AppResetUseCase(database, downloadsRepo);
}
