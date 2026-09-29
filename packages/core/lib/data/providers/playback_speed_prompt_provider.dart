import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:core/data/providers/shared_preferences_provider.dart';

part 'playback_speed_prompt_provider.g.dart';

/// Provider managing whether the user has dismissed the in-player
/// "Remember playback speed" prompt.
@Riverpod(keepAlive: true)
class PlaybackSpeedPromptDismissed extends _$PlaybackSpeedPromptDismissed {
  static const String _kDismissedPlaybackSpeedPromptKey =
      'has_dismissed_playback_speed';

  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(_kDismissedPlaybackSpeedPromptKey) ?? false;
  }

  Future<void> dismiss() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_kDismissedPlaybackSpeedPromptKey, true);
    state = true;
  }

  Future<void> reset() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_kDismissedPlaybackSpeedPromptKey);
    state = false;
  }
}
