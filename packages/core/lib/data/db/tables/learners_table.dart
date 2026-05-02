import 'package:drift/drift.dart';

@DataClassName('LearnersTableData')
class LearnersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get avatar => text()();
  RealColumn get points => real()();
  IntColumn get rank => integer()();
  IntColumn get coursesCompleted => integer().withDefault(const Constant(0))();
  IntColumn get streakDays => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
