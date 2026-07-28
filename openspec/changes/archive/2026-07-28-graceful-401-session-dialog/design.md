## Context

The app uses a global `AuthInterceptor` on Dio that catches 401 responses and immediately calls `onUnauthorized()` → `auth.logout()`. The error still propagates back to callers, causing visible error banners before the widget tree is rebuilt.

`ApiException.fromDioException()` already extracts the human-readable message via `extractApiMessage()`. So `ApiException.message` for a 401 is already clean (e.g. `"Please Login and try again."`).

`_AppShellBuilder` in `app_router.dart` already hosts a global bottom sheet overlay for logout confirmation — the same pattern applies for the session dialog.

## Goals / Non-Goals

**Goals:**
- On any 401: show one blocking dialog app-wide with the backend's message.
- User must explicitly tap "Sign In Again" to trigger logout.
- No error banners from sync providers on 401.
- Dialog fires only once even if multiple 401s arrive simultaneously.

**Non-Goals:**
- Changing the logout state machine or GoRouter redirect logic.
- Token refresh / silent re-auth.
- Showing the dialog on 401s from auth-flow endpoints (login, OTP, etc.).

## Decisions

### Decision: `sessionExpiredProvider` holds `String?` not `bool`

Holding the message string (not just a flag) lets the dialog render the backend message directly. `null` = no dialog shown. Non-null string = dialog is visible with that message.

**Alternative**: Separate `bool` flag + `String` message as two providers.
**Rejected**: Unnecessary complexity; a nullable string is a clean sentinel.

### Decision: Callback renamed from `onUnauthorized` to `onSessionExpired(String message)`

The new callback signature passes the extracted message. `AuthInterceptor` extracts the message from `DioException` (or falls back to a default) before calling the callback.

**Alternative**: Keep `onUnauthorized()` with no args, read message from somewhere else.
**Rejected**: Coupling concern — the interceptor already has the message; passing it is cleaner.

### Decision: Suppress 401 errors in sync providers before they reach UI state

In `course_list_provider._performSync()` and `_performSearch()`, if the caught exception is `ApiErrorType.unauthorized`, skip writing to `courseListSyncError` / `state.error`. The dialog handles UX globally.

Detection: `e is ApiException && e.type == ApiErrorType.unauthorized`, with fallback for raw `DioException` with `statusCode == 401`.

### Decision: Dialog is rendered as a Stack overlay in `_AppShellBuilder`

Same pattern as the logout bottom sheet. The `sessionExpiredProvider` is watched inside `_AppShellBuilder`; when non-null, a full-screen semi-transparent overlay + centered dialog card is shown above all content.

**Alternative**: Use `showDialog()` imperatively via a navigator listener.
**Rejected**: Declarative is safer — avoids context timing issues with GoRouter and avoids needing a BuildContext at interceptor time.

### Decision: `SessionExpiredDialog` lives in `packages/core/lib/widgets/`

It depends only on core design tokens and is reusable across any package.

## Risks / Trade-offs

- **Risk**: Multiple 401s fire before `sessionExpiredProvider` is set → multiple `setState` calls. The `_isLoggingOut` guard in `AuthInterceptor` already prevents multiple `onSessionExpired` calls. The provider itself is idempotent (same message written twice is fine).
- **Risk**: 401 from an auth-flow endpoint triggers the dialog. → Mitigated by the existing `_authFlowPaths` skip list in `AuthInterceptor`.

## Migration Plan

1. Add `sessionExpiredProvider` to `core`.
2. Update `AuthInterceptor` callback signature.
3. Update `dio_provider.dart` wiring.
4. Add `SessionExpiredDialog` widget in `core`.
5. Update `_AppShellBuilder` to watch provider and render overlay.
6. Suppress 401 errors in `course_list_provider.dart`.
7. Delete the old `suppress-401-error-display` change (it is superseded by this one).
