## Context

When a user logs in, the `/auth-token/` endpoint successfully issues a JWT even if the user has exceeded their maximum allowed parallel logins. The app's `AuthRepository` saves this token and sets `authProvider` state to `true`, which immediately triggers the router to navigate to `/home`. The parallel login restriction only surfaces when subsequent API calls (like fetching the dashboard) return `403 parallel_login_restriction`, placing the user in a broken "zombie" state on the Home screen.

## Goals / Non-Goals

**Goals:**
- Intercept restricted logins proactively, before the `authProvider` state is set to `true`.
- Users with restricted tokens never see the Home screen — they are redirected directly to `LoginActivityScreen` from the login screen.
- Maintain a clean global `AuthState`: the token IS saved to secure storage (so the Dio interceptor can use it for `LoginActivityScreen` requests), but the `authProvider` state is NOT set to `true` until verification passes.
- The exact same token remains valid once the user logs out of other devices. No re-login is required.

**Non-Goals:**
- Changing the backend token generation or login activity enforcement.
- Handling global session expiry or token refresh.
- Changing any API data source methods (`getProfile`, `getLoginActivity`, etc.).

## Decisions

**1. Verification inside `AuthNotifier` before setting state**
In `auth_provider.dart`, both `loginWithPassword` and `verifyOtp` currently call `_repository.loginWithPassword(...)` and then immediately set `state = AsyncData(true)`. We insert a `/me/` profile fetch between the token save and the state change.

*Rationale:* The token must already be in secure storage before calling `/me/`, because Dio's `AuthInterceptor` reads from secure storage to attach the `Authorization` header. By saving first and then verifying, we avoid any need for "temporary token" parameters in API methods. If verification fails, we clear the token and throw — the state never becomes `true`.

**2. A new typed exception: `ParallelLoginException`**
The `Auth` notifier throws a `ParallelLoginException` (extending `AuthException`) when `getProfile()` returns a `403` with `error_code: "parallel_login_restriction"`. The login screens catch this specific type and navigate to `LoginActivityScreen`.

*Rationale:* Using a distinct exception type keeps the catch blocks in the UI clean and avoids stringly-typed error_code checks scattered across screens.

**3. Token is already saved when `LoginActivityScreen` is shown**
Since the token was saved to secure storage before verification, the Dio interceptor will correctly attach it to all requests made inside `LoginActivityScreen` (fetching active sessions, deleting sessions, "logout all other devices"). This means **no changes to `LoginActivityScreen`** are required.

*Rationale:* The existing `LoginActivityScreen` already calls `repo.getLoginActivity()` and `authProvider.notifier.logoutOtherDevices()` — both use the global token automatically.

**4. After "Logout other devices", navigate to Home normally**
`LoginActivityScreen` already calls `logoutOtherDevices()` and shows a success toast. After this, the user has cleared the restriction. We add a `context.go('/home')` call on success, which will work because the token was already saved and the authProvider state will be set.

Wait — the authProvider state was NOT set to `true` because verification failed. So we need to set it after logoutOtherDevices succeeds.

*Correction:* After a successful `logoutOtherDevices()` call in `LoginActivityScreen`, we call `ref.read(authProvider.notifier).markAuthenticated()` — a new thin method that simply sets `state = AsyncData(true)`.

## Risks / Trade-offs

- **Risk: Token is in storage but app is "unauthenticated".** Between the `saveToken()` call and the failed `/me/` check, the token exists in storage. If the app crashes here, on cold-start the `isUserLoggedIn()` check returns `true` and the router lands on Home, which then hits the same `403`. This is handled by Option A's `appInitialization` as a safety net — that's a potential follow-up.
  - *Mitigation (current):* On cold-start with a restricted token, the home screen widgets will fail. Users can navigate to `LoginActivityScreen` from the profile tab and resolve it manually. This is an acceptable limitation for now.
- **Risk: `markAuthenticated()` called without a valid server round-trip.** After `logoutOtherDevices()`, we trust the backend to have cleared the restriction. We don't re-verify with `/me/`. This is acceptable.
  - *Mitigation:* If the backend `logoutOtherDevices()` call succeeds (no exception), the restriction is lifted.
