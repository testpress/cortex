## MODIFIED Requirements

### Requirement: Immersive Settings Drawer
The navigation shell SHALL provide an immersive settings/menu interaction from the `DashboardDrawer` in `packages/courses`.

#### Scenario: Directional Animation
- **WHEN** the menu depends on `courses`
- **THEN** it MUST continue to slide correctly based on viewport orientation (LEFT for Portrait, RIGHT for Landscape).
- **AND** it SHALL support "Blind Navigation" to the `ProfilePage` via URI string.

#### Scenario: Navigating from Drawer to Profile
- **WHEN** the user selects the "Profile" item in the drawer
- **THEN** the shell SHALL navigate to the route `/profile`.
- **AND** the shell MUST NOT have a direct dependency on the `ProfilePage` widget class.

### Requirement: Sub-routing within Tabs
The shell SHALL support consistent sub-routing within the standalone `profile` tab.

#### Scenario: Navigating from Profile to Notifications
- **WHEN** the user selects "Notifications" from the Profile settings actions
- **THEN** the system SHALL navigate to the route `notifications` relative to `/profile`.
- **AND** the shell MUST preserve the active Profile tab context.

#### Scenario: Returning from Notifications to Profile
- **WHEN** the user triggers back navigation from the Notifications screen
- **THEN** the system SHALL return to the root Profile state at `/profile`.
- **AND** the shell state MUST NOT be lost during this transition.
