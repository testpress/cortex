## ADDED Requirements

### Requirement: Exams Tab Lesson Routing
The system SHALL support opening all lesson types (such as PDFs, videos, notes, tests, and assessments) from within the Exams tab. For non-exam lesson types, the system SHALL route the user to a dedicated full-screen lesson view.

#### Scenario: Clicking a non-exam lesson in the Exams chapter view
- **WHEN** the user selects a non-exam lesson (e.g., PDF, video, note) in the Exams course chapter detail view
- **THEN** the system SHALL navigate to `/exams/lesson/:id` using the root navigator
- **AND** the system MUST display the lesson content in full-screen using the `LessonDetailOrchestrator`

#### Scenario: Navigating to a test or assessment via the Exams lesson route
- **WHEN** the user is routed to `/exams/lesson/:id` but the resolved lesson is an exam type (e.g., test or assessment)
- **THEN** the system SHALL redirect the user to the appropriate test/assessment route under `/exams`
