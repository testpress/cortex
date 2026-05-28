## Why

The exam/test screen's section filter uses an ad-hoc pill style with a collapse/expand chevron toggle that feels visually heavy and inconsistent with the rest of the app. The study page's `ChaptersFilterTabBar` uses a cleaner, compact horizontally-scrollable pill row with no collapse toggle — this pattern should be adopted in the exam player for visual consistency.

## What Changes

- Remove the expand/collapse toggle behaviour from `SectionsTabBar` — the tab row should always be visible (no chevron, no collapsed state).
- Replace the custom pill rendering inside `SectionsTabBar` with pills that match the `ChaptersFilterTabBar` / `_FilterTab` style: `surfaceVariant` background for inactive, `textPrimary` background for active, `onPrimary`/`card` foreground text, `design.radius.pill` border-radius, `AppText.label` for text, and `AppFocusable` + `AppSemantics.button` wrappers.
- Remove the `ShaderMask` right-fade from the scroll area — keep a simple `SingleChildScrollView` horizontally (matching the study filter pattern).
- Remove the `isExpanded` / `onExpandChanged` props from `SectionsTabBar` and clean up the collapsed-state branch in `TestDetailScreen`.
- Container height adjusts to pill content height (no fixed `50 px` hard-coded row height).

## Capabilities

### New Capabilities
<!-- None — this is a pure UI reskin within an existing component, no new spec-level behaviour -->

### Modified Capabilities
- `lms-test-detail`: The sections/subjects filter strip visual style is changing — pills now match the study-page filter pattern rather than the previous custom style.

## Impact

- `packages/exams/lib/widgets/test_detail/sections_tab_bar.dart` — primary change.
- `packages/exams/lib/screens/test_detail_screen.dart` — remove `isExpanded` / `onExpandChanged` state and props.
- No API, routing, or data-layer changes.
- No other screens affected.
