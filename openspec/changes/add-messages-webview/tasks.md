## 1. Institute Settings & Localization

- [x] 1.1 Add `messagesEnabled` and `messagesLabel` fields to `InstituteSettings` with JSON serialization in `packages/core/lib/data/config/institute_settings.dart`
- [x] 1.2 Add unit tests for `messagesEnabled` and `messagesLabel` in `packages/core`
- [x] 1.3 Add localization strings (`drawerMessages`, `messagesTitle`) in `packages/core/lib/localization/`

## 2. Messages Screen & SSO URL Provider

- [x] 2.1 Implement `messagesUrlProvider` in `packages/testpress` to fetch presigned SSO URL and format `/messages/?testpress_app=1` with institute domain
- [x] 2.2 Create `MessagesScreen` in `packages/testpress/lib/screens/messages_screen.dart` with `AppShell`, `AppHeader`, `AppWebView`, and `PopScope` back-navigation delegate
- [x] 2.3 Add widget tests for `MessagesScreen` covering loading, error, and loaded states
- [x] 2.4 Intercept attachment and external URL navigation in `MessagesScreen` using `url_launcher` and add unit/widget tests
- [x] 2.5 Show error `AppToast` with async/await and widget test coverage when external URL launch fails in `MessagesScreen`
- [x] 2.6 Implement `buildAuthenticatedSsoUrl` helper and `UserRepository.getAuthenticatedSsoUrl()` in `packages/core` with unit tests
- [x] 2.7 Update `messagesUrl` provider in `packages/testpress` to consume `userRepo.getAuthenticatedSsoUrl` and update tests
- [x] 2.8 Apply `MediaQuery.viewInsetsOf(context).bottom` padding to resize `MessagesScreen` when soft keyboard appears


## 3. Navigation & Routing

- [x] 3.1 Register route `/messages` under `immersiveRoutes` in `packages/testpress/lib/navigation/routes/global_routes.dart`
- [x] 3.2 Add conditional Messages navigation item in `DashboardDrawer` gated by `messagesEnabled`
- [x] 3.3 Add widget tests in `packages/testpress/test/widgets/dashboard_drawer_test.dart` for Messages drawer item visibility

## 4. Verification

- [x] 4.1 Run analyzer and test suite on `packages/core` and `packages/testpress` to verify all tests pass
