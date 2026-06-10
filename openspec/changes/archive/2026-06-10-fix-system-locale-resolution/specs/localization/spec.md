## ADDED Requirements

### Requirement: System Locale Resolution

The system MUST respect the device's system locale by default if no explicit override is provided. `LocalizationProvider` MUST allow the locale to be automatically resolved based on the device's system settings against the application's supported locales.

#### Scenario: Device language is supported

- **WHEN** the app starts
- **AND** the mobile device's system language is set to a supported language (e.g., Tamil 'ta')
- **THEN** the app MUST automatically launch in that language without user intervention.

#### Scenario: Device language is unsupported

- **WHEN** the app starts
- **AND** the mobile device's system language is set to an unsupported language (e.g., German 'de')
- **THEN** the app MUST automatically fallback to English ('en').
