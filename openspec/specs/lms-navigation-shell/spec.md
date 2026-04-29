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
The system SHALL support views that occupy the entire screen, hiding the navigation shell (e.g., for immersive reading or video playback).

#### Scenario: Opening a lesson
- **WHEN** the user selects a lesson from the course list
- **THEN** the system navigates to a full-screen view where the navigation shell is no longer visible

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
Each primary tab SHALL support its own stack of push/pop navigation without affecting the other tabs.

#### Scenario: Navigating within Study tab
- **WHEN** the user clicks a course in the "Study" tab to see chapters
- **THEN** the chapter list is pushed onto the study tab's local stack, and the "Back" action returns them to the course list within that same tab

#### Scenario: Navigating to Curriculum with Course ID
- **WHEN** the user selects a course with ID "123"
- **THEN** the system SHALL navigate to the route `/study/course/123/chapters` within the Study tab
- **AND** the navigation shell MUST remain visible

#### Scenario: Navigating from Profile to Notifications
- **WHEN** the user selects "Notifications" from the Profile settings actions
- **THEN** the system SHALL navigate to the Notifications settings route from within the Profile tab flow
- **AND** the system MUST preserve the active shell/tab context while the Notifications screen is open

#### Scenario: Returning from Notifications to Profile
- **WHEN** the user triggers back navigation from the Notifications settings screen
- **THEN** the system SHALL return to the previous Profile screen state
- **AND** the system MUST NOT reset other tab navigation stacks


#### Scenario: Client-specific profile slot
- **WHEN** the client configuration does not enable the Info experience
- **THEN** the shell MUST keep the standard primary destinations: Home, Study, Explore, Profile
- **AND** the rest of the shell layout MUST remain unchanged

#### Scenario: Info-enabled client navigation
- **WHEN** the client configuration enables the Info experience
- **THEN** the shell MUST add the `Info` destination to the primary navigation flow
- **AND** the navigation shell MUST support 5 destinations: Home, Study, Explore, Info, Profile
- **AND** selecting the `Info` destination MUST navigate to the curated Info landing page

### Requirement: Auth-state-based router redirect
The router SHALL use auth provider state to decide redirects for auth routes and protected routes.

#### Scenario: Unauthenticated protected navigation
- **WHEN** user is unauthenticated and requests a protected route
- **THEN** router SHALL redirect to onboarding/login route

#### Scenario: Authenticated auth-route navigation
- **WHEN** user is authenticated and requests login/onboarding routes
- **THEN** router SHALL redirect to home route

#### Scenario: Loading-state redirect guard
- **WHEN** auth provider is in loading state during startup restoration
- **THEN** router SHALL avoid premature redirect loops until state resolves

