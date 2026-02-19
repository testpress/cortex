# Design: Additional Locales Expansion

## Context
Adding Malayalam and completing Arabic support requires expanding the existing localization infrastructure and refactoring hardcoded strings in the domain packages.

## Decisions

### Decision 1: Malayalam Font Handling
Malayalam script requires complex text rendering. We will rely on Flutter's default engine support, ensuring that the system font or the default SDK font handles Malayalam glyphs correctly.

### Decision 2: Content Localization Strategy
For mock data (course titles/descriptions), we will provide localized versions within the `AppLocalizations` system, using the course ID as part of the translation key.

## Data Structures

### ARB Update: packages/core/lib/l10n/app_ml.arb
```json
{
  "@@locale": "ml",
  "appTitle": "കോട്ടെക്സ് SDK",
  "loginButton": "ലോഗിൻ",
  "welcomeMessage": "കോട്ടെക്സിലേക്ക് സ്വാഗതം",
  "courseLibraryTitle": "കോഴ്സ് ലൈബ്രറി"
}
```
