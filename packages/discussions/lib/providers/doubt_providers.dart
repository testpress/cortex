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
Future<List<DoubtDto>> doubtsSearch(DoubtsSearchRef ref, String query) async {
  final repository = await ref.watch(doubtRepositoryProvider.future);
  final response = await repository.syncDoubts(page: 1, searchQuery: query);
  return response.results;
}

@riverpod
class DoubtsSync extends _$DoubtsSync {
  int _nextPage = 2;

  @override
  Future<({bool hasMore, bool isLoadingMore})> build() async {
    final repo = await ref.watch(doubtRepositoryProvider.future);
    final response = await repo.syncDoubts(page: 1);
    _nextPage = 2;
    return (hasMore: response.next != null, isLoadingMore: false);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData((hasMore: current.hasMore, isLoadingMore: true));
    try {
      final repo = await ref.read(doubtRepositoryProvider.future);
      final response = await repo.syncDoubts(page: _nextPage);
      final hasMore = response.next != null;
      if (hasMore) _nextPage++;
      state = AsyncData((hasMore: hasMore, isLoadingMore: false));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

@riverpod
Future<void> doubtTopicsSync(DoubtTopicsSyncRef ref) async {
  final repo = await ref.watch(doubtRepositoryProvider.future);
  return repo.syncTopics();
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
Stream<List<DoubtReplyDto>> doubtReplies(
  DoubtRepliesRef ref,
  String id,
) async* {
  final repo = await ref.watch(doubtRepositoryProvider.future);

  final initial = await repo.watchReplies(id).first;
  if (initial.isEmpty) {
    // If we have no cached replies, await the sync so the UI shows the skeleton (loading state).
    await repo.syncReplies(id);
  } else {
    // If we have cached replies, show them immediately and sync in the background.
    repo.syncReplies(id).ignore();
  }

  yield* repo.watchReplies(id);
}

@riverpod
Stream<List<DoubtTopicDto>> doubtSubtopics(
  DoubtSubtopicsRef ref,
  int? parentId,
) async* {
  final repo = await ref.watch(doubtRepositoryProvider.future);
  repo.syncTopics(parentId: parentId).ignore();
  yield* repo.watchTopics(parentId: parentId);
}

@riverpod
class CreateDoubtNotifier extends _$CreateDoubtNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String title,
    required String description,
    int? topicId,
    int? chapterContentId,
    int? questionId,
    List<String> attachments = const [],
    DoubtQueryType? queryType,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(doubtRepositoryProvider.future);

      String finalContent = description;
      if (attachments.isNotEmpty) {
        final uploadFutures = attachments.map(
          (path) => repo.uploadDoubtImage(path),
        );
        final uploaded = await Future.wait(uploadFutures);
        for (final url in uploaded) {
          finalContent += '<br><img src="$url" />';
        }
      }

      await repo.createDoubt(
        title: title,
        description: finalContent,
        topicId: topicId,
        chapterContentId: chapterContentId,
        questionId: questionId,
        queryType: queryType,
      );

      ref.invalidate(doubtsListProvider);
    });
  }
}

@riverpod
class PostDoubtReplyNotifier extends _$PostDoubtReplyNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String doubtId,
    String? comment,
    bool? shouldResolve,
    bool? shouldClose,
    List<String> attachments = const [],
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(doubtRepositoryProvider.future);

      String? finalContent = comment;
      if (attachments.isNotEmpty) {
        final uploadFutures = attachments.map(
          (path) => repo.uploadDoubtImage(path),
        );
        final uploaded = await Future.wait(uploadFutures);
        String tempContent = finalContent ?? '';
        for (final url in uploaded) {
          tempContent += '<br><img src="$url" />';
        }
        finalContent = tempContent;
      }

      await repo.postDoubtReply(
        doubtId: doubtId,
        comment: finalContent,
        shouldResolve: shouldResolve,
        shouldClose: shouldClose,
      );

      ref.invalidate(doubtRepliesProvider(doubtId));
      ref.invalidate(doubtsListProvider);
    });
  }
}
