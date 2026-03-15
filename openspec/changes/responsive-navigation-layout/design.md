## Context

The current `AppShell` implementation relies on a fixed width breakpoint (`600.0`) to choose between `AppTabBar` (bottom) and `AppNavigationRail` (side). This results in a suboptimal experience on devices like tablets in portrait mode, where users expect a bottom bar, and mobiles in landscape mode, where vertical space is scarce.

## Goals / Non-Goals

**Goals:**
- Implement orientation-responsive navigation layout.
- Prioritize bottom navigation for portrait and side rail for landscape.
- Ensure the layout remains clean and functional on all form factors.

**Non-Goals:**
- Changing the actual content of the navigation items.
- Changing the design of `AppTabBar` or `AppNavigationRail` themselves.

## Decisions

### 1. Orientation Detection via LayoutBuilder
Instead of relying on `MediaQuery.of(context).orientation`, we will continue using `LayoutBuilder` which is already wrapping the `AppShell` build logic. This allows the layout to respond to its parent's constraints, which is more robust for split-screen or multi-window modes. 

**Refinement:** The `isLandscape` (or equivalent) flag MUST be passed down from the `AppShell` (the constraints provider) to children like `DashboardHeader` and `DashboardDrawer`. These children should remove dependency on `MediaQuery.of(context).orientation` and legacy `isTablet` flags.

**Rationale:**
- `constraints.maxWidth > constraints.maxHeight` effectively identifies landscape mode.
- It avoids unnecessary `MediaQuery` lookups if the parent provides the constraints.
- Centralizing layout logic in the shell ensures consistency across all sub-components.

### 2. Layout Structure Refresh
The `AppShell` will be updated to:
- Use `Row` + `NavigationRail` when `maxWidth > maxHeight`.
- Use `Column` + `BottomNavigationBar` when `maxWidth <= maxHeight`.

### 3. Congestion Mitigation
To avoid "congestion", we will:
- Center the `AppTabBar` content or ensure it doesn't stretch awkwardly on very wide portrait screens (e.g. large tablets).
- Ensure `SafeArea` handles the system notches and home indicators correctly in both orientations.

## Risks / Trade-offs

- **[Risk] Wide Portrait Screens** → Small tablets or foldable devices in portrait might have enough width for a rail but will be forced to use a bottom bar.
  - *Mitigation*: The user explicitly asked for bottom bar in vertical mode, so we follow that preference.
- **[Risk] Very Small Landscape Screens** → On very small phones in landscape, the side rail might take up too much horizontal space.
  - *Mitigation*: We will review the `railWidth` and ensure the content area remains usable.

### 4. Avoiding Nested Shells for Content Pages
Content pages managed by the router (via `navigationShell`) should not contain their own `AppShell` instance. This prevents "double-shelling" where multiple layers of padding and safe areas are applied recursively, causing layout offsets (e.g., the large gap in landscape mode).

**Rationale:**
- The global router-level `AppShell` already manages top-level layout concerns (Side Rail, Bottom Bar, Safearea).
- Content pages should use standard `Container` or `Column` layouts to avoid redundant safe area calculations.
- Ensures consistent alignment with the navigation rail across all domain packages (Courses, Explore, etc.).
