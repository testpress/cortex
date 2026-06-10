## ADDED Requirements

### Requirement: Tamil (ta) Support

The SDK MUST provide full support for the Tamil language, including translations for all core widgets and reference app components.

#### Scenario: Verify Tamil translation
- **WHEN** the locale is set to 'ta'
- **THEN** the system MUST use the translated strings from `app_ta.arb`
- **AND** the app MUST render Tamil characters correctly without layout issues
