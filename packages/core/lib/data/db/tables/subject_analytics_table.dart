import 'package:drift/drift.dart';

@DataClassName('SubjectAnalyticsData')
class SubjectAnalyticsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get total => integer()();
  IntColumn get correct => integer()();
  IntColumn get incorrect => integer()();
  IntColumn get unanswered => integer()();
  RealColumn get correctPercentage => real()();
  IntColumn get parent => integer().nullable()();
  BoolColumn get leaf => boolean().withDefault(const Constant(true))();
  TextColumn get analyticsUrl => text()();

  @override
  Set<Column> get primaryKey => {id};
}
