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

@riverpod
List<String> doubtCategories(DoubtCategoriesRef ref) {
  return [
    'Physics', 'Chemistry', 'Mathematics', 'Biology', 'English', 'Accounts',
    'Anatomy', 'Discrete Maths', 'Algebra', 'Calculus', 'Organic Chemistry',
    'Inorganic Chemistry', 'Mechanics', 'Thermodynamics', 'Optics',
    'Cell Biology', 'Genetics', 'Ecology', 'Grammar', 'Literature'
  ];
}

@riverpod
Future<DoubtDto> doubtDetail(DoubtDetailRef ref, String id) async {
  final doubts = await ref.watch(doubtsListProvider.future);
  return doubts.firstWhere(
    (d) => d.id == id,
    orElse: () => throw Exception('Doubt with ID $id not found.'),
  );
}

@riverpod
Stream<List<DoubtReplyDto>> doubtReplies(DoubtRepliesRef ref, String id) async* {
  final repo = await ref.watch(doubtRepositoryProvider.future);
  repo.syncReplies(id).ignore();
  yield* repo.watchReplies(id);
}
