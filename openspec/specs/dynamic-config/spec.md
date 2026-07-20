# dynamic-config Specification

## Purpose
TBD - created by archiving change dynamic-client-config. Update Purpose after archive.
## Requirements
### Requirement: Build-time JSON configuration injection
The system SHALL support providing a path to a static JSON configuration file at build time via `--dart-define=CONFIG_PATH`. The application SHALL read and parse this JSON file synchronously during the startup sequence before the UI boots, and provide it throughout the app via Riverpod.

#### Scenario: Successful configuration injection
- **WHEN** the application is built with `--dart-define=CONFIG_PATH=assets/configs/brilliant.json`
- **THEN** the application parses `brilliant.json` and the `clientConfigProvider` serves the specific configuration for the brilliant institute.

#### Scenario: Fallback to default
- **WHEN** the application is built without specifying a `CONFIG_PATH` or the specified JSON file cannot be found
- **THEN** the application falls back to the default `const ClientConfig()` constructor to prevent startup crashes.

### Requirement: Certificate Configuration Flag
The system SHALL support providing a build-time configuration flag for certificates via JSON configuration injected through `--dart-define-from-file`. This flag SHALL default to `false`.

#### Scenario: Certificate flag enabled
- **WHEN** the JSON configuration file specifies `"SHOW_CERTIFICATE": true`
- **THEN** `AppConfig.showCertificate` evaluates to `true` at runtime.

#### Scenario: Certificate flag disabled
- **WHEN** the JSON configuration file specifies `"SHOW_CERTIFICATE": false` or does not specify the flag
- **THEN** `AppConfig.showCertificate` evaluates to `false` at runtime.

