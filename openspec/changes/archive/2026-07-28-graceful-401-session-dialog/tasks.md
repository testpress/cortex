## 1. Core: Session Expired Provider

- [x] 1.1 Add `sessionExpiredProvider` as `StateProvider<String?>` in `packages/core/lib/data/auth/auth_provider.dart` (initial state: `null`)

## 2. Core: AuthInterceptor Callback Update

- [x] 2.1 Rename `onUnauthorized: void Function()?` to `onSessionExpired: void Function(String message)?` in `AuthInterceptor`
- [x] 2.2 In `AuthInterceptor.onError()`, extract the message from the `DioException` using `ApiException.fromDioException(err).message` before calling `onSessionExpired`
- [x] 2.3 Apply a fallback message `"Your session has expired. Please sign in again."` when the extracted message is empty

## 3. Core: Dio Provider Wiring

- [x] 3.1 Update `dio_provider.dart` — replace `onUnauthorized: () => ref.read(authProvider.notifier).logout()` with `onSessionExpired: (msg) => ref.read(sessionExpiredProvider.notifier).state = msg`

## 4. Core: SessionExpiredDialog Widget

- [x] 4.1 Create `packages/core/lib/widgets/session_expired_dialog.dart` — a `ConsumerWidget` that accepts `message` and `onSignIn` callback
- [x] 4.2 Style: semi-transparent full-screen barrier + centered card with lock icon, title "Session Ended", message text, and "Sign In Again" primary button
- [x] 4.3 Make it non-dismissible: `WillPopScope` (or `PopScope`) returning false, no barrier tap dismissal

## 5. App Shell: Dialog Overlay

- [x] 5.1 In `_AppShellBuilder` (`app_router.dart`), watch `sessionExpiredProvider`
- [x] 5.2 When `sessionExpiredProvider` is non-null, render `SessionExpiredDialog` as a `Stack` overlay above the `AppShell` (same pattern as the logout bottom sheet)
- [x] 5.3 Wire the `onSignIn` callback: call `auth.logout()` then reset `sessionExpiredProvider.state = null`

## 6. Courses: Suppress 401 Errors from UI State

- [x] 6.1 In `course_list_provider._performSync()` catch block — if `e is ApiException && e.type == ApiErrorType.unauthorized`, return early without setting `courseListSyncError`
- [x] 6.2 In `CourseSearch._performSearch()` catch block — same guard, skip `state.copyWith(error: e)` on unauthorized

## 7. Cleanup

- [x] 7.1 Export `sessionExpiredProvider` and `SessionExpiredDialog` from `core.dart`
