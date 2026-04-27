## MODIFIED Requirements

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

#### Scenario: Client-specific profile slot
- **WHEN** the client configuration does not enable the Info experience
- **THEN** the shell MUST keep the fifth primary destination labeled `Profile` with the standard profile icon and route
- **AND** the rest of the shell layout MUST remain unchanged

#### Scenario: Info-enabled client profile slot
- **WHEN** the client configuration enables the Info experience
- **THEN** the shell MUST replace the fifth primary destination label with `Info`
- **AND** the shell MUST use the client-approved Info icon for that destination
- **AND** selecting the destination MUST navigate to the client-specific Info page instead of the default profile route
