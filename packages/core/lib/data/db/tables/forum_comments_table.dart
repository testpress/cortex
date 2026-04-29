import 'package:drift/drift.dart';

/// Drift table for discussion forum comments/replies.
class ForumCommentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get threadId => text()();
  TextColumn get authorName => text()();
  TextColumn get authorAvatar => text().nullable()();
  TextColumn get content => text()();
  TextColumn get timeAgo => text()();
  IntColumn get upvotes => integer().withDefault(const Constant(0))();
  IntColumn get downvotes => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
