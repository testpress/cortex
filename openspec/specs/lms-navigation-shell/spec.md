# Capability: LMS Navigation Shell

## Purpose
The LMS Navigation Shell provides a consistent and adaptive application framework that manages top-level navigation, tab state persistence, and immersive full-screen transitions. It ensures a seamless experience across mobile and tablet viewports while protecting the user's progress within individual tabs.
## Requirements
### Requirement: Persistent Navigation Shell
The system SHALL provide a persistent application shell that adapts its navigation interface based on device orientation rather than fixed width breakpoints for handheld devices.

#### Scenario: Vertical Mode (Portrait)
- **GIVEN** the device is in portrait orientation (height > width)
- **THEN** the shell MUST display the `AppTabBar` at the bottom, regardless of screen size (mobile or tablet).

#### Scenario: Horizontal Mode (Landscape)
- **GIVEN** the device is in landscape orientation (width > height)
- **THEN** the shell MUST display the `AppNavigationRail` on the left.
- **AND** the rail MUST support vertical scrolling for content overflow.

#### Scenario: Switching between tabs
- **WHEN** the user is on the "Home" tab and clicks the "Study" icon in the tab bar
- **THEN** the system navigates to the Study screen while maintaining the shell visibility

### Requirement: Layout Spacing Robustness
The navigation shell SHALL ensure that content remains accessible and "uncongested" across varying screen sizes and orientations.

#### Scenario: Large Tablet Portrait
- **GIVEN** a large tablet (e.g., iPad Pro) in portrait mode
- **THEN** the bottom navigation bar MUST be centered or appropriately padded to avoid excessive stretching.

#### Scenario: Small Mobile Landscape
- **GIVEN** a compact mobile device in landscape mode
- **THEN** the navigation rail MUST NOT overlap with critical UI elements or cause horizontal layout breakage.

### Requirement: Stateful Tab Preservation
The system MUST preserve the state of each tab independently to avoid re-initializing screens upon switching back.

#### Scenario: Returning to a previous tab
- **WHEN** the user scrolls down on the "Study" tab, switches to "Profile", and then switches back to "Study"
- **THEN** the "Study" tab remains at the same scroll position as when it was left

### Requirement: Exclusive Full-screen Views
The system SHALL mandate that all focused learning, community activities, and secondary utilities (lessons, tests, assessments, chapters, forums, doubts, profile settings, and downloads) occupy the entire screen, hiding the navigation shell to ensure immersive focus and proper native resource disposal.

#### Scenario: Opening a lesson
- **WHEN** the user selects a lesson, test, or assessment
- **THEN** the system navigates to a full-screen view via the root navigator where the navigation shell is no longer visible

#### Scenario: Opening a forum or doubt detail
- **WHEN** the user navigates to a forum thread or a doubt detail page
- **THEN** the system navigates to a full-screen view via the root navigator

### Requirement: Immersive Settings Drawer
The settings/menu interaction MUST be immersive and cover the entire viewport.

#### Scenario: Directional Animation
- **WHEN** the menu is triggered from the left (Portrait)
- **THEN** the `AppDrawer` MUST slide from the LEFT.
- **WHEN** the menu is triggered from the right (Landscape/Tablet)
- **THEN** the `AppDrawer` MUST slide from the RIGHT.

#### Scenario: Closing Menu (System Navigation)
- **WHEN** the user performs a system back gesture or presses the hardware back button while the drawer is open
- **THEN** the `AppDrawer` MUST close instead of the application exiting.

### Requirement: Sub-routing within Tabs
Each primary tab SHALL support its own stack of push/pop navigation without affecting the other tabs, EXCEPT for deep-dive immersive content which is pushed to the root navigator.

#### Scenario: Navigating within Study tab
- **WHEN** the user clicks a course in the "Study" tab to see chapters
- **THEN** the chapter list is pushed to the root navigator, creating an immersive full-screen view
- **AND** the "Back" action returns them to the course list tab

#### Scenario: Navigating to Curriculum with Course ID
- **WHEN** the user selects a course with ID "123"
- **THEN** the system SHALL navigate to the route `/study/course/123/chapters` using the root navigator
- **AND** the navigation shell MUST NOT be visible

#### Scenario: Navigating from Profile to Notifications
- **WHEN** the user selects "Notifications" from the Profile settings actions
- **THEN** the system SHALL navigate to the Notifications settings route via the root navigator
- **AND** the navigation shell MUST NOT be visible during the interaction

#### Scenario: Returning from Notifications to Profile
- **WHEN** the user triggers back navigation from the Notifications settings screen
- **THEN** the system SHALL return to the previous Profile dashboard state
- **AND** the navigation shell MUST become visible again

### Requirement: Auth-state-based router redirect
The router SHALL use auth provider state to decide redirects for auth routes and protected routes. This logic SHALL be encapsulated within the `AuthRoutes` module for modularity.

#### Scenario: Unauthenticated protected navigation
- **WHEN** user is unauthenticated and requests a protected route
- **THEN** router SHALL redirect to onboarding/login route

#### Scenario: Authenticated auth-route navigation
- **WHEN** user is authenticated and requests login/onboarding routes
- **THEN** router SHALL redirect to home route

#### Scenario: Loading-state redirect guard
- **WHEN** auth provider is in loading state during startup restoration
- **THEN** router SHALL avoid premature redirect loops until state resolves

