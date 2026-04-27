import 'package:drift/drift.dart';

/// Drift table for discussion forum threads.
class ForumThreadsTable extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get authorName => text()();
  TextColumn get authorAvatar => text().nullable()();
  TextColumn get timeAgo => text()();
  IntColumn get replyCount => integer().withDefault(const Constant(0))();
  IntColumn get upvotes => integer().withDefault(const Constant(0))();
  IntColumn get downvotes => integer().withDefault(const Constant(0))();

  /// Stored as string: 'answered' | 'unanswered'
  TextColumn get status => text()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
