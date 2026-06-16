## ADDED Requirements

### Requirement: Seamless Status Bar Merging
Any main tab header (such as `DashboardHeader` or inline equivalents in main tab screens) SHALL explicitly extend its background color to the top edge of the device screen, ensuring a seamless visual merge with the transparent status bar.

#### Scenario: Rendering the header at the top of a screen
- **WHEN** the header is rendered at the top of a screen with a transparent status bar
- **THEN** its background color MUST cover the status bar area entirely
- **AND** its content MUST be padded by the system safe area to remain safely below the status bar
