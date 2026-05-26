## ADDED Requirements

### Requirement: Home Screen Menu Drawer Trigger Visibility
The system SHALL only display the drawer menu / hamburger icon trigger inside the `InstituteBanner` (the top bar) on the home screen when the banner is present. When the banner is present, the duplicate drawer menu trigger next to the greeting section MUST be hidden.

#### Scenario: Home Screen with Institute Banner
- **GIVEN** the home screen has `isBannerPresent` set to true
- **THEN** the `InstituteBanner` at the top MUST display the hamburger menu drawer trigger
- **AND** the `DashboardHeader` greeting section MUST NOT display the duplicate hamburger menu trigger

#### Scenario: Home Screen without Institute Banner
- **GIVEN** the home screen has `isBannerPresent` set to false
- **THEN** the `DashboardHeader` greeting section MUST display the hamburger menu drawer trigger
