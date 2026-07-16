## Context

The application relies on `AppConfig` (in `packages/core/lib/data/config/app_config.dart`) to provide build-time configuration flags via `--dart-define-from-file`. Different institutes might require specific features like certificates to be toggled on or off. We need to introduce a new `certificate` boolean configuration flag.

## Goals / Non-Goals

**Goals:**
- Add a build-time configuration flag `certificate` to toggle certificate features.
- Ensure the default value is `false` to maintain current behavior where not specified.

**Non-Goals:**
- Dynamically toggling the feature at runtime (it will be statically compiled via `--dart-define`).
- Implementing the actual UI features related to the certificate (only the configuration flag is in scope).

## Decisions

**1. Add flag to `AppConfig`:**
- **Decision**: Define a new static constant `certificate` in `AppConfig`.
- **Rationale**: This matches the existing pattern in the application for parsing environment variables from configuration JSON files at compile time via `bool.fromEnvironment`.
- **Alternatives Considered**: Using a riverpod provider for dynamic configuration from an API. Rejected because the requirement specifies using the existing static JSON config approach (`app_config.dart`).

## Risks / Trade-offs

- **Risk**: Incorrect JSON structure in the configuration file could cause the flag not to be read.
  - **Mitigation**: Ensure that the JSON key is documented as `CERTIFICATE` and the `defaultValue: false` fallback is provided safely using `bool.fromEnvironment`.
