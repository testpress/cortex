## ADDED Requirements

### Requirement: Certificate Configuration Flag
The system SHALL support providing a build-time configuration flag for certificates via JSON configuration injected through `--dart-define-from-file`. This flag SHALL default to `false`.

#### Scenario: Certificate flag enabled
- **WHEN** the JSON configuration file specifies `"SHOW_CERTIFICATE": true`
- **THEN** `AppConfig.showCertificate` evaluates to `true` at runtime.

#### Scenario: Certificate flag disabled
- **WHEN** the JSON configuration file specifies `"SHOW_CERTIFICATE": false` or does not specify the flag
- **THEN** `AppConfig.showCertificate` evaluates to `false` at runtime.
