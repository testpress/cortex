# App Language Preference

## Overview
This capability allows users to manually set the application's language, overriding the device's system-level locale settings.

## Requirements

### 1. Persistence
- The selected language preference MUST be saved locally so it persists across application restarts.
- The default value for the language preference MUST be "system" (indicating delegation to the device's locale).

### 2. Available Options
The application MUST offer the following language selection options:
- **System Default** (`system`)
- **English** (`en`)
- **Arabic** (`ar`)
- **Malayalam** (`ml`)
- **Tamil** (`ta`)

### 3. Application State
- When "System Default" is selected, the application MUST rely on Flutter's default locale resolution, which detects the device language and falls back to English if unsupported.
- When a specific language is selected, the application MUST force the UI to render in that exact language immediately, updating all localized strings, text direction (LTR/RTL), and locale-aware formatting.

### 4. Settings Interface
- The application settings MUST include a dedicated section for "Language" (`_LanguageSection`).
- The interface MUST display the options dynamically as a list (without hardcoding).
- Changes made in the UI MUST immediately trigger a state update and persist the change.
