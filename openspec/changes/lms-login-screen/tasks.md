## 1. Setup and Preparation

- [x] 1.1 Add all required localization keys for the complete auth flow (onboarding, signin, signup, forgot password, otp) to `packages/core/lib/l10n/app_en.arb`.
- [x] 1.2 Export new screens (`OnboardingScreen`, `SignupScreen`, `ForgotPasswordScreen`, `OtpScreen`) from `packages/profile/lib/profile.dart`.
- [x] 1.3 Configure routes for `/onboarding`, `/signup`, `/forgot-password`, `/otp` in `packages/testpress/lib/navigation/app_router.dart`.
- [x] 1.4 Remove any existing placeholder or legacy login implementations to ensure a single source of truth.

## 2. UI Implementation (Core Theme)

- [x] 2.1 **Onboarding Screen**: Implement `packages/profile/lib/screens/onboarding_screen.dart` to introduce the app.
- [x] 2.2 **Sign In Screen**: Update `packages/profile/lib/screens/login_screen.dart` with standard sign-in and SSO options, applying `core` theme colors/typography.
- [x] 2.3 **Sign Up Screen**: Implement `packages/profile/lib/screens/signup_screen.dart` for user registration.
- [x] 2.4 **Forgot Password Screen**: Implement `packages/profile/lib/screens/forgot_password_screen.dart` to recover account access.
- [x] 2.5 **OTP Screen**: Implement `packages/profile/lib/screens/otp_screen.dart` deriving layout patterns from the SignIn/SignUp screens but tailored for OTP entry.

## 3. Integration & State

- [x] 3.1 Use strictly `package:core` primitives (`AppText`, `AppTextField`, `AppButton`, `Design.of(context)`) in all new screens.
- [x] 3.2 Implement simple navigation hooks between these screens (e.g., "Don't have an account? Sign up" -> taps to `/signup`).
- [x] 3.3 Implement visual busy states and loading indicators for all primary form actions.

## 4. Route Verification

- [x] 4.1 Verify that the app correctly redirects unauthenticated users to `/onboarding` or `/login`.
- [x] 4.2 Verify navigation flows smoothly between Sign In <-> Sign Up <-> Forgot Password.
