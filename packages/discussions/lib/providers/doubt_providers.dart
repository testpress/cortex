import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../repositories/doubt_repository.dart';

part 'doubt_providers.g.dart';

@Riverpod(keepAlive: true)
DoubtRepository doubtRepository(DoubtRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider).valueOrNull;
  if (database == null) {
    throw Exception('Database not initialized');
  }

  return DoubtRepository(
    dataSource: ref.watch(dataSourceProvider),
    db: database,
  );
}

@riverpod
Stream<List<DoubtDto>> doubtsList(DoubtsListRef ref) {
  final repository = ref.watch(doubtRepositoryProvider);
  
  // Trigger background sync when provider is first watched
  repository.syncDoubts();
  
  return repository.watchDoubts();
}

@riverpod
class DoubtSearch extends _$DoubtSearch {
  @override
  String build() => '';
  
  void update(String query) => state = query;
}
