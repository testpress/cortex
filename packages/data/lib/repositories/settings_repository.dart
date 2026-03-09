import 'package:drift/drift.dart';
import '../db/app_database.dart';

class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository(this._db);

  /// Fetch all settings as a single data object.
  Future<AppSettingsTableData> getSettings() => _db.getAppSettings();

  /// Watch settings for live updates.
  Stream<AppSettingsTableData> watchSettings() => _db.watchAppSettings();

  /// Partial update of settings.
  Future<void> updateSettings({
    String? appearanceMode,
    String? videoQuality,
    bool? autoPlayNext,
    String? textSize,
    bool? highContrast,
  }) {
    return _db.updateSettings(AppSettingsTableCompanion(
      appearanceMode:
          appearanceMode != null ? Value(appearanceMode) : const Value.absent(),
      videoQuality:
          videoQuality != null ? Value(videoQuality) : const Value.absent(),
      autoPlayNext:
          autoPlayNext != null ? Value(autoPlayNext) : const Value.absent(),
      textSize: textSize != null ? Value(textSize) : const Value.absent(),
      highContrast:
          highContrast != null ? Value(highContrast) : const Value.absent(),
    ));
  }
}
