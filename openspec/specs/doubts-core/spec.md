# doubts-core Specification

## Purpose
TBD - created by archiving change lms-doubts-list. Update Purpose after archive.
## Requirements
### Requirement: Normalized Doubts Storage
The system SHALL store doubts and replies in separate normalized tables to ensure data integrity and support future rich-text/attachment expansion.

#### Scenario: Storing a Doubt with Replies
- **GIVEN** a student creates a doubt with multiple replies
- **WHEN** the data is persisted locally
- **THEN** the doubt SHALL be stored in the `doubts` table and replies in the `doubt_replies` table, linked by `doubtId`

### Requirement: Doubt Privacy
The system SHALL ensure that doubts are strictly private. A student SHALL only see doubts they have authored, and mentors SHALL see all doubts assigned to them.

#### Scenario: Private Visibility
- **GIVEN** Student A and Student B have asked separate doubts
- **WHEN** Student A fetches their doubts list
- **THEN** only Student A's doubts SHALL be returned; Student B's doubts SHALL NOT be visible

### Requirement: Local Doubt Creation
The `DoubtRepository` SHALL support creating a new doubt record locally.
- **Persistence**: Newly created doubts SHALL be inserted into the local `doubts` table immediately.
- **Mock Integration**: The system SHALL simulate a successful server response for local testing when real API sync is disabled.

#### Scenario: Creating a doubt locally
- **GIVEN** a student has filled the doubt form
- **WHEN** they submit the doubt
- **THEN** a new record SHALL appear in the local database and the UI SHALL reflect the update reactively

