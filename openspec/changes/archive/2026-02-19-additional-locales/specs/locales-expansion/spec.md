# Capability: Locales Expansion

## ADDED Requirements

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
