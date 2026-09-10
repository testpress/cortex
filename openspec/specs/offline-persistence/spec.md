# offline-persistence Specification

## Purpose
TBD - created by archiving change offline-exam-support. Update Purpose after archive.
## Requirements
### Requirement: Persist offline exam structure
The system SHALL persist the complete exam hierarchy (instructions, sections, questions, and choices) in the local database.

#### Scenario: Downloading an exam
- **WHEN** the user initiates an exam download
- **THEN** all structural data is saved to the local Drift database as `OfflineCourseAttempt` and related entities.

### Requirement: Local state tracking
The system SHALL record every user action (e.g. selecting an answer, marking for review) locally.

#### Scenario: Offline choice selection
- **WHEN** the user is in an offline exam and selects a choice
- **THEN** the selection is instantly saved to the local database as an `OfflineAttemptItem`.

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

