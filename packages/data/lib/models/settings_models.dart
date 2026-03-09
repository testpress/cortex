import 'package:core/core.dart';

enum VideoQuality { auto, high, medium, low }
enum TextScaleSize { small, medium, large }

class AppearanceSettings {
  final DesignMode mode;
  AppearanceSettings({required this.mode});

  AppearanceSettings copyWith({DesignMode? mode}) {
    return AppearanceSettings(mode: mode ?? this.mode);
  }
}

class PlaybackSettings {
  final VideoQuality quality;
  final bool autoPlayNext;
  PlaybackSettings({required this.quality, required this.autoPlayNext});

  PlaybackSettings copyWith({VideoQuality? quality, bool? autoPlayNext}) {
    return PlaybackSettings(
      quality: quality ?? this.quality,
      autoPlayNext: autoPlayNext ?? this.autoPlayNext,
    );
  }
}

class AccessibilitySettings {
  final TextScaleSize textScale;
  final bool highContrast;
  AccessibilitySettings({required this.textScale, required this.highContrast});

  AccessibilitySettings copyWith({TextScaleSize? textScale, bool? highContrast}) {
    return AccessibilitySettings(
      textScale: textScale ?? this.textScale,
      highContrast: highContrast ?? this.highContrast,
    );
  }
}

class AppSettingsDefaults {
  static const appearanceMode = 'system';
  static const videoQuality = 'auto';
  static const autoPlayNext = true;
  static const textSize = 'medium';
  static const highContrast = false;
}
