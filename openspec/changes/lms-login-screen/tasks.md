## 1. Setup and Preparation

- [x] 1.1 Create the `LoginScreen` in `packages/profile/lib/screens/login_screen.dart` using core primitives.
- [x] 1.2 Export `LoginScreen` from `packages/profile/lib/profile.dart` to expose it for shell-level routing.
- [x] 1.3 Configure `/login` route in `packages/testpress/lib/navigation/app_router.dart` using the `profile` package export.
- [x] 1.4 Add all required localization keys for login flows (username, password, otp, buttons) to `packages/core/lib/l10n/app_en.arb`.
- [x] 1.5 Remove any existing placeholder or legacy login implementations. to ensure a single source of truth.

## 2. UI Implementation (packages/profile)

- [x] 2.1 Develop the `LoginScreen` UI strictly using `package:core` primitives (`AppText`, `AppTextField`, `AppButton`).
- [x] 2.2 Implement the mode toggle logic between Password and OTP entry forms.
- [x] 2.3 Implement visual busy states and loading indicators for all primary login actions.
- [x] 2.4 Apply brand-consistent styling (gradients, card aesthetics) based on the `packages/core` design tokens.

## 3. Route Verification

- [x] 3.1 Verify that `/login` navigates to the new implementation in `packages/profile`.
- [x] 3.2 Ensure redirect logic correctly sends unauthenticated users to the new login screen.
