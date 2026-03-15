## Context
The application requires a comprehensive authentication flow. This design details the implementation of full auth flows (Onboarding, Sign In, Sign Up, Forgot Password, OTP) in `packages/profile`, leveraging shared primitives from `packages/core`.

## Goals / Non-Goals

**Goals:**
- Implement an **Onboarding** screen flow.
- Implement a **Sign In** screen.
- Implement a **Sign Up** screen.
- Implement a **Forgot Password** screen.
- Implement an **OTP** screen derived from the visual language of the aforementioned screens.
- Ensure all screens use our existing `packages/core` brand colors and typography tokens to provide a unified look-and-feel.
- Ensure all visual states (idle, busy, error, success) are correctly modeled.

**Non-Goals:**
- Implementing production API calls (these will be stubbed or handled in a separate change).
- Redesigning the core design system's primitive components.

## Decisions

- **Layering**: Screens will reside in `packages/profile/lib/screens/` (e.g., `onboarding_screen.dart`, `login_screen.dart`, `signup_screen.dart`, `forgot_password_screen.dart`, `otp_screen.dart`).
- **Primitives**: Use `AppText`, `AppTextField`, and `AppButton` from `packages/core`. Incorporate our core theme colors (e.g., `design.colors.primary`, `design.colors.surface`) for all layout elements.
- **State Management**: Use `ConsumerStatefulWidget` (Riverpod) for local UI states.
- **Routing**: Utilize deep links/named routes for each auth step instead of a single embedded `PageView` to allow clean linking and state restoration.
- **Localization**: All copy must come from `AppLocalizations`.

## Risks / Trade-offs

- [Risk] Layouts might require adjustment across different device form factors. -> Mitigation: Ensure adequate use of SafeArea, flexible padding, and responsive constraints instead of hardcoded dimensions.
