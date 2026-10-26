## MODIFIED Requirements

### Requirement: Sync Delta Video Progress
The system SHALL synchronize the user's `last_watch_position` and newly tracked `watched_time_ranges` (delta ranges) to the server targeting the active video attempt session.

#### Scenario: Synchronizing progress to active video attempt
- **WHEN** an active video attempt ID is resolved for the lesson
- **THEN** the system SHALL send `last_position` and `time_ranges` to the `user_videos/{id}/` endpoint.

#### Scenario: Periodic background sync
- **WHEN** the user is actively watching a video and the periodic sync interval triggers
- **THEN** the system SHALL synchronize the delta ranges and clear the local delta list upon success.

#### Scenario: Event-driven sync on pause, seek, or back navigation
- **WHEN** the user pauses, seeks, or navigates away from the video player
- **THEN** the system SHALL synchronize pending progress to the server.

#### Scenario: Fallback synchronization when attempt ID is unavailable
- **WHEN** the active video attempt ID cannot be resolved or playback is offline
- **THEN** the system SHALL fall back to synchronizing progress using the chapter content video update endpoint.
