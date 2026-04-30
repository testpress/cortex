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

