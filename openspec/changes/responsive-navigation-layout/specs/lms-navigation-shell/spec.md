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

## ADDED Requirements

### Requirement: Layout Spacing Robustness
The navigation shell SHALL ensure that content remains accessible and "uncongested" across varying screen sizes and orientations.

#### Scenario: Large Tablet Portrait
- **GIVEN** a large tablet (e.g., iPad Pro) in portrait mode
- **THEN** the bottom navigation bar MUST be centered or appropriately padded to avoid excessive stretching.

#### Scenario: Small Mobile Landscape
- **GIVEN** a compact mobile device in landscape mode
- **THEN** the navigation rail MUST NOT overlap with critical UI elements or cause horizontal layout breakage.
