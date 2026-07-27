## Why

The `InstituteSettings.current` singleton was causing issues during hot reload and dynamic updates because the widgets relying on it were not reacting to state changes. Moving to a Riverpod provider ensures that the settings are reactive and persist gracefully across hot reloads.

## What Changes

- Remove `InstituteSettings.current` static field from `InstituteSettings`.
- Update `instituteSettingsProvider` to initialize to `null`.
- Update `InstituteSettingsRepository` to only return settings without setting the global singleton.
- Update UI widgets (profile header, account preferences, pdf viewer, dashboard header) to read from `ref.watch(instituteSettingsProvider)`.
- Update `PaymentGatewayFactory` to accept `InstituteSettings` as a parameter instead of reading the singleton.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
None.

## Impact

- `packages/core/lib/data/config/institute_settings.dart`
- `packages/core/lib/data/providers/institute_settings_provider.dart`
- `packages/core/lib/data/repositories/institute_settings_repository.dart`
- `packages/core/lib/payment/payment_gateway_factory.dart`
- `packages/core/lib/payment/payment_processing_screen.dart`
- `packages/testpress/lib/screens/dashboard/widgets/dashboard_header_widget.dart`
- `packages/profile/lib/widgets/paid_active_profile_header.dart`
- `packages/profile/lib/widgets/paid_active_account_preferences_section.dart`
- `packages/courses/lib/widgets/lesson_detail/pdf_viewer.dart`
