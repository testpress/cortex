import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';

part 'offline_exams_list_repository.g.dart';

class OfflineExamsListRepository {
  final AppDatabase _db;
  OfflineExamsListRepository(this._db);

  Stream<List<OfflineExamDownloadsTableData>> watchAllOfflineExams() {
    return _db.watchAllOfflineExams();
  }

  Future<void> deleteExam(int id) async {
    await _db.deleteDownload(id);
  }
}

@riverpod
Future<OfflineExamsListRepository> offlineExamsListRepository(
  OfflineExamsListRepositoryRef ref,
) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return OfflineExamsListRepository(db);
}
