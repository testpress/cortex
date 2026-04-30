## MODIFIED Requirements

### Requirement: Router-Level Lesson Orchestration
The system SHALL provide a central orchestration layer within the `app_router.dart` that identifies lesson types and delegates rendering to specialized lesson viewers while exposing recoverable error states.

#### Scenario: Routing to unified lesson orchestrator
- **WHEN** a lesson of type "pdf", "video", "notes", "embedContent", "liveStream", or "attachment" is navigated to via the router
- **THEN** it SHALL be mapped to the unified lesson-detail route/viewer stack.

#### Scenario: Recoverable load failure
- **WHEN** lesson detail loading fails in the route layer
- **THEN** the route SHALL render a user-facing error state with a retry action.
- **AND** retry SHALL re-trigger the lesson-detail provider fetch for the same lesson id.
