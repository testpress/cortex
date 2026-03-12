## Context
The application requires a primary authentication entry point. This design details the initial implementation of the Login Screen in `packages/profile`, leveraging shared primitives from `packages/core` to ensure brand consistency and accessibility from the start.

## Goals / Non-Goals

**Goals:**
- Implement a responsive, brand-aligned login layout with support for both credential and OTP entry.
- Ensure all visual states (idle, busy, error, success) are correctly modeled.
- Register the `/login` route in the application router.

**Non-Goals:**
- Implementing production API calls (these will be stubbed or handled in a separate change).
- Redesigning the core design system.

## Decisions

- **Layering**: The Screen will reside in `packages/profile/lib/screens/login_screen.dart`.
- **Primitives**: Use `AppText`, `AppTextField`, and `AppButton` from `packages/core`.
- **State Management**: Use `ConsumerStatefulWidget` (Riverpod) for local UI states like `isOtpMode` and `isBusy`.
- **Localization**: All copy must come from `AppLocalizations`.

## Risks / Trade-offs

- [Risk] UI might need changes once real API constraints are known. -> Mitigation: Follow the existing design patterns and keep the form structure flexible.
