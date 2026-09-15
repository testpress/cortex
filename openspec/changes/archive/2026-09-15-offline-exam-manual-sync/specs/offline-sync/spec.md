## MODIFIED Requirements

### Requirement: Background and foreground sync
The system SHALL support manual synchronization of completed offline exams when initiated by the user. Automatic silent background and connectivity-based foreground synchronization triggers SHALL be disabled.

#### Scenario: App foregrounded with pending sync
- **WHEN** the app comes to the foreground or connectivity is regained with pending offline exams
- **THEN** automatic sync MUST NOT trigger; the system remains idle until the user manually initiates sync.

#### Scenario: Manual sync of pending offline exam
- **WHEN** the user manually triggers sync for a pending offline exam
- **THEN** the system MUST construct the answer payload, upload it to the backend endpoint, and mark the local status as `SYNCED` upon success

