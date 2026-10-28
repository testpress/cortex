## 1. Institute Settings & Localization

- [x] 1.1 Add `studentNotesEnabled` and `studentNotesLabel` fields to `InstituteSettings` with JSON serialization in `packages/core/lib/data/config/institute_settings.dart`
- [x] 1.2 Add unit tests for `studentNotesEnabled` and `studentNotesLabel` in `packages/core/test/data/config/institute_settings_test.dart`
- [x] 1.3 Add localization strings (`notes`) in `packages/core/lib/l10n/app_*.arb`

## 2. Student Notes Screen & SSO URL Provider

- [x] 2.1 Implement `studentNotesUrlProvider` in `packages/testpress` to fetch presigned SSO URL targeting `/student-diary/my-notes/?testpress_app=1`
- [x] 2.2 Create `StudentNotesScreen` in `packages/testpress/lib/screens/student_notes_screen.dart` with `AppShell`, `AppHeader`, `AppWebView`, and `PopScope` back-navigation delegate
- [x] 2.3 Intercept external URL navigation in `StudentNotesScreen` using `url_launcher`
- [x] 2.4 Apply `MediaQuery.viewInsetsOf(context).bottom` padding to resize `StudentNotesScreen` when soft keyboard appears
- [x] 2.5 Add widget tests for `StudentNotesScreen` covering loading, error, and loaded states

## 3. Navigation & Routing

- [x] 3.1 Register route `/student-notes` under `immersiveRoutes` in `packages/testpress/lib/navigation/routes/global_routes.dart`
- [x] 3.2 Add conditional Notes navigation item in `DashboardDrawer` gated by `studentNotesEnabled`
- [x] 3.3 Add widget tests in `packages/testpress/test/widgets/dashboard_drawer_test.dart` for Notes drawer item visibility

## 4. Verification

- [x] 4.1 Run build_runner, analyzer, and test suite on `packages/core` and `packages/testpress` to verify all tests pass
