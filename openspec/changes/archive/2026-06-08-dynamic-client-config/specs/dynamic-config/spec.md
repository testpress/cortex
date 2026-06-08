## ADDED Requirements

### Requirement: Build-time JSON configuration injection
The system SHALL support providing a path to a static JSON configuration file at build time via `--dart-define=CONFIG_PATH`. The application SHALL read and parse this JSON file synchronously during the startup sequence before the UI boots, and provide it throughout the app via Riverpod.

#### Scenario: Successful configuration injection
- **WHEN** the application is built with `--dart-define=CONFIG_PATH=assets/configs/brilliant.json`
- **THEN** the application parses `brilliant.json` and the `clientConfigProvider` serves the specific configuration for the brilliant institute.

#### Scenario: Fallback to default
- **WHEN** the application is built without specifying a `CONFIG_PATH` or the specified JSON file cannot be found
- **THEN** the application falls back to the default `const ClientConfig()` constructor to prevent startup crashes.
