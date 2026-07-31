import 'package:drift/drift.dart';
import 'package:core/data/data.dart';

/// Structured table for application-wide persistent settings.
/// This table works as a singleton, holding all app-state in a single row.
class AppSettingsTable extends Table {
  IntColumn get id => integer()();

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get appearanceMode =>
      text().withDefault(const Constant(AppSettingsDefaults.appearanceMode))();
  TextColumn get videoQuality =>
      text().withDefault(const Constant(AppSettingsDefaults.videoQuality))();
  BoolColumn get autoPlayNext =>
      boolean().withDefault(const Constant(AppSettingsDefaults.autoPlayNext))();
  TextColumn get textSize =>
      text().withDefault(const Constant(AppSettingsDefaults.textSize))();
  BoolColumn get highContrast =>
      boolean().withDefault(const Constant(AppSettingsDefaults.highContrast))();
  TextColumn get appLanguage =>
      text().withDefault(const Constant(AppSettingsDefaults.appLanguage))();

  BoolColumn get rememberPlaybackSpeed => boolean().withDefault(
    const Constant(AppSettingsDefaults.rememberPlaybackSpeed),
  )();

  /// Last-used global playback speed (e.g. 2.0). Null when not set.
  RealColumn get globalPlaybackSpeed => real().nullable()();

  /// JSON-encoded map of attemptId → true for quiz-mode attempts.
  /// Used to restore quiz mode on resume when the backend drops `attempt_type`.
  TextColumn get quizModeAttemptsJson => text().nullable()();
}
