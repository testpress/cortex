# Tasks: Internationalization Foundation

## 1. Infrastructure Setup

- [x] 1.1 Add `flutter_localizations` and `intl` to `packages/core/pubspec.yaml`
- [x] 1.2 Configure `l10n.yaml` for `packages/core`
- [x] 1.3 Create initial `app_en.arb` and `app_ar.arb` (for RTL testing) in `packages/core/lib/l10n/`

## 2. Localization Provider

- [x] 2.1 Implement `LocalizationProvider` in `packages/core`
- [x] 2.2 Add `l10n.of(context)` helper utility
- [x] 2.3 Integrate `LocalizationProvider` into `app/lib/main.dart`

## 3. RTL Refactor

- [x] 3.1 Audit `packages/core/lib/widgets/` for physical units
- [x] 3.2 Migrate `AppButton`, `AppCard`, and `AppText` to `Directional` geometry
- [x] 3.3 Verify RTL rendering in the reference app with a mock Arabic locale

## 4. Verification

- [x] 4.1 Add widget tests for locale switching
- [x] 4.2 Verify RTL layout mirroring via golden tests (optional) or manual audit
