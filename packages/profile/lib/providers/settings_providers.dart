import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/settings_repository.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
Future<SettingsRepository> settingsRepository(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return SettingsRepository(db);
}

@Riverpod(keepAlive: true)
class AppearanceSettingsNotifier extends _$AppearanceSettingsNotifier {
  @override
  Future<AppearanceSettings> build() async {
    final repository = await ref.watch(settingsRepositoryProvider.future);
    final settings = await repository.getSettings();

    final mode = DesignMode.values.firstWhere(
      (e) => e.name == settings.appearanceMode,
      orElse: () => DesignMode.system,
    );
    return AppearanceSettings(mode: mode);
  }

  Future<void> updateMode(DesignMode mode) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    await repository.updateSettings(appearanceMode: mode.name);
    state = AsyncValue.data(AppearanceSettings(mode: mode));
  }
}

@Riverpod(keepAlive: true)
class PlaybackSettingsNotifier extends _$PlaybackSettingsNotifier {
  @override
  Future<PlaybackSettings> build() async {
    final repository = await ref.watch(settingsRepositoryProvider.future);
    final settings = await repository.getSettings();

    final quality = VideoQuality.values.firstWhere(
      (e) => e.name == settings.videoQuality,
      orElse: () => VideoQuality.auto,
    );

    return PlaybackSettings(
      quality: quality,
      autoPlayNext: settings.autoPlayNext,
    );
  }

  Future<void> updateQuality(VideoQuality quality) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    await repository.updateSettings(videoQuality: quality.name);

    final current = await future;
    state = AsyncValue.data(current.copyWith(quality: quality));
  }

  Future<void> updateAutoPlay(bool enabled) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    await repository.updateSettings(autoPlayNext: enabled);

    final current = await future;
    state = AsyncValue.data(current.copyWith(autoPlayNext: enabled));
  }
}

@Riverpod(keepAlive: true)
class AccessibilitySettingsNotifier extends _$AccessibilitySettingsNotifier {
  @override
  Future<AccessibilitySettings> build() async {
    final repository = await ref.watch(settingsRepositoryProvider.future);
    final settings = await repository.getSettings();

    final textScale = TextScaleSize.values.firstWhere(
      (e) => e.name == settings.textSize,
      orElse: () => TextScaleSize.large,
    );

    return AccessibilitySettings(
      textScale: textScale,
      highContrast: settings.highContrast,
    );
  }

  Future<void> updateTextScale(TextScaleSize size) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    await repository.updateSettings(textSize: size.name);

    final current = await future;
    state = AsyncValue.data(current.copyWith(textScale: size));
  }

  Future<void> updateHighContrast(bool enabled) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    await repository.updateSettings(highContrast: enabled);

    final current = await future;
    state = AsyncValue.data(current.copyWith(highContrast: enabled));
  }
}
