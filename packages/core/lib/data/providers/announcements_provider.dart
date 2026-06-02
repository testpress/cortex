import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/post_dto.dart';
import '../repositories/repository_providers.dart';
import '../services/pagination_service.dart';

part 'announcements_provider.g.dart';

@riverpod
class Announcements extends _$Announcements {
  PaginationState _paginationState = const PaginationState();
  final _paginationService = const PaginationService();
  // Tracks the in-flight page 1 fetch so loadMore() can wait for it
  // before reading _paginationState, preventing a race where nextPage=1.
  Future<void>? _initialFetch;

  @override
  Stream<List<PostDto>> build() async* {
    _paginationState = const PaginationState();
    // Fire and forget fetch for page 1 to populate DB,
    // but hold a reference so loadMore() can await it.
    _initialFetch = _fetchPage(1);

    // Watch the database for reactive UI updates
    final repository = await ref.watch(postsRepositoryProvider.future);
    yield* repository.watchPosts();
  }

  Future<void> _fetchPage(int page) async {
    final repository = await ref.read(postsRepositoryProvider.future);
    final response = await repository.fetchPosts(page: page);
    
    _paginationState = _paginationService.calculateNextState(
      response: response,
      currentPage: page,
    );
  }

  Future<void> loadMore() async {
    // Wait for page 1 to finish so _paginationState.nextPage is correct.
    await _initialFetch;

    if (!_paginationState.hasMore) return;
    if (ref.read(announcementsFetchingPageProvider)) return;

    ref.read(announcementsFetchingPageProvider.notifier).setFetching(true);
    try {
      // We don't need to manually update state since it's a stream watching the DB.
      // Fetching the page inserts it into the DB, triggering a stream update automatically!
      await _fetchPage(_paginationState.nextPage);
    } catch (e, stack) {
      // Rethrow so the UI layer (scroll listener) can show a toast to the user.
      Error.throwWithStackTrace(e, stack);
    } finally {
      ref.read(announcementsFetchingPageProvider.notifier).setFetching(false);
    }
  }

  Future<void> refresh() async {
    _paginationState = const PaginationState();
    _initialFetch = _fetchPage(1);
    await _initialFetch;
  }
}

@riverpod
class PostCategories extends _$PostCategories {
  @override
  Stream<List<PostCategoryDto>> build() async* {
    final repository = await ref.watch(postsRepositoryProvider.future);
    
    // Fetch categories in background to keep DB up to date
    repository.fetchPostCategories().catchError((_) => <PostCategoryDto>[]);
    
    yield* repository.watchPostCategories();
  }
}

@riverpod
class AnnouncementsFetchingPage extends _$AnnouncementsFetchingPage {
  @override
  bool build() => false;

  void setFetching(bool fetching) => state = fetching;
}
