## 1. Specification Update

- [x] 1.1 Update `openspec/specs/lms-navigation-shell/spec.md` with orientation-aware navigation requirements.

## 2. Shell Implementation

- [x] 2.1 Refactor `AppShell` in `packages/core/lib/shell/app_shell.dart` to determine layout mode based on orientation (`maxWidth > maxHeight`).
- [x] 2.2 Update `AppShell` build logic to prioritize `AppTabBar` in portrait mode and `AppNavigationRail` in landscape mode.
- [x] 2.3 Ensure `SafeArea` is correctly applied to prevent congestion or overlap across different orientations.

## 3. Layout Polish

- [x] 3.1 Review and adjust `AppTabBar` constraints for large screens in portrait mode to avoid excessive stretching.
- [x] 3.2 Verify side rail behavior on small screens in landscape mode to ensure content is not overly squeezed.
- [x] 3.3 Fix `DashboardHeader` to display hamburger menu on the left in portrait mode and right in landscape mode.

## 4. Verification

- [x] 4.1 Verify layout transitions correctly on mobile device simulation (Portrait/Landscape).
- [x] 4.2 Verify layout correctly displays bottom bar on tablet simulation in portrait mode.

## 5. Refinements

- [x] 5.1 Update `DashboardHeader` to accept `isLandscape` via constructor and remove `isTablet` property.
- [x] 5.2 Update `DashboardDrawer` to accept `isLandscape` via constructor and remove internal `MediaQuery` lookup.
- [x] 5.3 Update `AppShell` and other consumer sites to pass the `isLandscape` flag to these widgets.
- [x] 5.4 Remove all `MediaQuery.of(context).orientation` lookups from these widgets to align with the `LayoutBuilder` design decision.
