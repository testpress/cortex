## ADDED Requirements

### Requirement: Capture Unhandled Exceptions in Courses
The system SHALL capture unhandled exceptions, network failures, and unexpected parsing errors within the `courses` module and log them to Sentry.

#### Scenario: Exception during course fetch
- **WHEN** a repository (e.g., `CourseRepository`) encounters an unexpected exception while fetching or syncing data
- **THEN** the exception and stack trace are captured and logged to `SentryService` before rethrowing or returning null

#### Scenario: Exception in lesson provider
- **WHEN** a provider (e.g., `LessonDetailProvider`) encounters an unexpected error parsing or updating state
- **THEN** the exception and stack trace are captured and logged to `SentryService`

#### Scenario: Error during download processing
- **WHEN** a file download or media processing task fails unexpectedly in the UI or background tasks for a course
- **THEN** the exception and stack trace are logged to `SentryService` with an appropriate severity level
