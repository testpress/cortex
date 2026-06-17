## MODIFIED Requirements

### Requirement: Learning Snapshot Card
The system SHALL provide a consolidated card summarising key performance metrics across different content types.

#### Scenario: Displaying learning glance
- **WHEN** the `ProfilePage` is rendered in the `profile` package
- **AND** the active tenant is NOT Brilliant Pala (identified by `AppConfig.apiBaseUrl` not containing `brilliant`)
- **THEN** it SHALL display a section title "Your learning at a glance"
- **AND** a card MUST show "Lessons finished", "Tests attempted", and "Assessments done" in a 3-column layout.
- **AND** it SHALL include semantic sub-cards for "YOU'RE STRONGEST IN" (emerald tint) and "NEED FOCUS HERE" (amber tint).

#### Scenario: Learning snapshot card for Brilliant Pala
- **WHEN** the `ProfilePage` is rendered in the `profile` package
- **AND** the active tenant is Brilliant Pala (identified by `AppConfig.apiBaseUrl` containing `brilliant`)
- **THEN** the learning snapshot card section MUST NOT be rendered.

### Requirement: Active Courses Carousel
The user's active enrollments SHALL be presented in a horizontal scrolling gallery.

#### Scenario: Scrolling active courses
- **WHEN** the user has active enrollments and views the `ProfilePage` in the `profile` package
- **AND** the active tenant is NOT Brilliant Pala (identified by `AppConfig.apiBaseUrl` not containing `brilliant`)
- **THEN** the system MUST display a section titled "Your active courses" with a "View All" link.
- **AND** the `profile` package MUST render its own internal version of the cards showing course icon, name, stats, and a progress bar.

#### Scenario: Active courses for Brilliant Pala
- **WHEN** the user views the `ProfilePage` in the `profile` package
- **AND** the active tenant is Brilliant Pala (identified by `AppConfig.apiBaseUrl` containing `brilliant`)
- **THEN** the active courses carousel MUST NOT be rendered.

### Requirement: Recent Learning Activity
The system SHALL display a chronological history of a user's latest learning interactions.

#### Scenario: Displaying recent activity
- **WHEN** the user has recent activity and views the `ProfilePage` in the `profile` package
- **AND** the active tenant is NOT Brilliant Pala (identified by `AppConfig.apiBaseUrl` not containing `brilliant`)
- **THEN** the system MUST display cards with activity type icon, status pill, title, and context (score/progress + time ago) from the package's internal implementation.
- **AND** activity types (video, test, lesson, assessment) MUST have distinct themed icons.

#### Scenario: Recent learning activity for Brilliant Pala
- **WHEN** the user views the `ProfilePage` in the `profile` package
- **AND** the active tenant is Brilliant Pala (identified by `AppConfig.apiBaseUrl` containing `brilliant`)
- **THEN** the recent learning activity section MUST NOT be rendered.
