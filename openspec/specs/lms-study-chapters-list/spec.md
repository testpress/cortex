# lms-study-chapters-list Specification

## Purpose
TBD - created by archiving change lms-study-chapters-list. Update Purpose after archive.
## Requirements
### Requirement: Course Curriculum Hierarchy
The `ChaptersListPage` SHALL display the full list of chapters for a selected course, ordered as per the curriculum. The screen SHALL support pull-to-refresh, allowing users to reload the chapter list from the server at any time while on the screen.

#### Scenario: Viewing Chapter List
- **WHEN** a user selects a course from the Study screen
- **THEN** the system SHALL navigate to the `ChaptersListPage` for that course
- **AND** the system SHALL display each chapter with its title and subtitle (lesson/assessment counts)

#### Scenario: Pulling to refresh chapter list
- **WHEN** the user pulls down from the top of the chapter list
- **THEN** the system SHALL show the standard refresh indicator
- **AND** the system SHALL re-fetch the chapter list from the server while keeping existing content visible
- **AND** the updated list SHALL be displayed once the fetch completes

#### Scenario: Pulling to refresh filtered lessons list
- **WHEN** the user has a content filter tab active (e.g., Videos) and pulls down from the top of the lesson list
- **THEN** the system SHALL re-fetch the first page of the filtered lesson list while keeping existing content visible
- **AND** the updated list SHALL be displayed once the fetch completes

#### Scenario: Pulling to refresh on an empty list
- **WHEN** the filtered lesson list is empty and the user pulls down
- **THEN** the pull-to-refresh gesture SHALL be recognized and the refresh indicator SHALL appear
- **AND** the system SHALL attempt to re-fetch content

### Requirement: Content Type Tabs
The system SHALL provide a horizontal scrollable tab bar to filter the curriculum content by type. The visibility of specific content filter tabs (specifically Assessments and Tests) SHALL be controlled dynamically based on client configurations. If the \"Exam\" tab is enabled in the client configuration, the Assessments and Tests tabs SHALL be hidden from the tab bar.

#### Scenario: Switching to Videos Tab
- **WHEN** the user is on the \"All\" tab and taps the \"Videos\" tab
- **THEN** the system SHALL hide the chapter list
- **AND** the system SHALL display a flat list of all video lessons across all chapters in that course

#### Scenario: Exam Tab Enabled Hides Assessment and Test Chips
- **WHEN** the ChaptersListPage is loaded with client configuration having showExamTab set to true
- **THEN** the ChaptersFilterTabBar SHALL NOT display the Assessments or Tests filter tabs
- **AND** only the All, Lessons, and Videos tabs SHALL be visible

### Requirement: Lesson Status Indicators
Each lesson or content item SHALL display a status badge indicating whether it is Completed, In Progress, or Locked.

#### Scenario: Identifying Locked Content
- **WHEN** a user views a lesson that is not yet available/unlocked
- **THEN** the system SHALL display a \"Locked\" status badge
- **AND** the item SHALL be visually distinct (e.g., muted colors)

### Requirement: Back Navigation to Course List
The system SHALL provide a \"Back\" button in the sticky header to return to the course list.

#### Scenario: Returning to Course List
- **WHEN** the user taps the \"Back\" button on the `ChaptersListPage`
- **THEN** the system SHALL pop the current view and return to the `StudyScreen`

### Requirement: Sticky Header with Progress
The `ChaptersListPage` header SHALL be sticky and display the course title and the total number of chapters.

#### Scenario: Scrolling Curriculum
- **WHEN** the user scrolls down the list of chapters
- **THEN** the header containing the back button and course title MUST remain fixed at the top

