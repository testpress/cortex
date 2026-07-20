## MODIFIED Requirements

### Requirement: Persistent Navigation Shell
The system SHALL provide a persistent application shell that adapts its navigation interface based on device orientation rather than fixed width breakpoints for handheld devices.

#### Scenario: Vertical Mode (Portrait)
- **GIVEN** the device is in portrait orientation (height > width)
- **THEN** the shell MUST display the `AppTabBar` at the bottom, regardless of screen size (mobile or tablet).
- **AND** the `AppTabBar` MUST float above the main content rather than occupying dedicated vertical space.

#### Scenario: Horizontal Mode (Landscape)
- **GIVEN** the device is in landscape orientation (width > height)
- **THEN** the shell MUST display the `AppNavigationRail` on the left.
- **AND** the rail MUST support vertical scrolling for content overflow.

#### Scenario: Switching between tabs
- **WHEN** the user is on the "Home" tab and clicks the "Study" icon in the tab bar
- **THEN** the system navigates to the Study screen while maintaining the shell visibility
