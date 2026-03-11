## 1. Core auth infrastructure

- [x] 1.1 Add shared auth client methods for credential login, OTP generation, and OTP verification endpoints.
- [x] 1.2 Add session storage for token and metadata with initialize, persist, and clear operations.
- [x] 1.3 Add shared network client wiring to attach `Authorization: JWT <token>` from active session.

## 2. Shell login experience

- [x] 2.1 Add login screen in `testpress` with username/password and OTP controls using existing core primitives.
- [x] 2.2 Add validation and in-flight UI disabling so repeated taps do not trigger duplicate calls.
- [x] 2.3 Map auth errors (invalid credentials, validation, throttle, lockout) into clear UI messages.
- [x] 2.4 Localize login screen user-facing strings and remove hardcoded login copy.

## 3. Routing and startup integration

- [x] 3.1 Add startup initialization for session/config loading before app route evaluation.
- [x] 3.2 Add route redirect behavior for `/login` when no session exists and authenticated shell routes when session exists.
- [x] 3.3 Ensure logout clears active session and returns user to login route.

## 4. Verification

- [x] 4.1 Run static analysis and fix any compile/type issues.
- [x] 4.2 Verify credential and OTP flows (success + error paths) with one-request-per-intent behavior.

## 5. User profile hydration

- [x] 5.1 Add `GET /api/v2.5/me/` fetch in auth infrastructure and map response to `UserDto`.
- [x] 5.2 Remove mock-user default usage in auth state and hydrate user state from `/me` after login/startup.
- [x] 5.3 Persist mapped `UserDto` in session storage and load cached profile during startup before `/me` refresh.
- [x] 5.4 Replace dynamic login success payload handling with a typed login response model.
- [x] 5.5 Use a single shared user hydration method for startup and post-login flows.
