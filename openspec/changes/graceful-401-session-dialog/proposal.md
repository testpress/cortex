## Why

When the backend invalidates a session token, any in-flight API call returns a 401 with a human-readable message (e.g., `"Please Login and try again."`). Today the app:
1. Flashes the raw JSON error object in a red banner on screen
2. Immediately auto-logs out the user with no explanation

This is confusing and feels like a crash. The fix is to intercept 401s globally, suppress all error UI, and show a single non-dismissible dialog that displays the backend message and gives the user one clear action: sign in again.

## What Changes

- `AuthInterceptor.onUnauthorized` callback is replaced with `onSessionExpired(String message)` — passes the extracted API message instead of calling logout directly.
- A new `sessionExpiredProvider` (`StateProvider<String?>`) is added in `core` to hold the expiry message. `null` = no dialog. Non-null = show dialog with that message.
- `dio_provider.dart` is updated to wire the new callback: set `sessionExpiredProvider.state = message` on 401.
- `_AppShellBuilder` in `app_router.dart` watches `sessionExpiredProvider` and renders a non-dismissible `SessionExpiredDialog` overlay when non-null.
- The dialog displays the API message and a "Sign In Again" button. Tapping calls `auth.logout()`.
- All sync providers (`course_list_provider.dart`) suppress 401 errors — they must NOT write to visible error state when a 401 fires (since the dialog handles it globally).

## Capabilities

### New Capabilities
- `session-expired-dialog`: A global, non-dismissible dialog overlay that intercepts 401 Unauthorized responses, displays the backend-provided message, and gives the user a single "Sign In Again" action to trigger logout.

### Modified Capabilities
- None — the logout flow and auth state machine are unchanged.

## Impact

- `packages/core/lib/network/auth_interceptor.dart` — callback signature change
- `packages/core/lib/network/dio_provider.dart` — wiring the new callback
- `packages/core/lib/data/auth/` — new `sessionExpiredProvider`
- `packages/testpress/lib/navigation/app_router.dart` — dialog overlay in `_AppShellBuilder`
- `packages/courses/lib/providers/course_list_provider.dart` — suppress 401 errors from surfacing in state
- A new `SessionExpiredDialog` widget (in `core` or `testpress`)
