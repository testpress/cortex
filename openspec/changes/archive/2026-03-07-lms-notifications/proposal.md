## Why

The app currently lacks a dedicated Notifications settings screen, so users cannot control key alert preferences in one place. We need this now to complete the Profile settings flow and match the available Figma reference for notification management.

## What Changes

- Add a dedicated Notifications settings screen for LMS users with a header, page title/subtitle, and grouped notification preference rows.
- Implement four toggleable preference controls:
  - Live class reminders
  - Test and assessment alerts
  - Announcements and updates
  - Achievements and badges
- Add entry routing from Profile settings actions into Notifications and back navigation to return to the Profile flow.
- Implement UI using existing Cortex design tokens, typography semantics, accessibility helpers, and neutral primitives with light/dark mode parity.
- Introduce mock/local preference state handling to support interactive toggles in the reference app flow.

## Capabilities

### New Capabilities
- `lms-notifications`: Notification preference management screen and behavior for LMS users.

### Modified Capabilities
- `lms-navigation-shell`: Add/confirm in-shell navigation behavior for opening and closing the Notifications settings screen from Profile-related flows.

## Impact

- **Packages**:
  - `packages/courses`: new notifications screen, view model/state, and supporting UI pieces.
  - `packages/testpress`: route exposure if required for SDK-level navigation wiring.
  - `app`: route registration/wiring only where app shell integration is needed.
- **Design/UX**:
  - Uses Figma reference at `figma/project/src/app/components/NotificationsScreen.tsx`.
  - Must follow runtime design tokens, semantic typography roles, and accessibility semantics from the shared design system.
- **Data**:
  - No backend dependency in this change; uses local/mock state for preference toggles.
- **Risk**:
  - Route-level integration must preserve existing tab shell behavior and Profile return path consistency.
