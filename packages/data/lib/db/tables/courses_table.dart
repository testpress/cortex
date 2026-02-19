import 'package:drift/drift.dart';

/// Drift table for courses.
class CoursesTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get subjectColor => text()();
  IntColumn get chapterCount => integer()();
  TextColumn get totalDuration => text()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  IntColumn get completedLessons => integer().withDefault(const Constant(0))();
  IntColumn get totalLessons => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
