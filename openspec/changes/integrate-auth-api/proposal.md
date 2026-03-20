## Why

Authentication is currently mock-driven and not tied to real backend APIs, so login behavior and route protection do not represent production behavior. We need a complete Auth API flow and app wire-up so authentication state is real, persistent, and enforced consistently.

## What Changes

- Implement Auth API integration for password login, OTP generation, OTP verification, and logout.
- Persist only access token securely using `flutter_secure_storage`.
- Add auth session restoration at app startup and explicit auth state management.
- Wire auth state into router redirects, login/OTP screens, and bootstrap initialization.
- Add endpoint constants in `core/lib/network/api_endpoints.dart` and use `dio` in auth network service.
- Remove refresh-token behavior from scope for this change.

## Capabilities

### New Capabilities
- `auth-api-session`: End-to-end auth session flow with secure token storage and startup restoration.

### Modified Capabilities
- `login-ui`: Login/OTP screens SHALL execute API-backed auth actions through provider/repository.
- `lms-navigation-shell`: Redirect logic SHALL depend on auth provider session state.

## Impact

- Affected code: `packages/core/lib/data/auth/*`, `packages/core/lib/network/*`, auth screens under `packages/profile/lib/screens/*login*` and `otp_screen.dart`, router in `packages/testpress/lib/navigation/app_router.dart`, and app bootstrap provider.
- Dependencies: `dio`, `flutter_secure_storage`.
- Behavior: protected routes rely on real authenticated session state and persisted token presence.
