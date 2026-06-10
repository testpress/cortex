# Implementation Tasks

## Phase 1: Database & Persistence Layer
- [x] Add `appLanguage` field (default `'system'`) to `AppSettingsTable` in `packages/core/lib/data/db/tables/app_settings_table.dart`.
- [x] Run drift_dev code generation to update `app_database.g.dart`.
- [x] Update `SettingsRepository` in `packages/profile/lib/repositories/settings_repository.dart` to support reading/writing `appLanguage`.
- [x] Create `AppLanguageSettings` model in `packages/core/lib/data/models/settings_models.dart`.

## Phase 2: State Management Layer
- [x] Create `AppLanguageSettingsNotifier` provider in `packages/profile/lib/providers/settings_providers.dart`.
- [x] Implement `updateLanguage` method in the notifier to handle persistence via the repository.

## Phase 3: UI Implementation
- [x] Open `packages/profile/lib/screens/app_settings_screen.dart`.
- [x] Create a `_LanguageSection` widget that reads from `appLanguageSettingsNotifierProvider`.
- [x] Implement a dynamic list for System Default, English, Arabic, Malayalam, and Tamil (no icons).
- [x] Insert the `_LanguageSection` into the `AppSettingsScreen` layout.

## Phase 4: App Integration
- [x] Open `app/lib/main.dart`.
- [x] Modify `CortexApp` to watch `appLanguageSettingsNotifierProvider`.
- [x] Resolve the current language code from the provider.
- [x] Pass the resolved locale to `MaterialApp.locale` (`null` if `'system'`, else `Locale(code)`).

## Phase 5: Verification
- [x] Verify the UI renders correctly.
- [x] Verify selecting a language immediately changes the app text.
- [x] Verify the selected language persists across hot restarts.
- [x] Run `dart analyze` and tests.
