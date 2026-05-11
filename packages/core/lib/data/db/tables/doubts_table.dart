import 'package:drift/drift.dart';

/// Drift table for personal doubts.
class DoubtsTable extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text().nullable()();
  TextColumn get courseName => text().nullable()();
  TextColumn get lessonId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get content => text()(); // Quill Delta JSON
  TextColumn get studentName => text()();
  TextColumn get studentAvatar => text().nullable()();
  IntColumn get replyCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text()(); // pending, answered, resolved
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get attachments => text().nullable()(); // JSON-encoded list

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
  TextColumn get attachments => text().nullable()(); // JSON-encoded list

  @override
  Set<Column> get primaryKey => {id};
}
