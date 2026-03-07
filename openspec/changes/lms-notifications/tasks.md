## 1. Routing and Screen Entry

- [x] 1.1 Add Notifications route wiring in the existing profile/shell navigation flow.
- [x] 1.2 Connect the Profile "Notifications" action to open the Notifications screen.
- [x] 1.3 Implement back navigation from Notifications to return to the previous Profile state without resetting other tab stacks.

## 2. Notifications Screen Structure

- [x] 2.1 Create `NotificationsScreen` in `packages/courses` with a sticky back header, title, and subtitle matching the Figma reference structure.
- [x] 2.2 Build the settings container card and row layout using core primitives and runtime design tokens (no hardcoded visual constants where tokens exist).
- [x] 2.3 Add the four preference rows: live class reminders, test and assessment alerts, announcements and updates, achievements and badges.

## 3. Toggle State and Interaction

- [x] 3.1 Introduce local/mock state model for notification preferences with initial defaults (on, on, off, on).
- [x] 3.2 Wire each row toggle to update only its own category state.
- [x] 3.3 Ensure toggle visuals reflect on/off state correctly in both light and dark modes.

## 4. Accessibility and Token Compliance

- [x] 4.1 Add semantic labels and state semantics for each interactive toggle and row action.
- [x] 4.2 Verify minimum touch target sizing and motion preference compliance for toggle interactions.
- [x] 4.3 Ensure typography, spacing, colors, radius, and icon styling use shared design tokens and semantic text roles.

## 5. Verification and Test Coverage

- [x] 5.1 Add widget tests for Notifications screen rendering (header, title/subtitle, four rows).
- [x] 5.2 Add interaction tests for independent toggle state updates and initial default values.
- [x] 5.3 Add navigation tests for Profile -> Notifications entry and Notifications -> Profile back behavior.
- [x] 5.4 Run relevant test suites and verify no regressions in existing profile/shell flows.
