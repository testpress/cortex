import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:core/data/data.dart';
import 'user_repository_test.mocks.dart';

void main() {
  late AppDatabase db;
  late MockMockitoDataSource mockSource;
  late BookmarkRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    mockSource = MockMockitoDataSource();
    repository = BookmarkRepository(db, mockSource);
  });

  tearDown(() async {
    await db.close();
  });

  group('BookmarkRepository', () {
    test(
      'category mapping maps question/post/forumpost case-insensitively',
      () async {
        final mockResponse = BookmarkDto(
          id: 420,
          folderId: 10,
          folderName: 'Math',
          lessonId: 100,
          bookmarkType: 'user_selected_answer',
        );

        when(
          mockSource.createBookmark(
            category: anyNamed('category'),
            lessonId: anyNamed('lessonId'),
            folder: anyNamed('folder'),
            bookmarkType: anyNamed('bookmarkType'),
          ),
        ).thenAnswer((_) async => mockResponse);

        await repository.addBookmark(
          category: 'Question', // maps to user_selected_answer
          lessonId: 100,
          folder: 'Math',
          bookmarkType: 'starred',
        );

        verify(
          mockSource.createBookmark(
            category: 'user_selected_answer', // Verified mapping!
            lessonId: 100,
            folder: 'Math',
            bookmarkType: 'starred',
          ),
        ).called(1);
      },
    );

    test('addBookmark preserves existing local metadata', () async {
      // 1. Seed existing bookmark metadata in DB
      await db
          .into(db.bookmarkItemsTable)
          .insert(
            BookmarkItemsTableCompanion.insert(
              id: const Value(420),
              lessonId: 100,
              title: const Value('My Question Title'),
              chapterName: const Value('Chapter A'),
              bookmarkType: const Value('user_selected_answer'),
            ),
          );

      // 2. Setup mock createBookmark response (does not have title/chapterName)
      final mockResponse = BookmarkDto(
        id: 420,
        folderId: 20,
        folderName: 'Physics',
        lessonId: 100,
        bookmarkType: 'user_selected_answer',
      );

      when(
        mockSource.createBookmark(
          category: anyNamed('category'),
          lessonId: anyNamed('lessonId'),
          folder: anyNamed('folder'),
          bookmarkType: anyNamed('bookmarkType'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // 3. Call repository.addBookmark
      final result = await repository.addBookmark(
        category: 'user_selected_answer',
        lessonId: 100,
        folder: 'Physics',
      );

      // Verify that the title and chapterName are preserved
      expect(result.title, equals('My Question Title'));
      expect(result.chapterName, equals('Chapter A'));

      // Verify db was updated with new folder details while keeping title/chapterName
      final dbRow = await (db.select(
        db.bookmarkItemsTable,
      )..where((tbl) => tbl.id.equals(420))).getSingle();
      expect(dbRow.folderId, equals(20));
      expect(dbRow.folderName, equals('Physics'));
      expect(dbRow.title, equals('My Question Title'));
    });

    test(
      'moveBookmark performs sequence of delete + create and cleans up local database',
      () async {
        // 1. Seed two old bookmarks in Folder A (id: 10)
        await db
            .into(db.bookmarkFoldersTable)
            .insert(
              BookmarkFoldersTableCompanion.insert(
                id: const Value(10),
                name: 'Folder A',
                bookmarksCount: const Value(2),
              ),
            );
        await db
            .into(db.bookmarkFoldersTable)
            .insert(
              BookmarkFoldersTableCompanion.insert(
                id: const Value(20),
                name: 'Folder B',
                bookmarksCount: const Value(0),
              ),
            );

        await db
            .into(db.bookmarkItemsTable)
            .insert(
              BookmarkItemsTableCompanion.insert(
                id: const Value(111),
                folderId: const Value(10),
                folderName: const Value('Folder A'),
                lessonId: 100,
                title: const Value('Lesson Title'),
                chapterName: const Value('Chapter Name'),
                bookmarkType: const Value('user_selected_answer'),
              ),
            );
        await db
            .into(db.bookmarkItemsTable)
            .insert(
              BookmarkItemsTableCompanion.insert(
                id: const Value(222),
                folderId: const Value(10),
                folderName: const Value('Folder A'),
                lessonId: 100,
                title: const Value('Lesson Title'),
                chapterName: const Value('Chapter Name'),
                bookmarkType: const Value('user_selected_answer'),
              ),
            );

        // 2. Setup mock responses
        final newBookmarkResponse = BookmarkDto(
          id: 333,
          folderId: 20,
          folderName: 'Folder B',
          lessonId: 100,
          bookmarkType: 'user_selected_answer',
        );

        when(
          mockSource.createBookmark(
            category: anyNamed('category'),
            lessonId: anyNamed('lessonId'),
            folder: anyNamed('folder'),
            bookmarkType: anyNamed('bookmarkType'),
          ),
        ).thenAnswer((_) async => newBookmarkResponse);

        when(mockSource.deleteBookmark(any)).thenAnswer((_) async => {});

        // 3. Move the bookmark
        await repository.moveBookmark(
          oldBookmarkIds: const [111, 222],
          category: 'user_selected_answer',
          lessonId: 100,
          folder: 'Folder B',
        );

        // 4. Verify API calls are sequenced correctly (create first, then delete)
        verifyInOrder([
          mockSource.createBookmark(
            category: 'user_selected_answer',
            lessonId: 100,
            folder: 'Folder B',
            bookmarkType: anyNamed('bookmarkType'),
          ),
          mockSource.deleteBookmark('111'),
          mockSource.deleteBookmark('222'),
        ]);

        // 5. Verify local DB state: old ones are deleted, new one is inserted
        final remainingBookmarks = await db.select(db.bookmarkItemsTable).get();
        expect(remainingBookmarks.length, equals(1));
        expect(remainingBookmarks.first.id, equals(333));
        expect(remainingBookmarks.first.folderId, equals(20));

        // Verify folder counts: Folder A count decremented by 2 (to 0), Folder B count incremented by 1
        final folderA = await (db.select(
          db.bookmarkFoldersTable,
        )..where((tbl) => tbl.id.equals(10))).getSingle();
        final folderB = await (db.select(
          db.bookmarkFoldersTable,
        )..where((tbl) => tbl.id.equals(20))).getSingle();
        expect(folderA.bookmarksCount, equals(0));
        expect(folderB.bookmarksCount, equals(1));
      },
    );
  });
}
