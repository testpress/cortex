# unified-lesson-shell Specification

## Purpose
TBD - created by archiving change integrate-lesson-detail-ui. Update Purpose after archive.
## Requirements
### Requirement: Cross-Package Decoupled Shell
The `LessonDetailShell` MUST provide a consistent UI container defined in `core` that can wrap any content from `courses` or `exams`.

#### Scenario: Rendering a Test Lesson
- **WHEN** A Test lesson ID is loaded in the orchestrator
- **THEN** The orchestrator wraps the `TestSummaryViewer` in the `LessonDetailShell`, maintaining visual consistency.

### Requirement: Sticky Navigation Navigation
The Navigation Footer MUST remain fixed at the bottom of the screen while the content area remains scrollable.

#### Scenario: Deep-linking to Lesson
- **WHEN** A user deep-links directly to a lesson
- **THEN** The Shell fetches the lesson context and shows the correct Next/Prev buttons immediately.

### Requirement: Dynamic Content Layouts
The `LessonDetailShell` SHALL support a stable live-stream presentation without rendering embedded chat content.

#### Scenario: Live stream shell presentation
- **WHEN** a live stream lesson is active
- **THEN** the shell SHALL keep the video area fixed at the top
- **AND** the content area below SHALL be rendered as a non-interactive filler region.

### Requirement: Bookmark Folder Sheet Trigger
Tapping the bookmark icon in the lesson details header SHALL display a playlist-style bookmark folders bottom sheet instead of performing a binary bookmark state toggle.

#### Scenario: User clicks bookmark button
- **WHEN** the user taps the bookmark icon in the lesson header
- **THEN** the system SHALL present the bookmark folders bottom sheet containing list of folders and "Uncategorized" option.

### Requirement: Bookmark State Visuals
The bookmark icon in the lesson details header SHALL render in an active (filled) state if the lesson is bookmarked (has a non-null `bookmarkId`), and in an inactive (outlined) state if the lesson is not bookmarked.

#### Scenario: Render bookmarked lesson
- **WHEN** a lesson detail is loaded with a non-null `bookmarkId`
- **THEN** the header bookmark icon SHALL be displayed as a filled icon.

