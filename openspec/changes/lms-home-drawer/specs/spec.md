# Specs: Home Screen Sidebar Menu (`lms-home-drawer`)

## Requirements

### Requirement: Custom Drawer Shell
The system SHALL provide a custom-built navigation drawer that avoids default platform-specific (Material/Cupertino) UI behaviors.

#### Scenario: Visual Parity
- **WHEN** the drawer is opened
- **THEN** it MUST use `design.layout.drawerWidth` for its width
- **AND** it MUST use `design.colors.card` for its background and `design.colors.border` for section separators.

---

### Requirement: Functional Sectioning
The drawer MUST be organized into three logical sections with specific items as defined in the design reference.

#### Scenario: Learning Tools Section
- **WHEN** the first section is rendered
- **THEN** it MUST contain: Bookmark, Posts, Analytics, Forum, Doubts, Custom Exam, and Your Report.
- **AND** each item MUST display its corresponding `LucideIcon`.

#### Scenario: Account Management Section
- **WHEN** the second section is rendered
- **THEN** it MUST contain: Profile, App Settings, Login Activity, and Logout.
- **AND** the "Logout" item MUST use `design.colors.error` for its text and icon.

#### Scenario: Theme Information Section
- **WHEN** the third section is rendered
- **THEN** it MUST contain a Theme Toggle (Light/Dark Mode) and Version Information.

---

### Requirement: Dynamic Theme Switching
The drawer MUST allow the user to toggle between Light and Dark modes without closing the drawer immediately.

#### Scenario: Theme Toggle Interaction
- **WHEN** the user taps the Theme Toggle item
- **THEN** the application theme MUST switch immediately
- **AND** the drawer MUST remain open to allow the user to see the transition.

---

### Requirement: Integration with DashboardHeader
The existing `DashboardHeader` MUST be the designated trigger for opening the drawer.

#### Scenario: Hamburger Trigger
- **WHEN** the hamburger menu icon in `DashboardHeader` is tapped
- **THEN** it MUST trigger the opening of the `AppDrawer`.
