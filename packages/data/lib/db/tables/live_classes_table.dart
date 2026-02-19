import 'package:drift/drift.dart';

/// Drift table for live class sessions.
class LiveClassesTable extends Table {
  TextColumn get id => text()();
  TextColumn get subject => text()();
  TextColumn get topic => text()();
  TextColumn get time => text()();
  TextColumn get faculty => text()();

  /// Stored as string: 'completed' | 'live' | 'upcoming'
  TextColumn get status => text()();

  @override
  Set<Column> get primaryKey => {id};
}
