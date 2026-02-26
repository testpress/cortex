# Spec: Adaptive Navigation Layout

## Requirement: Breakpoint-Driven Layout Switching
The application must dynamically switch between mobile and tablet navigation based on the horizontal window size.

### Scenario: Compact Mode (Mobile)
- **GIVEN** a viewport width less than **600.0**
- **THEN** the `AppShell` MUST display the `AppTabBar` at the bottom.
- **AND** it MUST NOT display the `AppNavigationRail`.

### Scenario: Medium/Expanded Mode (Tablet)
- **GIVEN** a viewport width greater than or equal to **600.0**
- **THEN** the `AppShell` MUST display the `AppNavigationRail` on the left.
- **AND** the rail MUST support vertical scrolling to prevent content overflow in landscape mode.
- **AND** the main child content MUST be horizontally offset by the rail's width (80.0).

---

## Requirement: Full-Page Settings Slider
The settings/menu interaction must be immersive and cover the entire viewport.

### Scenario: Opening Menu
- **WHEN** the user triggers the menu (e.g., via `DashboardHeader`)
- **THEN** the `AppDrawer` MUST cover 100% of the viewport width.
- **AND** it MUST overlay both the main content and the navigation elements (TabBar or Rail).

### Scenario: Directional Animation
- **WHEN** the "Hamburger" icon is on the left (Portrait)
- **THEN** the `AppDrawer` MUST slide from the LEFT.
- **WHEN** the "Hamburger" icon is on the right (Landscape/Tablet)
- **THEN** the `AppDrawer` MUST slide from the RIGHT.

### Scenario: Closing Menu (System Navigation)
- **WHEN** the user performs a system back gesture or presses the hardware back button while the drawer is open
- **THEN** the `AppDrawer` MUST close instead of the application exiting.
- **AND** the previous application state MUST be restored.
