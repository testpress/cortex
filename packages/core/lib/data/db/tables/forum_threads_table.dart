import 'package:drift/drift.dart';

/// Drift table for discussion forum threads.
class ForumThreadsTable extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get studentName => text()();
  TextColumn get timeAgo => text()();
  IntColumn get replyCount => integer().withDefault(const Constant(0))();

  /// Stored as string: 'answered' | 'unanswered'
  TextColumn get status => text()();

  @override
  Set<Column> get primaryKey => {id};
}
