# offline-sync Specification

## Purpose
TBD - created by archiving change offline-exam-support. Update Purpose after archive.
## Requirements
### Requirement: Background and foreground sync
The system SHALL attempt to sync completed offline exams immediately upon app foregrounding or when network connectivity is restored.

#### Scenario: App foregrounded with pending sync
- **WHEN** the app comes to the foreground and there is a `COMPLETED` local exam attempt
- **THEN** the system triggers the sync queue to push the payload to the backend.

### Requirement: Enforce strict end date validation
The system SHALL NOT allow a sync if the absolute `endDate` + `graceDurationForOfflineSubmission` has passed locally.

#### Scenario: Offline exam submitted on time
- **WHEN** the local app syncs an exam before the server's absolute deadline
- **THEN** the sync succeeds and the local attempt is cleared.

