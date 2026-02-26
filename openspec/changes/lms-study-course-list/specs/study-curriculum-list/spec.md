## ADDED Requirements

### Requirement: Searchable Curriculum
The system SHALL provide a search field in the Study tab that filters the displayed list of courses and chapters based on title matches.

#### Scenario: Search filters courses
- **WHEN** the user types "Physics" in the search bar
- **THEN** only courses containing the word "Physics" in their title remain visible

### Requirement: Course Progress Visibility
The system SHALL display a progress indicator for each course showing the percentage completed and the ratio of completed lessons to total lessons.

#### Scenario: Progress bar reflects data
- **WHEN** a course has 5/10 lessons completed
- **THEN** the progress bar displays 50% width and the text shows "5/10 lessons"

### Requirement: Content Type Filtering
The system SHALL allow users to toggle filters for "Video", "Lesson", "Assessment", and "Test" content.

#### Scenario: Selecting a filter changes view
- **WHEN** the "Video" content type filter is active
- **THEN** the UI switches from a course list to a flat list of all video lessons across all enrolled courses

### Requirement: Sticky Mini-Player
The system SHALL display a floating resume card at the bottom of the Study page if the user has an incomplete lesson.

#### Scenario: Resume card is visible
- **WHEN** the user opens the Study page and has a "Video" lesson at 40% progress
- **THEN** a card appears above the navigation bar showing the lesson title and a "Resume" button
