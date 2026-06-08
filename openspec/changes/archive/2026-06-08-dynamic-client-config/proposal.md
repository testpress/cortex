## Why

Currently, client configurations like "brilliant" are hardcoded and resolved via fragile string matching against the `apiBaseUrl` using Riverpod `ClientConfig`. This makes it difficult to manage configurations across 300+ clients, requires code changes and recompilation whenever a client wants to update their UI or feature toggles, and bloats the app size with unused features.

## What Changes

- Decouple `ClientConfig` entirely and remove it from the codebase.
- Introduce `AppConfig` with static `const bool.fromEnvironment` and `String.fromEnvironment` fields for all feature flags.
- Use Flutter's native `--dart-define-from-file=config/[client].json` build flag to inject configurations at compile-time.
- **BREAKING**: Existing logic relying on Riverpod `clientConfigProvider` is replaced with direct static `AppConfig` access. The JSON configuration file does NOT need to be bundled as an asset, as it is only processed during compilation.

## Capabilities

### New Capabilities
- `static-compile-time-config`: Allows injecting client-specific feature toggles and UI branding through static JSON configuration files without modifying Dart code, enabling aggressive tree-shaking of unused UI components.

### Modified Capabilities


## Impact

- **`client_config_provider.dart` & `client_config.dart`**: Deleted entirely.
- **`app_config.dart`**: Refactored to act as a static container for all compile-time feature flags.
- **UI Components**: Updated to check `AppConfig` statically instead of reading from Riverpod providers.
- **Build/Deployment Scripts**: Need to be updated to pass `--dart-define-from-file=config/[client].json` during the build process.
