## Why

The app currently supports traditional username/password authentication, but users expect modern, seamless login experiences. Integrating Google Sign-In will reduce friction during onboarding, as it automatically registers new users or logs in existing ones via a unified backend endpoint (`/api/v2.2/social-auth/`), ultimately improving user acquisition and retention rates.

## What Changes

- Integrate the `google_sign_in` Flutter package to handle the native Google authentication flow.
- Add Google login capability to the AuthProvider (Riverpod state management) to communicate with the Testpress social auth API.
- Update the `LoginScreen` to trigger the Google login flow when the existing Google Sign-In button is pressed, rather than just navigating away.
- Handle potential errors (e.g., audience mismatch, user cancellation) gracefully in the UI.

## Capabilities

### New Capabilities
- `google-auth`: Handles the native Google Sign-In flow, ID token retrieval, and backend authentication mapping via the `/api/v2.2/social-auth/` endpoint.

### Modified Capabilities
- `login-ui`: Updates the existing UI to connect the Google Sign-In button to the new `google-auth` capability and display relevant loading states and error messages.

## Impact

- **Dependencies**: Adds `google_sign_in` package to the project.
- **APIs**: Integrates with `POST /api/v2.2/social-auth/` for unified login/signup.
- **Code**: Modifies `packages/profile/lib/screens/login_screen.dart` and the authentication provider (likely in `packages/core/lib/data/providers/auth_provider.dart` or similar).
- **Configuration**: Will require Google Cloud / Firebase console setup for Client IDs across iOS and Android, including updating `Info.plist` and registering keystore SHA fingerprints.
