import 'package:drift/drift.dart';

/// Drift table for user profile persistence.
class UsersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get avatar => text().nullable()();
  BoolColumn get isPro => boolean().withDefault(const Constant(false))();
  DateTimeColumn get joinedDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
