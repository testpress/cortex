# lucide-icons-migration Specification

## Purpose
TBD - created by archiving change migrate-to-lucide-icons-flutter. Update Purpose after archive.
## Requirements
### Requirement: Migrate core icon dependency
The system SHALL use `lucide_icons_flutter` as the default Lucide icon provider across all Dart files in the monorepo for standard UI icons.

#### Scenario: App builds with new icons
- **WHEN** developers compile the application
- **THEN** standard icons resolve correctly via `lucide_icons_flutter`

### Requirement: Preserve legacy brand icons
The system SHALL retain access to deprecated brand icons (like Chrome and YouTube) by exposing the legacy `lucide_icons` package through a dedicated `legacy_icons.dart` export in the `core` package, preventing naming collisions.

#### Scenario: App builds with legacy brand icons
- **WHEN** developers compile the application
- **THEN** brand icons resolve correctly via the legacy export without missing definition errors or lint warnings

