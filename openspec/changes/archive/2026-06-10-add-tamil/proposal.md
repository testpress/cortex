## Why

We currently support English, Arabic, and Malayalam localizations. Expanding our language support to include Tamil will make the application accessible to a wider user base, specifically native Tamil speakers, thereby increasing our reach and improving user experience for this demographic.

## What Changes

- Add a new localization file `app_ta.arb` for Tamil language support.
- Provide Tamil translations for all existing string keys.
- Ensure the app correctly switches to Tamil when the device locale is set to Tamil or when selected via in-app language preferences.

## Capabilities

### New Capabilities

### Modified Capabilities
- `localization`: Add Tamil (ta) to the list of officially supported languages.

## Impact

- **Code/Assets**: A new `.arb` file will be added to the `packages/core/lib/l10n/` directory. Generated `app_localizations.dart` and related files will be updated.
- **Systems**: Any language selection UI will need to reflect the new Tamil option.
