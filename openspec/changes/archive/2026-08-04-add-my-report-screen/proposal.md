## Why

Students need a dedicated, localized, and easily accessible "My report" screen in the app to view their overall learning performance.

## What Changes

- Added `AppWebView` core primitive under `packages/core` to load authorized web content.
- Added `MyReportScreen` under `packages/testpress` to load the personal report URL.
- Configured dynamic domain routing logic to automatically normalize report URLs.
- Implemented card-colored header with soft drop shadow and back navigation button.
- Added drawer option under `DashboardDrawer` with visibility conditional on `InstituteSettings.disableStudentReport`.
- Localized "My report" text for all supported languages (English, Arabic, Malayalam, and Tamil).

## Capabilities

### New Capabilities
- `my-report-screen`: Displays personalized student reports via an embedded web view with dynamic domains and language-localized UI shell.

### Modified Capabilities

## Impact

- `packages/core/lib/widgets/app_webview.dart` (new widget)
- `packages/testpress/lib/screens/my_report_screen.dart` (new screen)
- `packages/testpress/lib/widgets/dashboard_drawer.dart` (added drawer item)
- `packages/core/lib/l10n/` (localization additions)
