import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';

part 'offline_exams_provider.g.dart';

@riverpod
class OfflineExams extends _$OfflineExams {
  @override
  Stream<List<OfflineExamDownloadsTableData>> build() async* {
    final db = await ref.watch(appDatabaseProvider.future);
    yield* db.watchAllOfflineExams();
  }

  Future<void> deleteExam(int id) async {
    final db = await ref.read(appDatabaseProvider.future);
    await db.deleteDownload(id);
  }
}
