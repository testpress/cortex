## ADDED Requirements

### Requirement: Real-time sync status tracking
The system SHALL track the synchronization state of each course and expose it via a stream. This allows the UI to display appropriate loading indicators when data is being actively fetched from the backend.

#### Scenario: Active sync detected
- **WHEN** a structural or content sync is triggered for a specific course
- **THEN** the `courseSyncStatusProvider` for that course ID SHALL emit `true`

#### Scenario: Sync completed
- **WHEN** a sync operation finishes or fails
- **THEN** the `courseSyncStatusProvider` for that course ID SHALL emit `false`
