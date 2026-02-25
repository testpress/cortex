# Tasks: Home Screen Sidebar Menu (`lms-home-drawer`)

## 1. Core Component Development (`packages/core`)

- [x] 1.1 Implement `AppDrawer` base widget with custom slide-in animation and backdrop overlay.
- [x] 1.2 Implement `AppDrawerItem` for individual list items with hover/press states and custom coloring for errors.
- [x] 1.3 Implement `AppDrawerDivider` using `design.colors.border`.
- [x] 1.4 Add Theme Toggle logic within the drawer to interact with `DesignProvider`.

## 2. Integration & Dashboard Updates (`packages/courses`)

- [x] 2.1 Update `DashboardHeader` to accept an `onMenuPressed` callback or integrate with a scaffold key.
- [x] 2.2 Define the menu data structure based on the specifications (Sections 1, 2, and 3).
- [x] 2.3 Integrate `AppDrawer` into `PaidActiveHomeScreen`.

## 3. Verification & Polish

- [x] 3.1 Verify item spacing and font sizes match the 15px/semantic role requirements.
- [x] 3.2 Ensure "Logout" and "Red" items use the correct error tokens in both themes.
- [x] 3.3 Verify backdrop tap-to-close behavior.
- [x] 3.4 Check accessibility labels for all navigation items.
