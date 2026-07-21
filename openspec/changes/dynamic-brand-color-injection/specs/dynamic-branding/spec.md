## ADDED Requirements

### Requirement: Primary Brand Color Injection
The system SHALL accept a primary brand color retrieved from the remote client configuration and inject it natively into the design system during the application build and run phases.

#### Scenario: Valid hex code provided
- **WHEN** the remote config returns `primary_color` as `#2a398f`
- **THEN** the build script parses and injects the color via `--dart-define`, and the design system utilizes it as the primary color across the app.

#### Scenario: Invalid hex code provided
- **WHEN** the remote config returns `primary_color` as `#fff` or an invalid string
- **THEN** the design system falls back to the default brand color and prints a warning to the debug console.
