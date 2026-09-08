# Design Document: Persist Theme via SharedPreferences

## Context
Currently, theme persistence (`appearance_mode`) relies on an asynchronous SQLite read (`AppDatabase.getAppSettings()`) via `AppearanceSettingsNotifier`. During cold start, `designModeProvider` evaluates `appearanceSettingsNotifierProvider`'s `AsyncLoading()` state with `loading: () => DesignMode.system`. If the device OS brightness is Light Mode or if SQLite startup transactions experience lock contention, this causes the app to mount in Light Mode before updating to Dark Mode.

## Architecture & Implementation Decisions

### 1. `SharedPreferences` Injection in `main()`
- In `app/lib/main.dart`, invoke `await SharedPreferences.getInstance()` inside `main()` after `WidgetsFlutterBinding.ensureInitialized()`.
- Read saved `appearance_mode` string (`'light'`, `'dark'`, or `'system'`).
- Override `sharedPreferencesProvider` in `ProviderScope(overrides: [...])` so all Riverpod providers have synchronous access to `SharedPreferences`.

### 2. Refactoring `AppearanceSettingsNotifier` & `designModeProvider`
- Replace asynchronous SQLite setting calls for `appearanceMode` with synchronous reads from `SharedPreferences`.
- When updating theme mode via `updateMode(newMode)`, write to `SharedPreferences` (`prefs.setString('appearance_mode', newMode.name)`).
- `designModeProvider` consumes the synchronous initial `SharedPreferences` state.

### 3. Synchronous Initial Theme Resolution
- `designModeProvider` returns the synchronous `DesignMode` directly without falling back to `DesignMode.system` during an `AsyncLoading` state.

## Migration & Risk Analysis
- **Backward Compatibility**: If no `SharedPreferences` key exists on first launch, default to `'system'`.
- **Data Purge Integrity**: `AppDatabase.purgeAllData()` on logout wipes SQLite tables. User UI preferences in `SharedPreferences` will survive logout as intended.
