## Context

The previous `ClientConfig` logic relied on inspecting `AppConfig.apiBaseUrl` at runtime within the Riverpod `clientConfigProvider`. This approach requires source code modification for every new client, prevents easy customization of client-specific feature toggles, and blocks the Flutter compiler from tree-shaking unused UI features since the configuration is dynamic.

## Goals / Non-Goals

**Goals:**
- Move all client-specific configurations out of Dart code into static JSON files.
- Inject the configuration at compile time to enable aggressive tree-shaking of unused code branches.
- Remove Riverpod dependency for static UI branding and feature toggles.
- Improve app startup time and binary size.

**Non-Goals:**
- Runtime remote config fetching (e.g., via API or Firebase Remote Config).
- User-level settings overrides (Client Preferences).

## Decisions

- **Compile-Time Static Flags**: We will use `const bool.fromEnvironment` and `const String.fromEnvironment` in `AppConfig` to define feature toggles.
- **JSON Configuration Files**: We will store client configs in the root `config/` directory (e.g., `config/brilliant.json`).
- **Build-time Injection**: We will use Flutter's native `--dart-define-from-file=config/[client].json` flag. The Flutter compiler automatically parses this JSON and maps the keys to the environment constants.
- **No Assets Required**: Because the configuration is parsed at compile time, the JSON files do not need to be declared in `pubspec.yaml` or bundled into the app.

## Risks / Trade-offs

- **[Trade-off] Testing Compile-Time Flags**: Because `fromEnvironment` values are hardcoded at compile time, unit tests cannot dynamically toggle these flags. Tests verifying alternate states must be skipped or run in separate test processes using the `--dart-define` flag.
- **[Risk] Missing JSON fields**: If a field is missing from the JSON config, it might crash if unhandled.
  → **Mitigation**: Every `fromEnvironment` declaration in `AppConfig` includes a robust `defaultValue` to ensure the app compiles cleanly into a generic state if no config or an incomplete config is provided.
