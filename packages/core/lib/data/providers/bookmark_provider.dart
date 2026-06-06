import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/bookmark_dto.dart';
import '../repositories/repository_providers.dart';
import '../services/pagination_service.dart';

part 'bookmark_provider.g.dart';

/// Stream of all bookmark folders.
@riverpod
Stream<List<BookmarkFolderDto>> bookmarkFolders(BookmarkFoldersRef ref) async* {
  final repository = await ref.watch(bookmarkRepositoryProvider.future);
  
  // Trigger a background network sync when the provider is first initialized.
  // We do not await this, so the local cached stream emits instantly!
  repository.refreshFolders().catchError((_) {});
  
  yield* repository.watchBookmarkFolders();
}

/// Stream of all active bookmarks for a given lesson.
@riverpod
Stream<List<BookmarkDto>> bookmarksForLesson(BookmarksForLessonRef ref, int lessonId) async* {
  final repository = await ref.watch(bookmarkRepositoryProvider.future);
  yield* repository.watchBookmarksForLesson(lessonId);
}

/// Action to refresh bookmark folders.
@riverpod
Future<void> refreshBookmarkFolders(RefreshBookmarkFoldersRef ref) async {
  final repository = await ref.read(bookmarkRepositoryProvider.future);
  await repository.refreshFolders();
}

/// Action to create a new bookmark folder.
@riverpod
Future<BookmarkFolderDto> createBookmarkFolder(CreateBookmarkFolderRef ref, String folderName) async {
  final repository = await ref.read(bookmarkRepositoryProvider.future);
  final folder = await repository.createFolder(folderName);
  ref.invalidate(bookmarkFoldersProvider);
  return folder;
}

/// Action to update an existing bookmark folder.
@riverpod
Future<BookmarkFolderDto> updateBookmarkFolder(UpdateBookmarkFolderRef ref, int folderId, String folderName) async {
  final repository = await ref.read(bookmarkRepositoryProvider.future);
  final folder = await repository.updateFolder(folderId, folderName);
  ref.invalidate(bookmarkFoldersProvider);
  return folder;
}

/// Action to delete an existing bookmark folder.
@riverpod
Future<void> deleteBookmarkFolder(DeleteBookmarkFolderRef ref, int folderId) async {
  final repository = await ref.read(bookmarkRepositoryProvider.future);
  await repository.deleteFolder(folderId);
  ref.invalidate(bookmarkFoldersProvider);
}

/// Action to add a bookmark for a lesson.
@riverpod
Future<BookmarkDto> addBookmark(
  AddBookmarkRef ref, {
  required String category,
  required int lessonId,
  String? folder,
  String? bookmarkType,
}) async {
  final repository = await ref.read(bookmarkRepositoryProvider.future);
  final bookmark = await repository.addBookmark(
    category: category,
    lessonId: lessonId,
    folder: folder,
    bookmarkType: bookmarkType,
  );
  
  ref.invalidate(paginatedBookmarksProvider);
  ref.invalidate(bookmarkFoldersProvider);
  
  return bookmark;
}

/// Action to remove a bookmark by ID.
@riverpod
Future<void> removeBookmark(
  RemoveBookmarkRef ref, {
  required int bookmarkId,
  required int lessonId,
}) async {
  final repository = await ref.read(bookmarkRepositoryProvider.future);
  await repository.removeBookmark(bookmarkId, lessonId);
  
  ref.invalidate(paginatedBookmarksProvider);
  ref.invalidate(bookmarkFoldersProvider);
}

class BookmarkFilter {
  final String? folder;
  final String? order;
  final String? filter;

  const BookmarkFilter({this.folder, this.order, this.filter});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkFilter &&
          runtimeType == other.runtimeType &&
          folder == other.folder &&
          order == other.order &&
          filter == other.filter;

  @override
  int get hashCode => folder.hashCode ^ order.hashCode ^ filter.hashCode;
}

@riverpod
class PaginatedBookmarks extends _$PaginatedBookmarks {
  PaginationState _paginationState = const PaginationState();
  final _paginationService = const PaginationService();
  Future<void>? _initialFetch;

  @override
  FutureOr<List<BookmarkDto>> build({BookmarkFilter filter = const BookmarkFilter()}) async {
    _paginationState = const PaginationState();
    
    // Using a remote-only approach since bookmarks from v2.4 aren't cached locally
    _initialFetch = _fetchPage(1);
    await _initialFetch;
    
    return state.valueOrNull ?? [];
  }

  Future<void> _fetchPage(int page) async {
    final repository = await ref.read(bookmarkRepositoryProvider.future);
    final response = await repository.fetchBookmarks(
      page: page,
      folder: filter.folder,
      order: filter.order,
      filter: filter.filter,
    );
    
    _paginationState = _paginationService.calculateNextState(
      response: response,
      currentPage: page,
    );

    if (page == 1) {
      state = AsyncValue.data(response.results);
    } else {
      final currentList = state.valueOrNull ?? [];
      state = AsyncValue.data([...currentList, ...response.results]);
    }
  }

  Future<void> loadMore() async {
    await _initialFetch;

    if (!_paginationState.hasMore) return;
    if (ref.read(paginatedBookmarksFetchingPageProvider(filter))) return;

    ref.read(paginatedBookmarksFetchingPageProvider(filter).notifier).setFetching(true);
    try {
      await _fetchPage(_paginationState.nextPage);
    } catch (e, stack) {
      Error.throwWithStackTrace(e, stack);
    } finally {
      ref.read(paginatedBookmarksFetchingPageProvider(filter).notifier).setFetching(false);
    }
  }

  Future<void> refresh() async {
    _paginationState = const PaginationState();
    _initialFetch = _fetchPage(1);
    await _initialFetch;
  }
}

@riverpod
class PaginatedBookmarksFetchingPage extends _$PaginatedBookmarksFetchingPage {
  @override
  bool build(BookmarkFilter filter) => false;

  void setFetching(bool fetching) => state = fetching;
}

