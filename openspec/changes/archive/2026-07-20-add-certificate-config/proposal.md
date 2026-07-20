## Why

We need a way to easily enable or disable certificate features across the application through configuration without changing the codebase directly. This solves the problem of conditionally showing certificate-related features per institute or environment.

## What Changes

- Add a boolean `certificate` flag to the application configuration data model (defaulting to `false`).
- Ensure this flag can be parsed from the configuration JSON file.

## Capabilities

### New Capabilities

### Modified Capabilities
- `dynamic-config`: Add requirement to support a `certificate` boolean flag in the configuration JSON.

## Impact

- `AppConfig` data model (in `packages/core/lib/data/config/app_config.dart`).
- Configuration JSON parsing logic.
- Any configuration JSON files (e.g. `assets/configs/*.json`).
