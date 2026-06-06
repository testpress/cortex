import 'package:drift/drift.dart';

class BookmarkFoldersTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get bookmarksCount => integer().withDefault(const Constant(0))();
  IntColumn get userId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class BookmarkItemsTable extends Table {
  IntColumn get id => integer()();
  IntColumn get folderId => integer()
      .nullable()
      .references(BookmarkFoldersTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get folderName => text().nullable()();
  IntColumn get lessonId => integer()();
  TextColumn get bookmarkType => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get chapterName => text().nullable()();
  TextColumn get slug => text().nullable()();
  BoolColumn get isForumPost => boolean().withDefault(const Constant(false))();
  DateTimeColumn get created => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
