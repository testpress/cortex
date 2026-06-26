## ADDED Requirements

### Requirement: Content-Driven Exam Metadata Retrieval
The system SHALL retrieve exam metadata exclusively from the embedded `exam` property within the `LessonDto`, eliminating reliance on the standalone exam slug API.

#### Scenario: Launching the exam prescreen
- **WHEN** the user navigates to the Exam Prescreen from a course syllabus
- **THEN** the screen extracts the exam duration, marks, and section data directly from `lesson.exam`
- **THEN** no network request is dispatched to `/api/v2.4/exams/{slug}/`
