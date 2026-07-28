import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../models/bookmark_dto.dart';
import '../models/paginated_response_dto.dart';
import '../sources/data_source.dart';

class BookmarkRepository {
  final AppDatabase _db;
  final DataSource _dataSource;

  BookmarkRepository(this._db, this._dataSource);

  /// Watches all bookmark folders from the local database.
  Stream<List<BookmarkFolderDto>> watchBookmarkFolders() {
    return _db.select(_db.bookmarkFoldersTable).watch().map((rows) {
      return rows
          .map(
            (row) => BookmarkFolderDto(
              id: row.id,
              name: row.name,
              bookmarksCount: row.bookmarksCount,
              userId: row.userId,
            ),
          )
          .toList();
    });
  }

  /// Watches all individual bookmark items from the local database.
  Stream<List<BookmarkDto>> watchBookmarks() {
    return (_db.select(_db.bookmarkItemsTable)..orderBy([
          (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
        ]))
        .watch()
        .map((rows) {
          return rows
              .map(
                (row) => BookmarkDto(
                  id: row.id,
                  folderId: row.folderId,
                  folderName: row.folderName,
                  lessonId: row.lessonId,
                  bookmarkType: row.bookmarkType,
                  title: row.title ?? '',
                  chapterName: row.chapterName ?? '',
                  slug: row.slug,
                  isForumPost: row.isForumPost,
                  created: row.created,
                  attemptId: row.attemptId,
                ),
              )
              .toList();
        });
  }

  /// Watches bookmarks for a specific lesson from the local database.
  Stream<List<BookmarkDto>> watchBookmarksForLesson(int lessonId) {
    return (_db.select(
      _db.bookmarkItemsTable,
    )..where((tbl) => tbl.lessonId.equals(lessonId))).watch().map((rows) {
      return rows
          .map(
            (row) => BookmarkDto(
              id: row.id,
              folderId: row.folderId,
              folderName: row.folderName,
              lessonId: row.lessonId,
              bookmarkType: row.bookmarkType,
              title: row.title ?? '',
              chapterName: row.chapterName ?? '',
              slug: row.slug,
              isForumPost: row.isForumPost,
              created: row.created,
              attemptId: row.attemptId,
            ),
          )
          .toList();
    });
  }

  /// Watches bookmarks with filters applied from the local database.
  Stream<List<BookmarkDto>> watchBookmarksWithFilter({
    String? folder,
    String? order,
    String? filter,
  }) {
    final query = _db.select(_db.bookmarkItemsTable);

    if (folder == 'uncategorized') {
      query.where((tbl) => tbl.folderId.isNull());
    } else if (folder != null) {
      query.where((tbl) => tbl.folderName.equals(folder));
    }

    if (filter != null) {
      if (filter == 'video') {
        query.where(
          (tbl) =>
              tbl.bookmarkType.equals('video') |
              tbl.bookmarkType.equals('livestream'),
        );
      } else if (filter == 'attachment') {
        query.where(
          (tbl) =>
              tbl.bookmarkType.equals('attachment') |
              tbl.bookmarkType.equals('pdf'),
        );
      } else {
        query.where((tbl) => tbl.bookmarkType.equals(filter));
      }
    }

    if (order == 'created') {
      query.orderBy([
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
      ]);
    } else if (order == '-modified') {
      query.orderBy([
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]);
    } else {
      query.orderBy([
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]);
    }

    return query.watch().map((rows) {
      return rows
          .map(
            (row) => BookmarkDto(
              id: row.id,
              folderId: row.folderId,
              folderName: row.folderName,
              lessonId: row.lessonId,
              bookmarkType: row.bookmarkType,
              title: row.title ?? '',
              chapterName: row.chapterName ?? '',
              slug: row.slug,
              isForumPost: row.isForumPost,
              created: row.created,
              attemptId: row.attemptId,
            ),
          )
          .toList();
    });
  }

  /// Fetch a paginated list of bookmarks from the remote source.
  Future<PaginatedResponseDto<BookmarkDto>> fetchBookmarks({
    int page = 1,
    String? folder,
    String? order,
    String? filter,
    bool clearCache = false,
  }) async {
    final response = await _dataSource.getBookmarks(
      page: page,
      folder: folder,
      order: order,
      filter: filter,
    );

    await _db.transaction(() async {
      // Clear stale cache if explicitly requested (pull-to-refresh) OR if we know this page has all remaining items (total < 20).
      if (page == 1 && (clearCache || response.next == null)) {
        final deleteQuery = _db.delete(_db.bookmarkItemsTable);

        if (folder == 'uncategorized') {
          deleteQuery.where((tbl) => tbl.folderId.isNull());
        } else if (folder != null) {
          deleteQuery.where((tbl) => tbl.folderName.equals(folder));
        }

        if (filter != null) {
          if (filter == 'video') {
            deleteQuery.where(
              (tbl) =>
                  tbl.bookmarkType.equals('video') |
                  tbl.bookmarkType.equals('livestream'),
            );
          } else if (filter == 'attachment') {
            deleteQuery.where(
              (tbl) =>
                  tbl.bookmarkType.equals('attachment') |
                  tbl.bookmarkType.equals('pdf'),
            );
          } else {
            deleteQuery.where((tbl) => tbl.bookmarkType.equals(filter));
          }
        }
        await deleteQuery.go();
      }

      if (response.results.isNotEmpty) {
        // Build folder name map from local DB so we can accurately save folder names
        // for items that only come with folder_id from the backend.
        final folderIds = response.results
            .map((b) => b.folderId)
            .whereType<int>()
            .toSet();

        final folderNameMap = <int, String>{};
        if (folderIds.isNotEmpty) {
          final folders = await (_db.select(
            _db.bookmarkFoldersTable,
          )..where((t) => t.id.isIn(folderIds))).get();
          for (final f in folders) {
            folderNameMap[f.id] = f.name;
          }
        }

        await _db.batch((batch) {
          batch.insertAll(
            _db.bookmarkItemsTable,
            response.results.map((b) {
              final computedFolderName =
                  b.folderName ??
                  folderNameMap[b.folderId] ??
                  (folder != 'uncategorized' ? folder : null);
              return BookmarkItemsTableCompanion.insert(
                id: Value(b.id),
                folderId: Value(b.folderId),
                folderName: Value(computedFolderName),
                lessonId: b.lessonId,
                bookmarkType: Value(b.type),
                title: Value(b.title),
                chapterName: Value(b.chapterName),
                slug: Value(b.slug),
                isForumPost: Value(b.isForumPost),
                created: Value(b.created),
                attemptId: Value(b.attemptId),
              );
            }).toList(),
            mode: InsertMode.insertOrReplace,
          );
        });
      }
    });

    return response;
  }

  /// Fetch all folders from the remote source and refresh the local cache.
  Future<void> refreshFolders() async {
    final folders = await _dataSource.getBookmarkFolders();
    await _db.transaction(() async {
      await _db.delete(_db.bookmarkFoldersTable).go();
      if (folders.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAll(
            _db.bookmarkFoldersTable,
            folders
                .map(
                  (f) => BookmarkFoldersTableCompanion.insert(
                    id: Value(f.id),
                    name: f.name,
                    bookmarksCount: Value(f.bookmarksCount),
                    userId: Value(f.userId),
                  ),
                )
                .toList(),
          );
        });
      }
    });
  }

  /// Create a new bookmark folder and save it to the local cache.
  Future<BookmarkFolderDto> createFolder(String name) async {
    final newFolder = await _dataSource.createBookmarkFolder(name);
    await _db
        .into(_db.bookmarkFoldersTable)
        .insertOnConflictUpdate(
          BookmarkFoldersTableCompanion.insert(
            id: Value(newFolder.id),
            name: newFolder.name,
            bookmarksCount: Value(newFolder.bookmarksCount),
            userId: Value(newFolder.userId),
          ),
        );
    return newFolder;
  }

  /// Update an existing bookmark folder and save it to the local cache.
  Future<BookmarkFolderDto> updateFolder(int id, String name) async {
    final updatedFolder = await _dataSource.updateBookmarkFolder(id, name);
    await _db
        .into(_db.bookmarkFoldersTable)
        .insertOnConflictUpdate(
          BookmarkFoldersTableCompanion.insert(
            id: Value(updatedFolder.id),
            name: updatedFolder.name,
            bookmarksCount: Value(updatedFolder.bookmarksCount),
            userId: Value(updatedFolder.userId),
          ),
        );
    return updatedFolder;
  }

  /// Delete an existing bookmark folder.
  Future<void> deleteFolder(int id) async {
    await _dataSource.deleteBookmarkFolder(id);
    await _db.transaction(() async {
      await (_db.delete(
        _db.bookmarkFoldersTable,
      )..where((tbl) => tbl.id.equals(id))).go();
      // If we need to cascade delete or set bookmark.folderId to null, we could do it here
      // But for now, just deleting the folder from local cache is fine.
    });
  }

  Future<BookmarkDto> addBookmark({
    required String category,
    required int lessonId,
    String? folder,
    String? bookmarkType,
    int? attemptId,
    String? title,
    String? chapterName,
  }) async {
    final backendCategory = _mapToBackendCategory(category);
    final newBookmark = await _dataSource.createBookmark(
      category: backendCategory,
      lessonId: lessonId,
      folder: folder,
      bookmarkType: bookmarkType,
    );

    // Fetch existing local metadata if it exists to preserve title, chapterName, etc.
    // We order by id.desc() for determinism. Since title/chapterName are identical
    // for the same lesson across all folders, any match is sufficient.
    final existingLocal =
        await (_db.select(_db.bookmarkItemsTable)
              ..where((tbl) => tbl.lessonId.equals(lessonId))
              ..orderBy([
                (tbl) =>
                    OrderingTerm(expression: tbl.id, mode: OrderingMode.desc),
              ])
              ..limit(1))
            .getSingleOrNull();

    String? localTitle = title ?? existingLocal?.title;
    String? localChapterName = chapterName ?? existingLocal?.chapterName;
    String? localSlug = existingLocal?.slug;
    bool localIsForumPost = existingLocal?.isForumPost ?? false;
    DateTime? localCreated = existingLocal?.created;

    // Fallback to lessonsTable if it's a new lesson bookmark
    if (localTitle == null) {
      final lessonRow =
          await (_db.select(_db.lessonsTable)
                ..where((tbl) => tbl.id.equals(lessonId.toString()))
                ..limit(1))
              .getSingleOrNull();
      if (lessonRow != null) {
        localTitle = lessonRow.title;
        localChapterName = lessonRow.chapterTitle;
      }
    }

    await _db.transaction(() async {
      final otherLocalBookmarks =
          await (_db.select(_db.bookmarkItemsTable)..where(
                (tbl) =>
                    tbl.lessonId.equals(lessonId) &
                    tbl.id.equals(newBookmark.id).not(),
              ))
              .get();

      // 1. Delete other local bookmarks for this lesson to prevent duplication
      for (final ob in otherLocalBookmarks) {
        await (_db.delete(
          _db.bookmarkItemsTable,
        )..where((tbl) => tbl.id.equals(ob.id))).go();

        // Decrement their folder count
        if (ob.folderId != null) {
          final folderRow = await (_db.select(
            _db.bookmarkFoldersTable,
          )..where((tbl) => tbl.id.equals(ob.folderId!))).getSingleOrNull();
          if (folderRow != null) {
            await (_db.update(
              _db.bookmarkFoldersTable,
            )..where((tbl) => tbl.id.equals(ob.folderId!))).write(
              BookmarkFoldersTableCompanion(
                bookmarksCount: Value(
                  (folderRow.bookmarksCount - 1).clamp(0, 999999),
                ),
              ),
            );
          }
        }
      }

      // 2. Insert bookmark item locally
      await _db
          .into(_db.bookmarkItemsTable)
          .insertOnConflictUpdate(
            BookmarkItemsTableCompanion.insert(
              id: Value(newBookmark.id),
              folderId: Value(newBookmark.folderId),
              folderName: Value(newBookmark.folderName),
              lessonId: newBookmark.lessonId,
              bookmarkType: Value(bookmarkType ?? category),
              attemptId: Value(attemptId),
              title: Value(localTitle),
              chapterName: Value(localChapterName),
              slug: Value(localSlug),
              isForumPost: Value(localIsForumPost),
              created: Value(localCreated ?? DateTime.now()),
            ),
          );

      // 3. Link bookmarkId in LessonsTable
      await (_db.update(_db.lessonsTable)
            ..where((tbl) => tbl.id.equals(lessonId.toString())))
          .write(LessonsTableCompanion(bookmarkId: Value(newBookmark.id)));

      // 4. Increment folder bookmark count locally if folderId exists
      if (newBookmark.folderId != null) {
        final folderRow =
            await (_db.select(_db.bookmarkFoldersTable)
                  ..where((tbl) => tbl.id.equals(newBookmark.folderId!)))
                .getSingleOrNull();
        if (folderRow != null) {
          await (_db.update(
            _db.bookmarkFoldersTable,
          )..where((tbl) => tbl.id.equals(newBookmark.folderId!))).write(
            BookmarkFoldersTableCompanion(
              bookmarksCount: Value(folderRow.bookmarksCount + 1),
            ),
          );
        }
      }
    });

    return BookmarkDto(
      id: newBookmark.id,
      folderId: newBookmark.folderId,
      folderName: newBookmark.folderName,
      lessonId: newBookmark.lessonId,
      bookmarkType: bookmarkType ?? category,
      type: category,
      title: localTitle ?? '',
      chapterName: localChapterName ?? '',
      slug: localSlug,
      isForumPost: localIsForumPost,
      created: localCreated ?? DateTime.now(),
      attemptId: attemptId,
    );
  }

  /// Move an existing bookmark to a new folder, executing network requests
  /// and local database updates atomically to prevent UI list flickering.
  Future<BookmarkDto> moveBookmark({
    required int oldBookmarkId,
    required String category,
    required int lessonId,
    String? folder,
    String? bookmarkType,
    int? attemptId,
    String? title,
    String? chapterName,
  }) async {
    final backendCategory = _mapToBackendCategory(category);

    final results = await Future.wait([
      _dataSource.deleteBookmark(oldBookmarkId.toString()),
      _dataSource.createBookmark(
        category: backendCategory,
        lessonId: lessonId,
        folder: folder,
        bookmarkType: bookmarkType,
      ),
    ]);

    final newBookmark = results[1] as BookmarkDto;

    // Fetch existing local metadata if it exists to preserve title, chapterName, etc.
    final existingLocal =
        await (_db.select(_db.bookmarkItemsTable)
              ..where((tbl) => tbl.lessonId.equals(lessonId))
              ..orderBy([
                (tbl) =>
                    OrderingTerm(expression: tbl.id, mode: OrderingMode.desc),
              ])
              ..limit(1))
            .getSingleOrNull();

    String? localTitle = title ?? existingLocal?.title;
    String? localChapterName = chapterName ?? existingLocal?.chapterName;
    String? localSlug = existingLocal?.slug;
    bool localIsForumPost = existingLocal?.isForumPost ?? false;
    DateTime? localCreated = existingLocal?.created;

    if (localTitle == null) {
      final lessonRow =
          await (_db.select(_db.lessonsTable)
                ..where((tbl) => tbl.id.equals(lessonId.toString()))
                ..limit(1))
              .getSingleOrNull();
      if (lessonRow != null) {
        localTitle = lessonRow.title;
        localChapterName = lessonRow.chapterTitle;
      }
    }

    await _db.transaction(() async {
      // Find the old bookmark's folder to update its count
      final oldItem = await (_db.select(
        _db.bookmarkItemsTable,
      )..where((tbl) => tbl.id.equals(oldBookmarkId))).getSingleOrNull();

      // Decrement old folder count
      if (oldItem != null && oldItem.folderId != null) {
        final folderRow = await (_db.select(
          _db.bookmarkFoldersTable,
        )..where((tbl) => tbl.id.equals(oldItem.folderId!))).getSingleOrNull();
        if (folderRow != null) {
          await (_db.update(
            _db.bookmarkFoldersTable,
          )..where((tbl) => tbl.id.equals(oldItem.folderId!))).write(
            BookmarkFoldersTableCompanion(
              bookmarksCount: Value(
                (folderRow.bookmarksCount - 1).clamp(0, 999999),
              ),
            ),
          );
        }
      }

      // 2. Delete old bookmark locally
      await (_db.delete(
        _db.bookmarkItemsTable,
      )..where((tbl) => tbl.id.equals(oldBookmarkId))).go();

      // 3. Delete any other duplicate local bookmarks for this lesson to prevent duplication
      final otherLocalBookmarks =
          await (_db.select(_db.bookmarkItemsTable)..where(
                (tbl) =>
                    tbl.lessonId.equals(lessonId) &
                    tbl.id.equals(newBookmark.id).not(),
              ))
              .get();

      for (final ob in otherLocalBookmarks) {
        await (_db.delete(
          _db.bookmarkItemsTable,
        )..where((tbl) => tbl.id.equals(ob.id))).go();
        if (ob.folderId != null) {
          final folderRow = await (_db.select(
            _db.bookmarkFoldersTable,
          )..where((tbl) => tbl.id.equals(ob.folderId!))).getSingleOrNull();
          if (folderRow != null) {
            await (_db.update(
              _db.bookmarkFoldersTable,
            )..where((tbl) => tbl.id.equals(ob.folderId!))).write(
              BookmarkFoldersTableCompanion(
                bookmarksCount: Value(
                  (folderRow.bookmarksCount - 1).clamp(0, 999999),
                ),
              ),
            );
          }
        }
      }

      // 4. Insert new bookmark item locally
      await _db
          .into(_db.bookmarkItemsTable)
          .insertOnConflictUpdate(
            BookmarkItemsTableCompanion.insert(
              id: Value(newBookmark.id),
              folderId: Value(newBookmark.folderId),
              folderName: Value(newBookmark.folderName),
              lessonId: newBookmark.lessonId,
              bookmarkType: Value(bookmarkType ?? category),
              attemptId: Value(attemptId),
              title: Value(localTitle),
              chapterName: Value(localChapterName),
              slug: Value(localSlug),
              isForumPost: Value(localIsForumPost),
              created: Value(localCreated ?? DateTime.now()),
            ),
          );

      // 5. Link bookmarkId in LessonsTable
      await (_db.update(_db.lessonsTable)
            ..where((tbl) => tbl.id.equals(lessonId.toString())))
          .write(LessonsTableCompanion(bookmarkId: Value(newBookmark.id)));

      // 6. Increment folder bookmark count locally if folderId exists
      if (newBookmark.folderId != null) {
        final folderRow =
            await (_db.select(_db.bookmarkFoldersTable)
                  ..where((tbl) => tbl.id.equals(newBookmark.folderId!)))
                .getSingleOrNull();
        if (folderRow != null) {
          await (_db.update(
            _db.bookmarkFoldersTable,
          )..where((tbl) => tbl.id.equals(newBookmark.folderId!))).write(
            BookmarkFoldersTableCompanion(
              bookmarksCount: Value(folderRow.bookmarksCount + 1),
            ),
          );
        }
      }
    });

    return BookmarkDto(
      id: newBookmark.id,
      folderId: newBookmark.folderId,
      folderName: newBookmark.folderName,
      lessonId: newBookmark.lessonId,
      bookmarkType: bookmarkType ?? category,
      type: category,
      title: localTitle ?? '',
      chapterName: localChapterName ?? '',
      slug: localSlug,
      isForumPost: localIsForumPost,
      created: localCreated ?? DateTime.now(),
      attemptId: attemptId,
    );
  }

  /// Delete a bookmark by its server ID and remove/update local database references.
  Future<void> removeBookmark(int bookmarkId, int lessonId) async {
    await _dataSource.deleteBookmark(bookmarkId.toString());

    await _db.transaction(() async {
      // 1. Find bookmark item before deletion to get the associated folder ID
      final item = await (_db.select(
        _db.bookmarkItemsTable,
      )..where((tbl) => tbl.id.equals(bookmarkId))).getSingleOrNull();

      // 2. Delete bookmark item
      await (_db.delete(
        _db.bookmarkItemsTable,
      )..where((tbl) => tbl.id.equals(bookmarkId))).go();

      // 3. Update lesson's bookmarkId reference
      final lesson = await (_db.select(
        _db.lessonsTable,
      )..where((tbl) => tbl.id.equals(lessonId.toString()))).getSingleOrNull();
      if (lesson != null && lesson.bookmarkId == bookmarkId) {
        final otherBookmarks = await (_db.select(
          _db.bookmarkItemsTable,
        )..where((tbl) => tbl.lessonId.equals(lessonId))).get();
        final newBookmarkId = otherBookmarks.isNotEmpty
            ? otherBookmarks.first.id
            : null;

        await (_db.update(_db.lessonsTable)
              ..where((tbl) => tbl.id.equals(lessonId.toString())))
            .write(LessonsTableCompanion(bookmarkId: Value(newBookmarkId)));
      }

      // 4. Decrement folder bookmark count locally if folderId exists
      if (item != null && item.folderId != null) {
        final folderRow = await (_db.select(
          _db.bookmarkFoldersTable,
        )..where((tbl) => tbl.id.equals(item.folderId!))).getSingleOrNull();
        if (folderRow != null) {
          final newCount = (folderRow.bookmarksCount - 1).clamp(0, 999999);
          await (_db.update(
            _db.bookmarkFoldersTable,
          )..where((tbl) => tbl.id.equals(item.folderId!))).write(
            BookmarkFoldersTableCompanion(bookmarksCount: Value(newCount)),
          );
        }
      }
    });
  }

  String _mapToBackendCategory(String category) {
    switch (category.toLowerCase()) {
      case 'video':
      case 'livestream':
        return 'video';
      case 'pdf':
      case 'attachment':
        return 'attachment';
      case 'notes':
      case 'embedcontent':
        return 'html';
      case 'question':
      case 'user_selected_answer':
        return 'user_selected_answer';
      case 'post':
      case 'forumpost':
        return 'post';
      default:
        return category;
    }
  }
}
