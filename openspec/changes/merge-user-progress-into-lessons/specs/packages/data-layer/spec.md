## ADDED Requirements

### Requirement: Unified Lesson Progress State
The `LessonsTable` and `LessonDto` SHALL serve as the single source of truth for all user progress related to a specific lesson, including granular completion percentage and last access timestamp.

#### Scenario: App persists progress to Lesson row
- **WHEN** a user interacts with a lesson
- **THEN** the system SHALL update the `progressStatus`, `percentComplete`, and `lastAccessedAt` fields directly within the `LessonsTable` row for that lesson.
- **AND** the system SHALL NOT maintain a separate `UserProgressTable`.

#### Scenario: Dashboard calculates recent activity from Lessons
- **WHEN** the dashboard requires a list of recently viewed lessons
- **THEN** it SHALL query the `LessonsTable` directly, sorted by `lastAccessedAt` in descending order.
