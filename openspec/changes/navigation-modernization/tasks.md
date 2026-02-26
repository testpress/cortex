# Tasks: Navigation Modernization

## 1. Research & Analysis
- [x] Document existing `AppShell` constraints.
- [x] Research Instagram transition timings and easing.

## 2. Core Components (`packages/core`)
- [x] Implement `AppNavigationRail` for tablet/desktop layout.
- [x] Add `fullPage` mode support to `AppDrawer`.
- [x] Refactor `AppShell` into `AdaptiveAppShell`.

## 3. Integration & Adaptive Logic
- [x] Implement layout switching at `600px` breakpoint.
- [x] Update `DashboardHeader` to toggle `fullPage` settings.
- [x] Verify `AppRouter` compatibility with shell changes.

## 4. Verification & Polish
- [x] Test on tablet/desktop widths.
- [x] Verify accessibility labels for new navigation rail.
- [x] Performance check for full-page transitions.
- [x] Fix landscape Safe Area "chopping" (blunt cut on right side).
- [x] Synchronize drawer slide direction with trigger location (Right-to-Left in landscape).
- [x] Integrate `PopScope` for drawer dismissal via back gestures/buttons.
- [x] Replace close icon with "Back Arrow" navigation in full-page mode.
