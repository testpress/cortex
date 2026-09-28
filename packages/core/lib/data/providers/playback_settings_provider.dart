import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:core/data/db/app_database.dart';
import 'package:core/data/db/database_provider.dart';
import 'package:core/data/models/settings_models.dart';
import 'package:core/data/providers/shared_preferences_provider.dart';

part 'playback_settings_provider.g.dart';

/// The active playback settings, owned by core so domain packages (courses,
/// profile) can read and update them without importing each other.
/// See ADR 0005-user-state-in-core.md.
@Riverpod(keepAlive: true)
class PlaybackSettingsNotifier extends _$PlaybackSettingsNotifier {
  static const String _kDismissedPlaybackSpeedPromptKey =
      'has_dismissed_playback_speed';

  @override
  Future<PlaybackSettings> build() async {
    final db = await ref.watch(appDatabaseProvider.future);
    final settings = await db.getAppSettings();
    final prefs = ref.watch(sharedPreferencesProvider);
    final hasDismissed =
        prefs.getBool(_kDismissedPlaybackSpeedPromptKey) ?? false;

    final quality = VideoQuality.values.firstWhere(
      (e) => e.name == settings.videoQuality,
      orElse: () => VideoQuality.auto,
    );

    return PlaybackSettings(
      quality: quality,
      autoPlayNext: settings.autoPlayNext,
      rememberPlaybackSpeed: settings.rememberPlaybackSpeed,
      globalPlaybackSpeed: settings.globalPlaybackSpeed,
      hasDismissedPlaybackSpeedPrompt: hasDismissed,
    );
  }

  Future<void> dismissPlaybackSpeedPrompt() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_kDismissedPlaybackSpeedPromptKey, true);

    final current = await future;
    state = AsyncValue.data(
      current.copyWith(hasDismissedPlaybackSpeedPrompt: true),
    );
  }

  Future<void> updateQuality(VideoQuality quality) async {
    final db = await ref.read(appDatabaseProvider.future);
    await db.updateSettings(
      AppSettingsTableCompanion(videoQuality: Value(quality.name)),
    );

    final current = await future;
    state = AsyncValue.data(current.copyWith(quality: quality));
  }

  Future<void> updateAutoPlay(bool enabled) async {
    final db = await ref.read(appDatabaseProvider.future);
    await db.updateSettings(
      AppSettingsTableCompanion(autoPlayNext: Value(enabled)),
    );

    final current = await future;
    state = AsyncValue.data(current.copyWith(autoPlayNext: enabled));
  }

  Future<void> updateRememberPlaybackSpeed(bool enabled) async {
    final db = await ref.read(appDatabaseProvider.future);
    await db.updateSettings(
      AppSettingsTableCompanion(rememberPlaybackSpeed: Value(enabled)),
    );

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_kDismissedPlaybackSpeedPromptKey);

    final current = await future;
    state = AsyncValue.data(
      current.copyWith(
        rememberPlaybackSpeed: enabled,
        hasDismissedPlaybackSpeedPrompt: false,
      ),
    );
  }

  Future<void> enableRememberPlaybackSpeedAndSave(double speed) async {
    final db = await ref.read(appDatabaseProvider.future);
    await db.updateSettings(
      AppSettingsTableCompanion(
        rememberPlaybackSpeed: const Value(true),
        globalPlaybackSpeed: Value(speed),
      ),
    );

    final current = await future;
    state = AsyncValue.data(
      current.copyWith(rememberPlaybackSpeed: true, globalPlaybackSpeed: speed),
    );
  }

  Future<void> updateGlobalPlaybackSpeed(double speed) async {
    final db = await ref.read(appDatabaseProvider.future);
    await db.updateSettings(
      AppSettingsTableCompanion(globalPlaybackSpeed: Value(speed)),
    );

    final current = await future;
    state = AsyncValue.data(current.copyWith(globalPlaybackSpeed: speed));
  }
}
