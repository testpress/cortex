## 1. Clean up Legacy Global State

- [x] 1.1 Remove `InstituteSettings.current` static field from `InstituteSettings` model.
- [x] 1.2 Update `instituteSettingsProvider` to initialize with `null` instead of the static field.
- [x] 1.3 Remove mutation of `InstituteSettings.current` in `InstituteSettingsRepository`.

## 2. Refactor UI Components to Riverpod

- [x] 2.1 Convert `DashboardHeaderWidget` to watch `instituteSettingsProvider`.
- [x] 2.2 Convert `ProfileHeader` to a `ConsumerWidget` and watch `instituteSettingsProvider`.
- [x] 2.3 Convert `AccountPreferencesSection` to a `ConsumerWidget` and watch `instituteSettingsProvider`.
- [x] 2.4 Update `AppPdfViewer` to read from the provider instead of the global singleton.

## 3. Refactor Business Logic

- [x] 3.1 Update `PaymentGatewayFactory` to accept `InstituteSettings` as a method parameter.
- [x] 3.2 Update `PaymentProcessingScreen` to pass the settings from Riverpod to the factory.
