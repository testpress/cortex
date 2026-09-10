## ADDED Requirements

### Requirement: Persist attachment download task identity
The system SHALL persist a stable task identifier for each in-progress or paused attachment download so the download can be located and resumed after an app restart.

#### Scenario: Task ID stored on download start
- **WHEN** an attachment download is initiated via the background download manager
- **THEN** the task identifier assigned by the download manager SHALL be saved alongside the download record

#### Scenario: Task ID survives app restart
- **WHEN** the app is restarted after an attachment download was paused or interrupted
- **THEN** the persisted task identifier SHALL be available to reconnect the download manager to the in-progress transfer

#### Scenario: Task ID cleared on completion or deletion
- **WHEN** an attachment download completes or is deleted by the user
- **THEN** the task identifier SHALL be cleared from the persisted record
