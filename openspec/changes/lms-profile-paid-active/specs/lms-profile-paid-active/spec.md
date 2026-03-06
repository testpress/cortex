# Screen: LMS Profile - Paid Active User

## ADDED Requirements

### Requirement: Centered Profile Header
The system SHALL display a centered profile header that provides a clear identity overview for the user.

#### Scenario: Displaying profile identity
- **WHEN** the `ProfilePage` is rendered
- **THEN** it MUST show a centered circular avatar (80×80)
- **AND** the user's name MUST be displayed in bold (20px semibold) below the avatar
- **AND** a membership subtext MUST be visible (e.g., "Learning with us since August 2025")
- **AND** a neutral edit affordance MUST appear in the top-right corner of the card, matching the Figma visual treatment for this screen

---

### Requirement: Learning Snapshot Card
The system SHALL provide a consolidated card summarising learning activities and performance insights.

#### Scenario: Displaying learning glance
- **WHEN** the `ProfilePage` is rendered
- **THEN** it MUST display a section title "Your learning at a glance"
- **AND** a card MUST show "Lessons finished", "Tests attempted", and "Assessments done" in a 3-column layout with vertical dividers and a bottom divider separating them from the insights
- **AND** it MUST include semantic sub-cards for "YOU'RE STRONGEST IN" (emerald tint) and "NEED FOCUS HERE" (amber tint)

---

### Requirement: Active Courses Carousel
The system SHALL display the user's active enrollments in a horizontal scrolling carousel.

#### Scenario: Navigating active courses
- **WHEN** the user has multiple enrollments
- **THEN** the system MUST display a section titled "Your active courses" with a "View All" link in the header
- **AND** cards MUST show a book icon, course name, chapter count, total duration, a progress bar, and completion percentage
- **AND** cards MUST be horizontally scrollable (1.15 cards peeking)

---

### Requirement: Recent Learning Activity
The system SHALL display the user's recent learning history in a horizontal scrolling card list.

#### Scenario: Displaying recent activity
- **WHEN** the user has recent activity
- **THEN** the system MUST display a section titled "Your recent learning"
- **AND** it MUST show activity cards scrollable horizontally, each showing: activity type icon, status pill (Completed / In progress), title, and context (score or progress % + time ago)
- **AND** activity types (video, test, lesson, assessment, notes) MUST each have a distinct tinted icon container

---

### Requirement: Account & Preferences Menu
The system SHALL provide quick access to account management actions.

#### Scenario: Navigating account settings
- **WHEN** the user views the profile page
- **THEN** the system MUST display a section titled "Account & preferences"
- **AND** it MUST show the following items in a card list: Edit Profile, Notifications, Your certificates, App Settings, Logout
- **AND** each item MUST have a tinted icon, label, and a chevron-right arrow
- **AND** Logout MUST have a red tint and label

---

### Requirement: Profile Navigation Entry Points
The system SHALL allow users to reach the paid active profile screen from all expected navigation entry points.

#### Scenario: Opening profile from app navigation
- **WHEN** the user selects the Profile bottom tab
- **THEN** the system MUST navigate to `ProfilePage`

#### Scenario: Opening profile from Home drawer
- **WHEN** the user is on Home and taps the "Profile" item in the hamburger drawer
- **THEN** the system MUST navigate to `ProfilePage`
