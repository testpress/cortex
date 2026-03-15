# Proposal: lms-login-screen

## Why
The application requires a comprehensive authentication flow. This change defines the initial implementation of the Onboarding and Authentication Screens in `packages/profile`, using shared primitives from `packages/core` to ensure brand consistency and accessibility.

## What Changes
- Implement a series of screens to handle the complete onboarding and login journey:
  - **Onboarding/Splash Screen**: An initial screen to introduce the app.
  - **Sign In Screen**: Standard login with email/password and SSO options.
  - **Sign Up Screen**: Registration screen for new users.
  - **Forgot Password Screen**: Flow to recover account access.
  - **OTP Verification Screen**: Flow for mobile number login and two-step verification.
- Define visual states for form validation, error messaging, and in-flight busy indicators.
- Localize all user-facing strings for the flows.
- Configure all related `/login`, `/signup`, `/forgot-password`, `/verify-otp`, and `/onboarding` routes in the application router.

## Capabilities

### New Capabilities
- `auth-ui`: Defines the visual layout, interaction states, branding structure, and localization requirements for the complete authentication journey (Onboarding, Sign In, Sign Up, Forgot Password, OTP).

### Modified Capabilities
- _None._

## Impact
- `packages/profile`: New screens for Onboarding, Registration, Forgot Password, and OTP, alongside the updated Sign In screen.
- `packages/testpress`: Registration of new auth routes.
- `packages/core`: Localization resources.
