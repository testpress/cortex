import 'package:drift/drift.dart';

/// Drift table for courses.
class CoursesTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get colorIndex => integer()();
  IntColumn get chapterCount => integer()();
  IntColumn get totalContents => integer().withDefault(const Constant(0))();
  RealColumn get progress => real().withDefault(const Constant(0.0))();
  IntColumn get completedLessons => integer().withDefault(const Constant(0))();
  TextColumn get image => text().nullable()();
  TextColumn get tags => text().nullable()();
  TextColumn get allowedDevices => text().nullable()();
  IntColumn get examsCount => integer().withDefault(const Constant(0))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isChaptersSynced =>
      boolean().withDefault(const Constant(false))();

  /// SSO enrollment URL when a course requires external registration.
  /// Null when the course is fully approved and accessible.
  TextColumn get externalContentLink => text().nullable()();

  /// Button label text (e.g. "REQUEST PACKAGE", "Pending Approval").
  TextColumn get externalLinkLabel => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
