# Capability: LMS Profile

## Purpose
The LMS Profile capability defines the user's personal learning hub, providing identity management, performance tracking, enrollment overviews, and application preferences.

## Requirements

### Requirement: Centered Profile Header
The system SHALL display a centered profile header providing a clear identity overview.

#### Scenario: Displaying profile identity
- **WHEN** the `ProfilePage` is rendered
- **THEN** it MUST show a centered circular avatar (80×80)
- **AND** the user's name MUST be displayed in bold (20px semibold) below the avatar
- **AND** a membership subtext SHALL be visible.
- **AND** a neutral edit affordance SHALL appear in the top-right corner of the identity card.

### Requirement: Learning Snapshot Card
The system SHALL provide a consolidated card summarising key performance metrics across different content types.

#### Scenario: Displaying learning glance
- **WHEN** the `ProfilePage` is rendered
- **THEN** it SHALL display a section title "Your learning at a glance"
- **AND** a card MUST show "Lessons finished", "Tests attempted", and "Assessments done" in a 3-column layout.
- **AND** it SHALL include semantic sub-cards for "YOU'RE STRONGEST IN" (emerald tint) and "NEED FOCUS HERE" (amber tint).

### Requirement: Active Courses Carousel
The user's active enrollments SHALL be presented in a horizontal scrolling gallery.

#### Scenario: Scrolling active courses
- **WHEN** the user has active enrollments
- **THEN** the system MUST display a section titled "Your active courses" with a "View All" link.
- **AND** cards MUST show course icon, name, stats, and a progress bar.

### Requirement: Recent Learning Activity
The system SHALL display a chronological history of a user's latest learning interactions.

#### Scenario: Displaying recent activity
- **WHEN** the user has recent activity
- **THEN** the system MUST display cards with activity type icon, status pill, title, and context (score/progress + time ago).
- **AND** activity types (video, test, lesson, assessment) MUST have distinct themed icons.

### Requirement: Account & Preferences Menu
The system SHALL provide access to account settings and application preferences as a list of actions.

#### Scenario: Navigating account settings
- **WHEN** viewing the profile page
- **THEN** the system MUST display a list card containing: Edit Profile, Notifications, Certificates, App Settings, and Logout.
- **AND** each item MUST have its specific icon, label, and a chevron-right transition indicator.

### Requirement: Profile Navigation Entry Points
The system SHALL expose the profile from the primary navigation shell.

#### Scenario: Tab and Hamburger entry
- **WHEN** the user selects the Profile bottom tab OR the Profile drawer item
- **THEN** the system MUST navigate to the `ProfilePage`.
