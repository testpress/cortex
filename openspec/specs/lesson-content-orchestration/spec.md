# lesson-content-orchestration Specification

## Purpose
TBD - created by archiving change lesson-detail-refactor. Update Purpose after archive.
## Requirements
### Requirement: Router-Level Lesson Orchestration
The system SHALL provide a central orchestration layer within the `app_router.dart` that identifies lesson types and delegates rendering to specialized lesson viewers while exposing recoverable error states.

#### Scenario: Routing to unified lesson orchestrator
- **WHEN** a lesson of type "pdf", "video", "notes", "embedContent", "liveStream", or "attachment" is navigated to via the router
- **THEN** it SHALL be mapped to the unified lesson-detail route/viewer stack.

#### Scenario: Recoverable load failure
- **WHEN** lesson detail loading fails in the route layer
- **THEN** the route SHALL render a user-facing error state with a retry action.
- **AND** retry SHALL re-trigger the lesson-detail provider fetch for the same lesson id.

### Requirement: Decoupled Data Loading
The system SHALL handle the fetching of lesson domain models via `lessonDetailProvider` at the route builder level, ensuring specialized screens only receive the finished `Lesson` object.

#### Scenario: Unified loading indicator across types
- **WHEN** a lesson payload is being fetched for any screen
- **THEN** the router SHALL display a unified `AppLoadingIndicator`.

