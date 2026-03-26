import 'package:drift/drift.dart';

/// Database table for storing user profile metadata.
class UsersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()(); // Maps to display_name
  TextColumn get username => text().nullable()();
  TextColumn get firstName => text().nullable()();
  TextColumn get lastName => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get avatar => text().nullable()(); // URL string
  DateTimeColumn get joinedDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
