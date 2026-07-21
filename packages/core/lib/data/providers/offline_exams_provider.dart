import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../db/app_database.dart';
import '../repositories/offline_exams_list_repository.dart';

part 'offline_exams_provider.g.dart';

@riverpod
class OfflineExams extends _$OfflineExams {
  @override
  Stream<List<OfflineExamDownloadsTableData>> build() async* {
    final repo = await ref.watch(offlineExamsListRepositoryProvider.future);
    yield* repo.watchAllOfflineExams();
  }

  Future<void> deleteExam(int id) async {
    final repo = await ref.read(offlineExamsListRepositoryProvider.future);
    await repo.deleteExam(id);
  }
}
