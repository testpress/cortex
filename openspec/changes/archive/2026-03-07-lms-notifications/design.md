## Context

`lms-profile-paid-active` introduces settings actions that include "Notifications", but the app does not yet provide a dedicated Notifications preferences screen. Figma already defines the expected screen structure and behavior in `figma/project/src/app/components/NotificationsScreen.tsx`: sticky back header, title/subtitle, and a card containing four preference rows with icon badges and toggle switches.

This change must stay within Cortex architecture constraints:
- SDK-first boundaries (`courses` implements domain UI, `testpress` exports, app consumes routes)
- runtime design tokens and semantic text roles from the shared design system
- core primitives and accessibility wrappers from `packages/core`
- accessibility semantics and motion preference compliance
- no Material-style design language as the visual foundation

## Goals / Non-Goals

**Goals:**
- Deliver a Notifications settings screen with parity to the Figma reference for layout, spacing, and hierarchy.
- Provide four interactive toggles with local/mock state:
  - Live class reminders
  - Test and assessment alerts
  - Announcements and updates
  - Achievements and badges
- Integrate navigation entry from profile flow and provide predictable back behavior to the originating screen.
- Keep implementation reusable and testable in `packages/courses`.

**Non-Goals:**
- Persisting preferences to backend APIs or local DB in this change.
- Building notification inbox/history feeds.
- Adding push-notification permission prompts or platform-native settings deep links.
- Redesigning profile architecture or app shell navigation model.

## Decisions

### 1. Screen ownership in `packages/courses`
- Decision: Implement the notifications preferences screen and supporting row/toggle UI inside `packages/courses`.
- Why: Notifications preferences are part of LMS user-domain flows and already launched from profile domain UI.
- Alternative considered: Implement in `packages/core` as a generic settings primitive.
- Why not: Core should remain platform/design primitives, not domain-specific settings content.

### 2. Local state model for v1 toggles
- Decision: Use local/mock state with initial defaults matching the reference behavior.
- Why: Proposal scope explicitly excludes backend integration while requiring interactive controls.
- Alternative considered: Hardcoded static on/off UI without state.
- Why not: Fails expected interactivity and weakens future persistence integration path.

### 3. Route integration through existing shell flow
- Decision: Add notifications route within existing navigation structure used by profile-driven settings screens, with explicit back callback/pop behavior.
- Why: Keeps navigation consistent with current shell/tab architecture and avoids introducing another navigation paradigm.
- Alternative considered: Open Notifications as a full-screen modal outside shell.
- Why not: Adds complexity and risks inconsistent behavior across profile flows.

### 4. Figma mapping through tokens/primitives, not hardcoded styling
- Decision: Implement visual parity using existing token groups and core primitives, including semantic typography and status/icon colors.
- Why: Preserves white-label/runtime theming and dark-mode consistency while matching Figma intent.
- Alternative considered: Copying raw Figma pixel/color values directly into widget constants.
- Why not: Violates repo guardrails and reduces maintainability.

### 5. Accessibility-first toggle rows
- Decision: Each preference row uses semantic labeling and button/switch semantics with minimum touch targets and motion-aware transition behavior.
- Why: Required by core accessibility constraints; avoids regressions for screen-reader and reduced-motion users.
- Alternative considered: Visual-only toggles with gesture handlers.
- Why not: Inaccessible and not compliant with project standards.

## Risks / Trade-offs

- **[Risk]** Figma parity drift during implementation translation.  
  **Mitigation**: Create explicit mapping table in specs and verify spacing/typography/icon sizes against the Figma component.

- **[Risk]** Navigation regression when launched from multiple profile variants.  
  **Mitigation**: Define route/back scenarios in specs and add widget/navigation tests for profile entry and return.

- **[Risk]** Local state defaults may diverge from future backend values.  
  **Mitigation**: Isolate toggle state in a dedicated model/provider so persistence can be swapped in without UI restructuring.

- **[Risk]** Dark-mode color mismatch if icon badges bypass tokens.  
  **Mitigation**: Constrain row/icon colors to semantic token mappings and existing subject/status palettes.
