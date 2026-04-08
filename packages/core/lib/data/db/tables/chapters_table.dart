import 'package:drift/drift.dart';

/// Drift table for chapters, belonging to a course.
class ChaptersTable extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text()();
  TextColumn get title => text()();
  IntColumn get lessonCount => integer()();
  IntColumn get assessmentCount => integer()();
  IntColumn get orderIndex => integer()();
  TextColumn get parentId => text().nullable()();
  BoolColumn get isLeaf => boolean().withDefault(const Constant(true))();
  TextColumn get image => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
