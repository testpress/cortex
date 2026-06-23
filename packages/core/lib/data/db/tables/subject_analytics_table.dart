import 'package:drift/drift.dart';

@DataClassName('SubjectAnalyticsData')
class SubjectAnalyticsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get totalQuestionCount => integer()();
  IntColumn get correctAnswerCount => integer()();
  IntColumn get incorrectAnswerCount => integer()();
  IntColumn get unansweredCount => integer()();
  RealColumn get correctPercentage => real()();
  IntColumn get parentId => integer().nullable()();
  BoolColumn get isLeaf => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
