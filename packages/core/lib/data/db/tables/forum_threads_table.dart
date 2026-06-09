import 'package:drift/drift.dart';

/// Drift table for discussion forum threads.
class ForumThreadsTable extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get authorName => text()();
  TextColumn get authorAvatar => text().nullable()();
  TextColumn get createdAt => text()();
  IntColumn get replyCount => integer().withDefault(const Constant(0))();
  IntColumn get upvotes => integer().withDefault(const Constant(0))();
  IntColumn get downvotes => integer().withDefault(const Constant(0))();

  /// Stored as string: 'answered' | 'unanswered'
  IntColumn get threadId => integer().nullable()();

  /// Stored as string: 'answered' | 'unanswered'
  TextColumn get status => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get categorySlug => text().nullable()();
  TextColumn get contentHtml => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for discussion forum comments/replies.
class ForumCommentsTable extends Table {
  TextColumn get id => text()();
  IntColumn get threadId => integer()();
  TextColumn get authorName => text()();
  TextColumn get authorAvatar => text().nullable()();
  TextColumn get content => text()();
  TextColumn get createdAt => text()();
  IntColumn get upvotes => integer().withDefault(const Constant(0))();
  IntColumn get downvotes => integer().withDefault(const Constant(0))();
  BoolColumn get isInstructor => boolean().withDefault(const Constant(false))();
  BoolColumn get isPublic => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
