import 'package:drift/drift.dart';

/// Drift table for courses.
class CoursesTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get colorIndex => integer()();
  IntColumn get chapterCount => integer()();
  TextColumn get totalDuration => text()();
  IntColumn get totalContents => integer().withDefault(const Constant(0))();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  IntColumn get completedLessons => integer().withDefault(const Constant(0))();
  IntColumn get totalLessons => integer()();
  TextColumn get image => text().nullable()();
  TextColumn get tags => text().nullable()();
  TextColumn get allowedDevices => text().nullable()();
  TextColumn get tagIds => text().nullable()();
  IntColumn get examsCount => integer().withDefault(const Constant(0))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isChaptersSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
