import 'package:drift/drift.dart';

/// Structured table for application-wide persistent settings.
/// This table works as a singleton, holding all app-state in a single row.
class AppSettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // Fixed ID of 1 for the singleton
  TextColumn get appearanceMode => text().withDefault(const Constant('system'))();
  TextColumn get videoQuality => text().withDefault(const Constant('auto'))();
  BoolColumn get autoPlayNext => boolean().withDefault(const Constant(true))();
  TextColumn get textSize => text().withDefault(const Constant('large'))();
  BoolColumn get highContrast => boolean().withDefault(const Constant(false))();
}
