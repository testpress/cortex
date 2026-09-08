# Tasks: Persist Theme via SharedPreferences

## 1. Setup & Core Integration
- [x] 1.1 Add `sharedPreferencesProvider` in `packages/core/lib/data/providers/` (or `packages/profile/lib/providers/`).
- [x] 1.2 Update `app/lib/main.dart` to initialize `SharedPreferences.getInstance()` in `main()` before `runApp()`.
- [x] 1.3 Inject `sharedPreferencesProvider` into root `ProviderScope(overrides: [...])`.

## 2. Refactor Appearance Settings & Design Mode Providers
- [x] 2.1 Refactor `AppearanceSettingsNotifier` in `packages/profile/lib/providers/settings_providers.dart` to read and write `appearance_mode` from `SharedPreferences`.
- [x] 2.2 Update `designModeProvider` in `packages/profile/lib/providers/design_mode_provider.dart` to synchronously resolve `DesignMode`.

## 3. Verification & Testing
- [x] 3.1 Verify unit tests for `designModeProvider` and `AppearanceSettingsNotifier`.
- [x] 3.2 Verify cold start behavior with device system theme set to Light Mode.
