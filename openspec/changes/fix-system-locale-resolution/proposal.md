## Why

Currently, the app hardcodes the default locale to English (`Locale('en')`) through `LocalizationProvider` and forces this onto `MaterialApp`. This completely overrides Flutter's built-in locale resolution logic, preventing the app from automatically matching the device's system language (like Tamil, Arabic, or Malayalam). Users expecting the app to automatically reflect their device settings are presented with the English interface instead.

## What Changes

- Make the `LocalizationProvider`'s initial internal `locale` nullable (`Locale?`), defaulting to `null` instead of `Locale('en')`.
- Pass `locale: null` to `MaterialApp` to re-enable Flutter's automatic system locale detection.
- Rely on Flutter's default `localeListResolutionCallback` (or `supportedLocales` fallback behavior) to automatically default to the first supported locale (English) when the device uses an unsupported language (e.g., German, French).

## Capabilities

### New Capabilities
*(None)*

### Modified Capabilities
- `localization`: The requirements must be updated to specify that the `LocalizationProvider` and app root MUST respect the device's system locale by default, automatically resolving against the `supportedLocales` or falling back to English.

## Impact

- **Code Affected**: `packages/core/lib/localization/localization_provider.dart` and the `MaterialApp` initialization in `app/lib/main.dart`.
- **System Behavior**: The app will now boot in the system's preferred language if it is one of the supported languages, affecting the out-of-the-box user experience.
