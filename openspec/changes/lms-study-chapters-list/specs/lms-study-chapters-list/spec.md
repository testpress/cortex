## ADDED Requirements

### Requirement: Course Curriculum Hierarchy
The `ChaptersListPage` SHALL display the full list of chapters for a selected course, ordered as per the curriculum.

#### Scenario: Viewing Chapter List
- **WHEN** a user selects a course from the Study screen
- **THEN** the system SHALL navigate to the `ChaptersListPage` for that course
- **AND** the system SHALL display each chapter with its title and subtitle (lesson/assessment counts)

### Requirement: Content Type Tabs
The system SHALL provide a horizontal scrollable tab bar to filter the curriculum content by type.

#### Scenario: Switching to Videos Tab
- **WHEN** the user is on the "All" tab and taps the "Videos" tab
- **THEN** the system SHALL hide the chapter list
- **AND** the system SHALL display a flat list of all video lessons across all chapters in that course

### Requirement: Lesson Status Indicators
Each lesson or content item SHALL display a status badge indicating whether it is Completed, In Progress, or Locked.

#### Scenario: Identifying Locked Content
- **WHEN** a user views a lesson that is not yet available/unlocked
- **THEN** the system SHALL display a "Locked" status badge
- **AND** the item SHALL be visually distinct (e.g., muted colors)

### Requirement: Back Navigation to Course List
The system SHALL provide a "Back" button in the sticky header to return to the course list.

#### Scenario: Returning to Course List
- **WHEN** the user taps the "Back" button on the `ChaptersListPage`
- **THEN** the system SHALL pop the current view and return to the `StudyScreen`

### Requirement: Sticky Header with Progress
The `ChaptersListPage` header SHALL be sticky and display the course title and the total number of chapters.

#### Scenario: Scrolling Curriculum
- **WHEN** the user scrolls down the list of chapters
- **THEN** the header containing the back button and course title MUST remain fixed at the top
