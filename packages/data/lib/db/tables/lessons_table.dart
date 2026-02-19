import 'package:drift/drift.dart';

/// Drift table for lessons inside a chapter.
class LessonsTable extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId => text()();
  TextColumn get title => text()();

  /// Stored as string: 'video' | 'pdf' | 'assessment' | 'test'
  TextColumn get type => text()();
  TextColumn get duration => text()();

  /// Stored as string: 'notStarted' | 'inProgress' | 'completed'
  TextColumn get progressStatus =>
      text().withDefault(const Constant('notStarted'))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
