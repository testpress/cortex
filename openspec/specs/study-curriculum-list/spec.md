# Capability: Searchable Study Curriculum

## Purpose
The Searchable Study Curriculum capability allows users to navigate large course catalogs through efficient search, filtering by content type, and persistent progress tracking. It is a core pillar of the LMS experience, prioritizing performance and vertical design rhythm.

## Requirements

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

### Requirement: Performance & Scalability
The system SHALL use virtualized lists (e.g., `ListView.builder`) for curriculum rendering to ensure smooth scrolling (60fps) even with hundreds of courses or lessons.

### Requirement: Theme Governance
The system SHALL centralize all study-specific colors (e.g., content type accent colors) into a `DesignStudyTheme` extension to ensure consistent branding and seamless dark mode transitions.

### Requirement: Data Identity & Lifecycle
The system SHALL use a centralized identity source (`authProvider`) to determine the current user session. This ensures that data providers (Curriculum, Progress) are reactive to user switches and free of session-related hardcoding.

### Requirement: Side-Effect-Free Data Seeding
The system SHALL move all data synchronization and seeding logic (refreshing courses/progress) into a dedicated application-launch routine. Data providers SHALL remain side-effect-free, acting only as reactive streams of the underlying database state.

### Requirement: O(N) Curriculum Search
The system SHALL pre-flatten the nested course/chapter hierarchy into a single synchronous provider (`allLessonsProvider`). This ensures that search and content-type filtering operations execute in O(N) time without nested iterations, preventing UI jank during rapid typing or filter toggling.

### Requirement: Full-Cell Interactive Targets
The system SHALL ensure that interactive elements like filter chips utilize the full width of their grid containers as tap targets (`AppFocusable`). Text and icons within these chips SHALL be left-aligned with consistent gutter padding to prioritize readability and tap accuracy.

### Requirement: Consistent Content Context
The system SHALL maintain the main section header as "Your Courses" even when a search or content filter is active. This ensures the user maintains a stable sense of place within the Study tab while the underlying list content dynamically updates.
