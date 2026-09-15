# offline-sync Specification

## Purpose
TBD - created by archiving change offline-exam-support. Update Purpose after archive.
## Requirements
### Requirement: Background and foreground sync
The system SHALL support manual synchronization of completed offline exams when initiated by the user. Automatic silent background and connectivity-based foreground synchronization triggers SHALL be disabled.

#### Scenario: App foregrounded with pending sync
- **WHEN** the app comes to the foreground or connectivity is regained with pending offline exams
- **THEN** automatic sync MUST NOT trigger; the system remains idle until the user manually initiates sync.

#### Scenario: Manual sync of pending offline exam
- **WHEN** the user manually triggers sync for a pending offline exam
- **THEN** the system MUST construct the answer payload, upload it to the backend endpoint, and mark the local status as `SYNCED` upon success

### Requirement: Enforce strict end date validation
The system SHALL NOT allow a sync if the absolute `endDate` + `graceDurationForOfflineSubmission` has passed locally.

#### Scenario: Offline exam submitted on time
- **WHEN** the local app syncs an exam before the server's absolute deadline
- **THEN** the sync succeeds and the local attempt is cleared.

