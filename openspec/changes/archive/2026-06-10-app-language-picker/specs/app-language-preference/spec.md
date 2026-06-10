# App Language Preference

## Overview
This capability allows users to manually set the application's language, overriding the device's system-level locale settings.

## ADDED Requirements

### Requirement: Persistence
- The selected language preference MUST be saved locally so it persists across application restarts.
- The default value for the language preference MUST be "system" (indicating delegation to the device's locale).

#### Scenario: User saves language preference
When the user selects a language preference in the app settings, it is persisted in the local database.

### Requirement: Available Options
The application MUST offer the following language selection options:
- **System Default** (`system`)
- **English** (`en`)
- **Arabic** (`ar`)
- **Malayalam** (`ml`)
- **Tamil** (`ta`)

#### Scenario: User views language options
When the user views the language section, they are presented with a dynamically generated list of supported language options.

### Requirement: Application State
- When "System Default" is selected, the application MUST rely on Flutter's default locale resolution, which detects the device language and falls back to English if unsupported.
- When a specific language is selected, the application MUST force the UI to render in that exact language immediately, updating all localized strings, text direction (LTR/RTL), and locale-aware formatting.

#### Scenario: User changes language
When the user selects a new language from the settings, the app immediately re-renders the UI in the selected language.

### Requirement: Settings Interface
- The application settings MUST include a dedicated section for "Language" (`_LanguageSection`).
- The interface MUST display the options dynamically as a list (without hardcoding).
- Changes made in the UI MUST immediately trigger a state update and persist the change.

#### Scenario: User interacts with Language Settings
When the user accesses the App Settings screen, they see the Language section and can change their preference via the list.
