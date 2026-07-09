## Context

The Testpress backend unified Google Sign-In and Registration via the `/api/v2.3/social-auth/` endpoint. The client needs to generate an ID Token using the `google_sign_in` plugin, pass it to the backend under the `access_token` key, and handle the login session appropriately. There is no separate signup endpoint for Google users; the backend automatically handles on-the-fly registration.

## Goals / Non-Goals

**Goals:**
- Enable Google Sign-In on iOS and Android platforms via the `google_sign_in` Flutter package.
- Introduce `loginWithGoogle()` method in the existing `AuthProvider`.
- Wire up the Google Sign In button in the `LoginScreen`.

**Non-Goals:**
- Apple Sign-In or other social auth providers (can be added later).
- Changing the backend registration logic (purely client-side integration).

## Decisions

- **Auth Provider Integration**: We will add a `loginWithGoogle()` function in `authProvider.notifier`. This keeps authentication logic centralized alongside password and OTP flows in `core/lib/data/providers/auth_provider.dart`.
- **Plugin used**: `google_sign_in` official package from flutter.dev.
- **Payload format**: We send `{"provider": "GOOGLE", "access_token": <id_token>}`. Note that the `access_token` key is explicitly required by the backend API, but its value must be Google's JWT `id_token`.

## Risks / Trade-offs

- **[Risk] Audience Mismatch**: The backend will reject tokens if the `serverClientId` isn't provided during `google_sign_in` initialization or if it doesn't match the backend's expected client ID.
  → **Mitigation**: Ensure the Server Client ID is properly passed when instantiating `GoogleSignIn`.
- **[Risk] Parallel Login Constraints**: Similar to password auth, the user might hit parallel login exceptions when logging in via Google.
  → **Mitigation**: Handle `ParallelLoginException` identically to password auth, redirecting to the `LoginActivityScreen`.
