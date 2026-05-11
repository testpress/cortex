import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../repositories/doubt_repository.dart';

part 'doubt_providers.g.dart';

@Riverpod(keepAlive: true)
Future<DoubtRepository> doubtRepository(DoubtRepositoryRef ref) async {
  final database = await ref.watch(appDatabaseProvider.future);
  return DoubtRepository(
    dataSource: ref.watch(dataSourceProvider),
    db: database,
  );
}

@riverpod
Stream<List<DoubtDto>> doubtsList(DoubtsListRef ref) async* {
  final repository = await ref.watch(doubtRepositoryProvider.future);
  yield* repository.watchDoubts();
}

@riverpod
Future<void> doubtsSync(DoubtsSyncRef ref) async {
  final repo = await ref.watch(doubtRepositoryProvider.future);
  return repo.syncDoubts();
}
