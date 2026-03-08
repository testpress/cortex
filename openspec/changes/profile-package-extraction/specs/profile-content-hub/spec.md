## ADDED Requirements

### Requirement: Self-Contained Course Progress Section
The `profile` package SHALL implement its own version of the `EnrolledCoursesSection` to avoid a dependency on the `courses` package.

#### Scenario: Displaying courses in profile
- **WHEN** the user has enrolled courses in the `data` package
- **THEN** the `profile` package MUST render a horizontal scrolling list of course cards using its internal widget implementation.
- **AND** the cards MUST display a course icon, title, chapter count, duration, and progress bar using only `CourseDto` data.

### Requirement: Self-Contained Recent Activity Section
The `profile` package SHALL implement its own version of the `RecentActivitySection` using models provided by the `data` package.

#### Scenario: Displaying recent learning in profile
- **WHEN** the user has learning activity in the `data` package
- **THEN** the `profile` package MUST render a horizontal scrolling list of activity cards using its internal widget implementation.
- **AND** the cards MUST track performance using `RecentActivityDto` models relocated to the `data` package.
