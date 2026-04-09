## ADDED Requirements

### Requirement: Router-Level Lesson Orchestration
The system SHALL provide a central orchestration layer within the `app_router.dart` that identifies lesson types and delegates rendering to specialized screens (PDF, Video, Test, Assessment).

#### Scenario: Routing to specialized PDF reader
- **WHEN** a lesson of type "pdf" is navigated to via the router
- **THEN** it SHALL be mapped directly to the `PdfLessonDetailScreen`.

#### Scenario: Routing to specialized Video player
- **WHEN** a lesson of type "video" is navigated to via the router
- **THEN** it SHALL be mapped directly to the `VideoLessonDetailScreen`.

### Requirement: Decoupled Data Loading
The system SHALL handle the fetching of lesson domain models via `lessonDetailProvider` at the route builder level, ensuring specialized screens only receive the finished `Lesson` object.

#### Scenario: Unified loading indicator across types
- **WHEN** a lesson payload is being fetched for any screen
- **THEN** the router SHALL display a unified `AppLoadingIndicator`.
