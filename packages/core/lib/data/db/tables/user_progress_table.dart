import 'package:drift/drift.dart';

/// Drift table for per-lesson user progress.
class UserProgressTable extends Table {
  TextColumn get userId => text()();
  TextColumn get lessonId => text()();
  TextColumn get courseId => text()();
  IntColumn get percentComplete => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAccessedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId, lessonId};
}
