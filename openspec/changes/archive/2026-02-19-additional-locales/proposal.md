# Proposal: Additional Locales (Malayalam & Arabic)

## Why
Expand the platform's linguistic reach by adding Malayalam (`ml`) support and completing the Arabic (`ar`) translation for all customer-facing text in the reference application.

## User Review Required
> [!IMPORTANT]
> This change introduces Malayalam as a supported language. The translations will be based on standard terminology for Flutter/Tech concepts.

## Proposed Changes

### Core Infrastructure
- **LocalizationProvider**: Add `ml` to the list of `supportedLocales`.
- **ARB Files**: 
  - Create `packages/core/lib/l10n/app_ml.arb`.
  - Update `packages/core/lib/l10n/app_ar.arb` with missing strings.

### Sample Application
- **Language Toggle**: Update the toggle in `app/lib/main.dart` to include Malayalam.
- **String Migration**: Ensure `CourseListScreen` and `AppHeader` use `AppLocalizations` instead of hardcoded strings.

## Verification Plan
1. **Automated Tests**: Update `localization_test.dart` to verify `ml` locale switching.
2. **Manual Verification**: Run the reference app and verify the UI mirrors correctly and displays Malayalam/Arabic text when toggled.
