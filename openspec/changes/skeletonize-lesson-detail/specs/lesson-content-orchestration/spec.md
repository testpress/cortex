## MODIFIED Requirements

### Requirement: Decoupled Data Loading
The system SHALL handle the fetching of lesson domain models via `lessonDetailProvider` at the route builder level, ensuring specialized screens only receive the finished `Lesson` object.

#### Scenario: Unified loading indicator across types
- **WHEN** a lesson payload is being fetched for any screen
- **THEN** the router SHALL display a structured skeleton loader via `LessonDetailSkeleton` instead of a simple circular indicator.
