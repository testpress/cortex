# Proposal: Persist Theme via SharedPreferences

## Why
App theme settings (`appearance_mode`) currently rely on asynchronous SQLite reads during cold start, falling back to `DesignMode.system` while `appearanceSettingsNotifierProvider` is in an `AsyncLoading` state. On devices where OS brightness is set to Light Mode or when SQLite startup transactions experience lock contention, this causes intermittent cold-start flashes or resets back to Light Mode.

## What Changes
- Migrate display theme persistence (`appearance_mode`) from SQLite `AppSettingsTable` to `SharedPreferences` (native `NSUserDefaults` on iOS / `SharedPreferences` on Android).
- Pre-load `SharedPreferences` during `main()` before `runApp()`.
- Inject initial `DesignMode` synchronously into Riverpod `ProviderScope` overrides to guarantee Frame 1 renders with the user's saved theme mode without asynchronous fallback states.

## Capabilities

### Modified Capabilities
- `dark-mode-support`: Guarantee immediate, deterministic restoration of the user's theme preference on cold start across iOS and Android without asynchronous fallback flashes.

## Impact
- `app/lib/main.dart`: Initialize `SharedPreferences` before `runApp()` and override theme providers.
- `packages/profile/lib/providers/settings_providers.dart`: Refactor `AppearanceSettingsNotifier` to persist settings to `SharedPreferences`.
- `packages/profile/lib/providers/design_mode_provider.dart`: Ensure synchronous access to active `DesignMode`.
