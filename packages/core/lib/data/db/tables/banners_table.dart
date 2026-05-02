import 'package:drift/drift.dart';

class DashboardBannersTable extends Table {
  TextColumn get id => text()();
  TextColumn get imageUrl => text()();
  TextColumn get title => text().nullable()();
  TextColumn get link => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get bgColor => integer().nullable()();
  IntColumn get textColor => integer().nullable()();
  TextColumn get tag => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
