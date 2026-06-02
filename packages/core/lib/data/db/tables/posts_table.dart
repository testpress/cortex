import 'package:drift/drift.dart';

@DataClassName('PostCategoryData')
class PostCategoriesTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get displayOrder => integer()();
  TextColumn get color => text()();
  TextColumn get slug => text()();
  BoolColumn get isStarred => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PostData')
class PostsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get slug => text()();
  TextColumn get title => text()();
  IntColumn get categoryId => integer().nullable()();
  TextColumn get categoryName => text().nullable()();
  TextColumn get shortLink => text()();
  TextColumn get summary => text()();
  TextColumn get contentHtml => text()();
  TextColumn get coverImage => text().nullable()();
  TextColumn get publishedDate => text()();
  TextColumn get webUrl => text().nullable()();
  BoolColumn get allowComments => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
