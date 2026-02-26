# Design: Navigation Modernization

## Adaptive Shell Layout
The application shell adapts its navigation structure based on the viewport width to optimize for various device types.

### Breakpoints
- **Compact (Mobile)**: Default layout.
- **Medium (Tablet/Landscape)**: Triggers at `design.layout.tabletBreakpoint` (default: **600.0**).

### Mobile Layout
- **Navigation**: `AppTabBar` docked at the bottom.
- **Header**: `DashboardHeader` with "Hamburger" menu icon.

### Tablet Layout
- **Navigation**: `AppNavigationRail` docked on the left.
- **Main Content**: Pushed to the right of the rail.
- **Styling**:
  - Width: `80.0`.
  - Background: `design.colors.surface`.
  - **Scrollable**: Uses `SingleChildScrollView` to prevent overflows on short landscape screens.
  - Icons: Stacked vertically with 16.0 padding (dense layout).
  - Active State: Highlighted icon (primary color) with text label.

## Instagram-Style Settings (Full-Page)
Refactors the existing drawer into an immersive, full-screen settings view.

### Visuals
- **Width**: `100%` of viewport.
- **Background**: `design.colors.surface`.
- **Entrance**: Immersive slide from left (portrait) or right (landscape) to match the "Hamburger" trigger location.
- **Exit**: 
  - **Header**: Uses a "Back" button (arrow) instead of "X" to emphasize the new-screen feel.
  - **Gesture**: Supports system-level back gesture/buttons via `PopScope`.

### Animation Details
- **Duration**: `300ms` (standard motion).
- **Curve**: `Curves.easeInOutCubic` or `design.motion.emphasized` for a premium feel.

## Component Architecture
- `AdaptiveAppShell`: Wraps the entire app and listens to `LayoutBuilder` for breakpoint changes.
- `AppNavigationRail`: A new vertical navigation component. Shared logic with `AppTabBar` for tracking active items.
