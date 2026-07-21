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
