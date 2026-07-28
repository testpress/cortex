## ADDED Requirements

### Requirement: sessionExpiredProvider holds the 401 message
The system SHALL expose a `StateProvider<String?>` named `sessionExpiredProvider` in `core`. A `null` value means no session expiry is in progress. A non-null value is the human-readable message extracted from the 401 API response.

#### Scenario: No active session expiry
- **WHEN** no 401 has been received
- **THEN** `sessionExpiredProvider.state` is `null`

#### Scenario: 401 received from a protected endpoint
- **WHEN** `AuthInterceptor.onError` processes a 401 from a non-auth-flow path
- **THEN** `sessionExpiredProvider.state` is set to the message from `ApiException.message`
- **THEN** the value is non-null and non-empty

#### Scenario: Fallback message when backend sends no message
- **WHEN** the 401 response body contains no extractable message
- **THEN** `sessionExpiredProvider.state` is set to a default string: `"Your session has expired. Please sign in again."`

### Requirement: AuthInterceptor uses onSessionExpired callback with message
The `AuthInterceptor` SHALL replace `onUnauthorized: void Function()` with `onSessionExpired: void Function(String message)`. On a 401 from a non-auth-flow path, it SHALL extract the message from the `DioException` and call `onSessionExpired(message)` exactly once per session.

#### Scenario: First 401 triggers callback
- **WHEN** a 401 DioException arrives on a protected endpoint
- **THEN** `onSessionExpired` is called once with the extracted message
- **THEN** `_isLoggingOut` is set to `true` to prevent repeated calls

#### Scenario: Subsequent 401s are ignored
- **WHEN** a second 401 arrives while `_isLoggingOut == true`
- **THEN** `onSessionExpired` is NOT called again
- **THEN** `sessionExpiredProvider.state` is unchanged

#### Scenario: Auth-flow endpoints are excluded
- **WHEN** a 401 arrives on a path in `_authFlowPaths` (login, OTP, etc.)
- **THEN** `onSessionExpired` is NOT called
- **THEN** the error propagates normally to the caller

### Requirement: SessionExpiredDialog is a non-dismissible blocking overlay
The system SHALL render a `SessionExpiredDialog` widget when `sessionExpiredProvider` is non-null. The dialog MUST NOT be dismissible by tapping outside or pressing back.

#### Scenario: Dialog appears on session expiry
- **WHEN** `sessionExpiredProvider.state` becomes non-null
- **THEN** a full-screen semi-transparent overlay is shown above all app content
- **THEN** a centered card dialog is shown with the message from `sessionExpiredProvider.state`
- **THEN** a single "Sign In Again" button is visible

#### Scenario: Dialog cannot be dismissed without action
- **WHEN** the user taps outside the dialog card
- **THEN** the dialog remains visible
- **WHEN** the user presses the device back button
- **THEN** the dialog remains visible

#### Scenario: User taps "Sign In Again"
- **WHEN** the user taps the "Sign In Again" button
- **THEN** `auth.logout()` is called
- **THEN** `sessionExpiredProvider.state` is reset to `null`
- **THEN** the app navigates to the login screen (GoRouter redirect handles this automatically)

### Requirement: Sync providers MUST NOT surface 401 errors in visible UI state
When a 401 is caught in any background sync provider, it SHALL be silently discarded and MUST NOT be written to any provider state that drives visible error UI.

#### Scenario: Study screen sync catches a 401
- **WHEN** `CourseList._performSync()` or `CourseSearch._performSearch()` catches an `ApiException` with `type == ApiErrorType.unauthorized`
- **THEN** `courseListSyncError` is NOT updated
- **THEN** `CourseSearchState.error` is NOT set
- **THEN** no red error banner appears in `StudyScreen`

#### Scenario: Non-401 sync errors are still shown
- **WHEN** a sync provider catches an error that is NOT `ApiErrorType.unauthorized`
- **THEN** the error is written to state as before (existing behaviour preserved)
