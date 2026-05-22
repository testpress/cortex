import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/bookmark_dto.dart';
import '../repositories/repository_providers.dart';

part 'bookmark_provider.g.dart';

/// Stream of all bookmark folders.
@riverpod
Stream<List<BookmarkFolderDto>> bookmarkFolders(BookmarkFoldersRef ref) async* {
  final repository = await ref.watch(bookmarkRepositoryProvider.future);
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
  return await repository.createFolder(folderName);
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
  return await repository.addBookmark(
    category: category,
    lessonId: lessonId,
    folder: folder,
    bookmarkType: bookmarkType,
  );
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
}

