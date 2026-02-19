# Tasks: Additional Locales Expansion

## 1. Infrastructure
- [ ] 1.1 Add `ml` to `supportedLocales` in `LocalizationProvider`
- [ ] 1.2 Create `packages/core/lib/l10n/app_ml.arb`
- [ ] 1.3 Update `packages/core/lib/l10n/app_ar.arb` with new keys

## 2. Refactoring
- [ ] 2.1 Migrate hardcoded strings in `AppHeader` (reference app)
- [ ] 2.2 Migrate hardcoded strings in `CourseListScreen`
- [ ] 2.3 Provide localized strings for mock course data

## 3. Verification
- [ ] 3.1 Verify Malayalam translations in reference app
- [ ] 3.2 Verify Arabic translation completion
- [ ] 3.3 Add regression tests for Malayalam locale switching
