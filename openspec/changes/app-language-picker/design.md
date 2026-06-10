## Architecture

### 1. Database Layer (`packages/core`)
- Modify `AppSettingsTable` (`packages/core/lib/data/db/tables/app_settings_table.dart`) to add an `appLanguage` text column defaulting to `'system'`.
- Run `drift_dev` build to regenerate `app_database.g.dart`.

### 2. Repository Layer (`packages/profile`)
- Update `SettingsRepository` (`packages/profile/lib/repositories/settings_repository.dart`) to read and write the `appLanguage` field.
- Add `AppLanguageSettings` model class in `packages/core/lib/data/models/settings_models.dart`.

### 3. State Management Layer (`packages/profile`)
- Create `AppLanguageSettingsNotifier` in `packages/profile/lib/providers/settings_providers.dart` to expose the current language preference.
- Provide methods to update the language preference (`updateLanguage(String code)`).

### 4. UI Layer (`packages/profile`)
- In `AppSettingsScreen` (`packages/profile/lib/screens/app_settings_screen.dart`), add a `_LanguageSection`.
- Display a list of supported languages dynamically (System Default, English, Arabic, Malayalam, Tamil). No icons should be shown in the list items.
- Bind the selected value to the `AppLanguageSettingsNotifier`.

### 5. App Integration (`app`)
- In `app/lib/main.dart`, update `CortexApp` to watch `appLanguageSettingsNotifierProvider`.
- Compute the final locale based on the provider state (if 'system', return `null`, else return `Locale(code)`).
- Provide this locale directly to `MaterialApp.locale`.

## Data Models
New Data Model in `settings_models.dart`:
```dart
class AppLanguageSettings {
  final String languageCode;
  AppLanguageSettings({required this.languageCode});
}
```

## Dependencies
- `drift` for local storage.
- `riverpod` for state management.
