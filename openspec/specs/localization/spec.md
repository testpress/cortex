# Localization Specification

## Purpose
Enable the Cortex SDK to serve global markets by providing robust translation infrastructure.

## Requirements

### Requirement: Centralized Locale Management

The system MUST provide a `LocalizationProvider` at the application root to manage the active locale and distribute it to all child widgets.

#### Scenario: Changing language at runtime

- **WHEN** the `LocalizationProvider`'s locale is updated to 'fr'
- **THEN** all child widgets using localized strings MUST rebuild
- **AND** the strings MUST reflect the new French translation

### Requirement: Distributed Translation ARBs

The SDK MUST support defining translation strings in `.arb` files within each package's `l10n/` directory.

#### Scenario: Merging package translations

- **WHEN** the system initializes
- **THEN** it MUST merge ARB definitions from `core`, `courses`, and `exams`
- **AND** make them accessible through a single `AppLocalizations` delegate
