# chapter-detail Specification

## Purpose
The Chapter Detail capability provides a focused view of a single chapter's content, allowing users to browse lessons, filter by progress status, and navigate to specific learning activities.

## Requirements

### Requirement: Navigation to Chapter Detail
The system SHALL allow users to navigate from the course or chapter list to a full-screen detailed view of a chapter.

#### Scenario: Tapping a chapter in the list
- **WHEN** the user taps a chapter item in the Study curriculum list
- **THEN** the system navigates to the Chapter Detail Page for that chapter

### Requirement: Chapter Content List
The system SHALL display a vertical list of all learning items (lessons, assessments, tests) belonging to a specific chapter.

#### Scenario: Chapter detail displays items
- **WHEN** the user opens the chapter detail page
- **THEN** the system displays a list of lesson titles, their types, and secondary information (e.g., duration)

### Requirement: Status Selection
The system SHALL provide status filter options for "Running", "Upcoming", and "History" to categorize chapter content.

#### Scenario: Status filters are selectable
- **WHEN** the user taps on a status filter pill (e.g., "Running")
- **THEN** that filter is highlighted as active, and the list content updates to reflect the selected status

### Requirement: Content Type Icons
The system SHALL display specific icons for each content type: PlayCircle for Video, FileText for PDF/Lesson, ClipboardCheck for Assessment, and ShieldCheck for Test.

#### Scenario: Icon matches content type
- **WHEN** a "Video" lesson is displayed in the list
- **THEN** it shows the `PlayCircle` icon in the designated subject/type color

### Requirement: Navigation To Content
The system SHALL navigate to the appropriate full-screen viewer or reader when a content item is tapped.

#### Scenario: Tapping a video lesson
- **WHEN** the user taps a "Video" lesson item
- **THEN** the system pushes the Video Lesson Detail screen onto the navigation stack

