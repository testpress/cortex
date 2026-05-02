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

### Requirement: Live Stream Metadata Enrichment
The system MUST correctly parse and expose live-stream specific metadata including stream URLs and current status from the content API.

#### Scenario: Parsing Live Stream Content
- **WHEN** the content API returns a "Live Stream" content type with a `live_stream` object
- **THEN** the system SHALL extract `stream_url` for media playback.
- **AND** it SHALL map the `status` to appropriate `isRunning` and `isUpcoming` flags.
- **AND** it SHALL parse `show_recorded_video` to determine if recorded content should be displayed after the stream ends.

### Requirement: Scheduled Content Handling
The system SHALL gracefully handle content that is not yet released by parsing the scheduled message from 403 Forbidden API responses.

#### Scenario: Displaying scheduled message
- **WHEN** the content API returns a 403 Forbidden with error code "scheduled"
- **THEN** the system SHALL parse the provided message into the lesson domain model.
- **AND** it SHALL display a placeholder UI with the scheduled message instead of the standard viewer.

