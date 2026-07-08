## 1. Core UI Components

- [x] 1.1 Create or update the standard text field widget in `packages/core` to support specific borders, typographies (Inter/Plus Jakarta Sans), and shadows from Figma.
- [x] 1.2 Create or update the primary action button with a linear gradient (`#1d61e7` to `#375dfb`) and secondary buttons in `packages/core`.
- [x] 1.3 Create a new 4-digit OTP input widget in `packages/core`, ensuring it precisely displays 4 boxes.

## 2. Dynamic Branding Setup

- [x] 2.1 Extract the logo and institute name rendering logic from the existing `LoginScreen` into a new, reusable `AuthHeader` or `AuthBranding` widget.
- [x] 2.2 Style the `AuthBranding` widget to sit cleanly at the top of the screen without the legacy carousel elements, matching the spacing from Figma.

## 3. Login Screens Revamp

- [x] 3.1 Update the primary `LoginScreen` in `packages/profile` to render the dynamic login options (Mobile, Email, Google) using the new button components from 1.2, stacked vertically below the `AuthBranding` widget.
- [x] 3.2 Revamp the password login screen (e.g. `PasswordLoginScreen`) to include the `AuthBranding` header, Email/Password input fields (from 1.1), and the primary Login button.
- [x] 3.3 Ensure the password field obscures text and includes a visibility toggle icon.
- [x] 3.4 Revamp the OTP Verification screen (e.g. `VerifyOtpScreen`) to use the 4-digit OTP input widget from 1.3, the `AuthBranding` header, and the "Resend code" UI elements.
- [x] 3.5 Verify all spacing and paddings align with the dimensions specified in the Figma design across all three revamped screens.
