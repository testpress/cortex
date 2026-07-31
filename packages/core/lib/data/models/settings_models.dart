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
  final bool rememberPlaybackSpeed;
  final double? globalPlaybackSpeed;
  PlaybackSettings({
    required this.quality,
    required this.autoPlayNext,
    this.rememberPlaybackSpeed = false,
    this.globalPlaybackSpeed,
  });

  PlaybackSettings copyWith({
    VideoQuality? quality,
    bool? autoPlayNext,
    bool? rememberPlaybackSpeed,
    double? globalPlaybackSpeed,
  }) {
    return PlaybackSettings(
      quality: quality ?? this.quality,
      autoPlayNext: autoPlayNext ?? this.autoPlayNext,
      rememberPlaybackSpeed:
          rememberPlaybackSpeed ?? this.rememberPlaybackSpeed,
      globalPlaybackSpeed: globalPlaybackSpeed ?? this.globalPlaybackSpeed,
    );
  }
}

class AccessibilitySettings {
  final TextScaleSize textScale;
  final bool highContrast;
  AccessibilitySettings({required this.textScale, required this.highContrast});

  AccessibilitySettings copyWith({
    TextScaleSize? textScale,
    bool? highContrast,
  }) {
    return AccessibilitySettings(
      textScale: textScale ?? this.textScale,
      highContrast: highContrast ?? this.highContrast,
    );
  }
}

class AppLanguageSettings {
  final String languageCode;
  AppLanguageSettings({required this.languageCode});

  AppLanguageSettings copyWith({String? languageCode}) {
    return AppLanguageSettings(languageCode: languageCode ?? this.languageCode);
  }
}

class AppSettingsDefaults {
  static const appearanceMode = 'system';
  static const videoQuality = 'auto';
  static const autoPlayNext = true;
  static const textSize = 'medium';
  static const highContrast = false;
  static const appLanguage = 'system';
  static const rememberPlaybackSpeed = false;
}
