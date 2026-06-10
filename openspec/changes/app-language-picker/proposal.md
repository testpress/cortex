## Why

Currently, the app relies solely on system locale to determine the active language, preventing users from selecting a preferred language that differs from their device's language. A manual language picker gives users full control over their localization preferences.

## What Changes

- Add a new persistent `appLanguage` field to the local settings database.
- Introduce a language picker section in the App Settings UI allowing users to choose from System Default, English, Arabic, Malayalam, and Tamil.
- Wire the root `CortexApp` to observe this custom language preference, overriding the system locale if explicitly set.

## Capabilities

### New Capabilities
- `app-language-preference`: Allows the user to select and persist a preferred app language independently of the device's system settings.

### Modified Capabilities


## Impact

- **Database**: Adds a new column to the `AppSettingsTable` (`app_settings_table.dart`).
- **State Management**: Introduces a new `LocalizationSettingsNotifier` in Riverpod (`settings_providers.dart`).
- **UI**: Expands `AppSettingsScreen` (`packages/profile`) to include the language picker controls.
- **Root**: `CortexApp` (`app/lib/main.dart`) listens to the new Riverpod state.
