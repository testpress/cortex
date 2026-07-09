## 1. Setup & Configuration

- [x] 1.1 Add `google_sign_in` dependency to `packages/core/pubspec.yaml` (or the appropriate package)
- [x] 1.2 Validate iOS `Info.plist` setup (or Android SHA configurations) if applicable

## 2. Authentication Provider

- [x] 2.1 Add `loginWithGoogle()` method in `packages/core/lib/data/providers/auth_provider.dart` (or wherever `authProvider` is defined)
- [x] 2.2 Inside `loginWithGoogle()`, initialize `GoogleSignIn` and perform the native sign-in flow
- [x] 2.3 On success, retrieve the `idToken` from Google auth credentials
- [x] 2.4 Call backend `/api/v2.2/social-auth/` with payload `{"provider": "GOOGLE", "access_token": idToken, "user_id": userId}` to retrieve Testpress token
- [x] 2.5 Ensure the acquired token is persisted for the session

## 3. UI Integration

- [x] 3.1 Update `LoginScreen` in `packages/profile/lib/screens/login_screen.dart` to use `authProvider.notifier.loginWithGoogle()`
- [x] 3.2 Show the standard `_isBusy` loading indicator while Google sign-in is running
- [x] 3.3 Ensure `ParallelLoginException` triggers navigation to the `LoginActivityScreen`
- [x] 3.4 Catch `AuthException` or user cancellation and surface errors to `_errorMessage` appropriately

## 4. Verification

- [ ] 4.1 Verify successful Google Sign-in correctly initiates session and navigates to `/home`
- [ ] 4.2 Verify cancelling the flow does not trigger any uncaught exceptions
- [ ] 4.3 Verify parallel login issues gracefully fallback to the activity restriction screen
