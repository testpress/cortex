## Context

The profile screen currently features a logout menu item that performs no action. To provide a premium user experience, we need to design a confirmation flow that prevents accidental logouts while maintaining the app's aesthetic consistency.

## Goals / Non-Goals

**Goals:**
- Design a premium logout confirmation UI using an `AppBottomSheet`.
- Define semantic content (icons, text, actions) for the logout prompt.
- Specify the navigation transition back to the unauthenticated home state.

**Non-Goals:**
- Implementation of the actual auth clearing logic in `auth_provider.dart`.
- Any backend or API integration for session invalidation.

## Decisions

### Decision 1: UI Component for Confirmation
**Choice:** `AppBottomSheet`
**Rationale:** Bottom sheets provide a modern, focused experience for critical actions and align with established application interaction patterns.
**Alternatives:** `AlertDialog` (Considered, but less premium).

### Decision 2: Specific UI Elements
**Choice:** Centered layout with warning icon.
**Rationale:** Clear visual warning improves user focus and safety for destructive actions.
- **Icon**: `LucideIcons.alertTriangle` in a 56x56 container (using `design.colors.error` with low opacity background).
- **Text**: Title "Log out?" and detailed message explaining the consequence.
- **Buttons**: Red primary button for "Log out" (includes `logOut` icon) and a standard secondary "Cancel" button.

### Decision 3: Post-Logout Destination
**Choice:** Initial App Route (`/home` in guest state).
**Rationale:** Ensures the user is returned to a safe, neutral state after their session ends.
**Alternatives:** 
- Login Screen: Only appropriate if the app requires login for all features.

## Risks / Trade-offs

- **[Risk]** Redirection logic may conflict with existing protected route guards. → **Mitigation**: Design the navigation to use the root router to clear the history stack if necessary.
- **[Risk]** Visual inconsistency across different device sizes. → **Mitigation**: Use standard `AppBottomSheet` paddings and `design.spacing` tokens.
