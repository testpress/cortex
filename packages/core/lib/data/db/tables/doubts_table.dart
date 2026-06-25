import 'package:drift/drift.dart';

/// Drift table for personal doubts.
class DoubtsTable extends Table {
  TextColumn get id => text()();
  IntColumn get topicId => integer().nullable()();
  TextColumn get topicName => text().nullable()();
  TextColumn get lessonId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get content => text()(); // Quill Delta JSON
  TextColumn get studentName => text()();
  TextColumn get studentAvatar => text().nullable()();
  IntColumn get replyCount => integer().nullable()();
  TextColumn get status => text()(); // pending, answered, resolved
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get createdHumanized => text().nullable()();
  TextColumn get attachments => text().nullable()(); // JSON-encoded list
  TextColumn get queryType => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for replies to personal doubts.
class DoubtRepliesTable extends Table {
  TextColumn get id => text()();
  TextColumn get doubtId => text()();
  TextColumn get content => text()(); // Quill Delta JSON
  TextColumn get authorName => text()();
  TextColumn get authorAvatar => text().nullable()();
  BoolColumn get isMentor => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get createdHumanized => text().nullable()();
  TextColumn get attachments => text().nullable()(); // JSON-encoded list
  TextColumn get source => text().nullable()(); // human, ai

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for doubt topics (categories).
class DoubtTopicsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  IntColumn get parentId => integer().nullable()();
  BoolColumn get hasChildren => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
