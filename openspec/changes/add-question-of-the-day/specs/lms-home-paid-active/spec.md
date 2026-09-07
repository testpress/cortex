## MODIFIED Requirements

### Requirement: Top App Bar & Navigation Access
The system SHALL provide a persistent top app bar (DashboardHeader) with access to global navigation options, including the navigation drawer.

#### Scenario: Hamburger Menu Placeholder
- **WHEN** the `DashboardHeader` is rendered
- **THEN** it MUST include a hamburger menu icon (`Icons.menu_rounded`)
- **AND** the actual menu sidebar functionality is deferred to a separate/future spec change.

#### Scenario: Daily Questions Drawer Item
- **GIVEN** `instituteSettings.qotdEnabled` is `true`
- **WHEN** the `DashboardDrawer` is rendered
- **THEN** it MUST include a "Daily Questions" item with a calendar icon
- **AND** tapping it MUST route the user to the `/qotd` screen.
