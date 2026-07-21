# dynamic-branding Specification

## Purpose
TBD - created by archiving change dynamic-client-branding. Update Purpose after archive.
## Requirements
### Requirement: Dynamic Logo Asset Resolution
The system SHALL dynamically resolve logo assets at runtime across all core branding surfaces (Dashboard Banner, Splash Screen).

#### Scenario: Resolving local assets
- **WHEN** the `AppConfig.instituteLogoUrl` or API `photo` URL begins with `assets/`
- **THEN** the system renders it using a local `Image.asset()`

#### Scenario: Resolving network assets
- **WHEN** the `AppConfig.instituteLogoUrl` or API `photo` URL is an HTTP/HTTPS address
- **THEN** the system renders it using a network `Image.network()`

### Requirement: Missing Asset Resilience
The system SHALL NOT crash or display a broken image when a resolved local asset file does not exist.

#### Scenario: Local image file is missing
- **WHEN** `Image.asset()` fails to load an injected local image
- **THEN** the system seamlessly falls back to a generic fallback component (e.g., standard text and a default icon) via `errorBuilder`

### Requirement: Primary Brand Color Injection
The system SHALL accept a primary brand color retrieved from the remote client configuration and inject it natively into the design system during the application build and run phases.

#### Scenario: Valid hex code provided
- **WHEN** the remote config returns `primary_color` as `#2a398f`
- **THEN** the build script parses and injects the color via `--dart-define`, and the design system utilizes it as the primary color across the app.

#### Scenario: Invalid hex code provided
- **WHEN** the remote config returns `primary_color` as `#fff` or an invalid string
- **THEN** the design system falls back to the default brand color and prints a warning to the debug console.

