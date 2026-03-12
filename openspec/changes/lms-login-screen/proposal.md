# Proposal: lms-login-screen

## Why
The application requires a primary authentication entry point. This change defines the initial implementation of the Login Screen in `packages/profile`, using shared primitives from `packages/core` to ensure brand consistency and accessibility from the start.

## What Changes
- Implement the `LoginScreen` in `packages/profile` using core primitives.
- Add mode switching between Password and OTP entry paths.
- Define visual states for form validation, error messaging, and in-flight busy indicators.
- Localize all user-facing strings for the login flow.
- Configure the `/login` route in the application router.

## Capabilities

### New Capabilities
- `login-ui`: Defines the visual layout, interaction states, and localization requirements for the login screen.

### Modified Capabilities
- _None._

## Impact
- `packages/profile`: New screen implementation and exports.
- `packages/testpress`: Route registration and import update.
- `packages/core`: Localization resources.
