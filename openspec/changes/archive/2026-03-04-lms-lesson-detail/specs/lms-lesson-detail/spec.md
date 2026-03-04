## ADDED Requirements

### Requirement: Rich Lesson Content Rendering
The system SHALL render lesson content items based on their type (heading, paragraph, image, list, callout).

#### Scenario: Rendering headings
- **WHEN** a lesson contains a heading type content item
- **THEN** it SHALL be displayed with appropriate font size and weight (H1: 22px Semibold, H2: 18px Semibold, H3: 16px Semibold)

#### Scenario: Rendering paragraphs
- **WHEN** a lesson contains a paragraph type content item
- **THEN** it SHALL be displayed with a line height of 1.7 for readability

#### Scenario: Rendering callouts
- **WHEN** a lesson contains a callout (note, tip, warning, or example)
- **THEN** it SHALL be displayed in a colored card (blue/emerald/amber/purple) with a specific icon (e.g., bulb for note, sparkles for tip)

#### Scenario: Rendering images
- **WHEN** a lesson contains an image type content item
- **THEN** it SHALL be displayed with rounded corners (e.g., 12px) and a subtle shadow

### Requirement: Reading Progress Tracking
The system SHALL track how far the user has read by monitoring their scroll position. This progress MUST be shown visually and used to determine when the lesson is finished.

#### Scenario: Visual progress bar updates
- **WHEN** the user scrolls through the lesson content
- **THEN** a progress bar at the top SHALL fill up to match the current scroll position

#### Scenario: Automatic completion
- **WHEN** the user scrolls to the very bottom of the lesson
- **THEN** the system SHALL mark this lesson as "Completed" in the user's study records

### Requirement: Lesson Meta Display
The system SHALL display the lesson title, subject badge, lesson count (index of total), and estimated reading duration.

#### Scenario: Metadata visibility
- **WHEN** the lesson detail screen is opened
- **THEN** the title SHALL be prominent (28px) and metadata details SHALL be clearly visible above the title

### Requirement: Sequential Lesson Navigation
The system SHALL provide "Previous" and "Next" buttons to navigate between lessons in the current chapter.

#### Scenario: Next lesson navigation
- **WHEN** the user taps the "Next Lesson" button
- **THEN** the system SHALL load the next lesson in the chapter sequence

### Requirement: Actionable Header
The system SHALL provide a back button and action buttons for bookmarking and downloading the lesson.

#### Scenario: Toggling bookmarks
- **WHEN** the user taps the bookmark icon
- **THEN** the icon SHALL reflect the bookmarked state (e.g., solid/filled)

### Requirement: Navigation Entry
The system SHALL navigate to the `LessonDetailScreen` when a text-based lesson is selected from the chapter detail view.

#### Scenario: User selects a lesson
- **WHEN** the user taps on a lesson item of type "lesson" in the chapter view
- **THEN** the system SHALL transition to the `LessonDetailScreen` for that lesson
