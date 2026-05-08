## MODIFIED Requirements

### Requirement: Content Type Tabs
The system SHALL provide a horizontal scrollable tab bar to filter the curriculum content by type. The system MUST allow for tab-aware visibility of these filters and handle background synchronization states gracefully.

#### Scenario: Switching to Videos Tab
- **WHEN** the user is on the "All" tab and taps the "Videos" tab
- **THEN** the system SHALL hide the chapter list
- **AND** the system SHALL display a flat list of all video lessons across all chapters in that course
- **AND** the system SHALL trigger a background Master Sync if one is not already in progress

#### Scenario: Tab-aware filter visibility
- **WHEN** the `ChaptersListPage` is opened with `showFilters` set to `false` (e.g., from the Exams tab)
- **THEN** the horizontal filter tab bar SHALL NOT be rendered

#### Scenario: Sync feedback during filtering
- **WHEN** a filter is active and the underlying data is empty while a sync is in progress
- **THEN** the system SHALL display an `AppLoadingIndicator` instead of an empty state message

### Requirement: Course Curriculum Hierarchy
The `ChaptersListPage` SHALL display the full list of chapters for a selected course, ordered as per the backend's native ordering.

#### Scenario: Viewing Chapter List
- **WHEN** a user selects a course
- **THEN** the system SHALL navigate to the `ChaptersListPage` for that course
- **AND** the list SHALL be sorted by the backend's `order` field
- **AND** the system SHALL trigger a recursive sync for the current chapter level to ensure immediate content visibility
