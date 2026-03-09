import 'package:drift/drift.dart';
import '../../models/settings_models.dart';

/// Structured table for application-wide persistent settings.
/// This table works as a singleton, holding all app-state in a single row.
class AppSettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // Fixed ID of 1 for the singleton
  TextColumn get appearanceMode => text().withDefault(const Constant(AppSettingsDefaults.appearanceMode))();
  TextColumn get videoQuality => text().withDefault(const Constant(AppSettingsDefaults.videoQuality))();
  BoolColumn get autoPlayNext => boolean().withDefault(const Constant(AppSettingsDefaults.autoPlayNext))();
  TextColumn get textSize => text().withDefault(const Constant(AppSettingsDefaults.textSize))();
  BoolColumn get highContrast => boolean().withDefault(const Constant(AppSettingsDefaults.highContrast))();
}
