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
The system SHALL navigate to the appropriate full-screen viewer or reader when a content item is tapped. For PDF lessons, the system SHALL navigate to a dedicated PDF viewer that renders the file from a remote URL.

#### Scenario: Tapping a video lesson
- **WHEN** the user taps a "Video" lesson item
- **THEN** the system pushes the Video Lesson Detail screen onto the navigation stack

#### Scenario: Tapping a PDF lesson
- **WHEN** the user taps a "PDF" lesson item
- **THEN** the system pushes the PDF Lesson Detail screen (PDF Viewer) with the provided `contentUrl`

### Requirement: Lesson Navigation Footer
The system SHALL provide a navigation footer in the lesson detail view to allow users to move between sequential lessons.

#### Scenario: Full-width button alignment in navigation footer
- **WHEN** the lesson navigation footer is rendered
- **THEN** the "Previous" and "Next" action buttons MUST occupy the full available width of their respective containers to ensure proper edge-to-edge alignment.

### Requirement: Course Content Synchronization (Merging Logic)
The system SHALL synchronize curriculum contents (lessons, assessments) and status-specific lists (Running, Upcoming, History) for a course from multiple remote API endpoints.
- The system MUST **merge** fragmented metadata (such as `chapterId`) together by comparing local cache, master curriculum, and status lists to create a single authoritative record.
- The system MUST use a deduplication strategy to ensure each lesson is unique while retaining enriched metadata from the most complete source.

#### Scenario: Syncing curriculum contents
- **WHEN** the user opens the course curriculum list
- **THEN** the system triggers a background sync with the `/contents/`, `/running_contents/`, `/upcoming_contents/`, and `/content_attempts/` APIs and updates the local database using the unified `_mergeLocalAndRemoteLessons` logic.

### Requirement: Leaf Chapter Content Status Filtering
The system SHALL filter the contents of a leaf chapter based on the selected status ("Running", "Upcoming", or "History").
- Navigating to a leaf chapter MUST trigger a targeted `refreshLessons(chapterId)` which clears old records for that chapter and replaces them with the latest authoritative list to prevent data corruption.

#### Scenario: Navigating to leaf chapter refreshes content
- **WHEN** the user navigates to a leaf chapter
- **THEN** the system calls `refreshLessons(chapterId)` to sync and update the content list for that chapter.

### Requirement: Recursive Content Scoping
The system SHALL ensure that curriculum filters (Videos, Lessons, etc.) in the hierarchical view are strictly scoped to the current chapter context.

#### Scenario: Applying curriculum filters in hierarchical view
- **WHEN** the user applies a curriculum filter (e.g., "Videos") in a chapter's content list
- **THEN** the system displays only the lessons of that type belonging to the current chapter or its recursive sub-chapters.

