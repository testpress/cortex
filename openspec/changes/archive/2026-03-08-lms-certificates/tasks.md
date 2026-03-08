## 1. Routing and Entry Integration

- [x] 1.1 Add Profile-tab routing for certificates list and certificate preview flow.
- [x] 1.2 Connect Profile "Your certificates" action to open the certificates screen.
- [x] 1.3 Implement back behavior from certificates and preview screens to preserve profile tab stack state.

## 2. Certificates List Screen

- [x] 2.1 Create certificates list screen structure (header, title/subtitle, card list) matching Figma hierarchy.
- [x] 2.2 Build certificate card UI variants for unlocked and locked states using shared design tokens.
- [x] 2.3 Implement card actions (view, download placeholder, continue placeholder) with proper state gating.

## 3. Certificate Preview Screen

- [x] 3.1 Create certificate preview screen with close/back header and certificate detail layout.
- [x] 3.2 Render certificate metadata (learner name, course, completion date, certificate ID) from local/mock model.
- [x] 3.3 Add preview action buttons (download/share as UI placeholders) and ensure they are accessible.

## 4. Paid-Active Data Mapping

- [x] 4.1 Add local/mock certificate model(s) for paid-active unlocked and locked entries.
- [x] 4.2 Implement list behavior for paid-active unlocked and locked card states.
- [x] 4.3 Ensure locked/unlocked transitions and progress indicators match expected reference behavior.

## 5. Localization, Accessibility, and Verification

- [x] 5.1 Move all certificates and preview copy to localization resources and use localized strings in UI.
- [x] 5.2 Add semantic labels/state and verify minimum touch targets for all interactive controls.
- [x] 5.3 Add widget tests for rendering, variant states, actions, and navigation (Profile -> Certificates -> Preview -> back).
- [x] 5.4 Run relevant test suites and verify no regressions.
