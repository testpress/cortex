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

### Requirement: Malayalam (ml) Support

The SDK MUST provide full support for the Malayalam language, including translations for all core widgets and reference app components.

#### Scenario: Verify Malayalam translation
- **WHEN** the locale is set to 'ml'
- **THEN** the `welcomeMessage` MUST render as "കോട്ടെക്സിലേക്ക് സ്വാഗതം"

### Requirement: Comprehensive Sample Localization

All hardcoded strings in the `courses` package and reference app `main.dart` MUST be migrated to the `AppLocalizations` system.

#### Scenario: Localizing Course Library header
- **WHEN** viewing the `CourseListScreen` in Arabic
- **THEN** the subtitle MUST render as "مكتبة الدورات" instead of hardcoded English.
