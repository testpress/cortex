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
The `DoubtRepository` SHALL support creating a new doubt by posting to the server-side `/api/v3/helpdesk/` endpoint.
- **Persistence**: Upon a successful API response, the newly created doubt and its details SHALL be saved into the local `doubts` table.
- **Error Handling**: If the API request fails, the system SHALL propagate the error to the calling provider without saving to the local database.

#### Scenario: Creating a doubt via API
- **GIVEN** a student submits the doubt form
- **WHEN** the backend responds with a 201 Created status
- **THEN** the new doubt record SHALL be inserted into the local database and the UI updated reactively

### Requirement: Remote Doubt Syncing
The `DoubtRepository` SHALL support syncing the doubts list from the remote `/api/v3/helpdesk/` endpoint.
- **Sync Behavior**: The system SHALL fetch doubts from the remote source and batch-update the local `doubts` Drift table.
- **Filtering**: The API request SHALL allow filtering by ticket status, topic ID, content ID, question ID, and query type (`query_type`).
- **Parsing**: The parser SHALL extract the `query_type` attribute from the API payload and persist it in the `DoubtsTable` for each doubt.

#### Scenario: Syncing doubts from API
- **GIVEN** the student is on the doubts list screen
- **WHEN** the list provider is initialized or a filter is changed
- **THEN** a remote sync request is sent including the current filters, and local database entries are updated on success

### Requirement: Detail and Follow-ups Syncing
The `DoubtRepository` SHALL sync doubt details and comment threads by calling the `/api/v3/helpdesk/<pk>/` endpoint.
- **Sync Behavior**: When a doubt is retrieved, its details and follow-ups SHALL be fetched from the remote server, and the local `doubts` and `doubt_replies` tables SHALL be updated.
- **Source Attribute**: The parser SHALL extract the `source` attribute (e.g. "Bot" or "Human") from the API payload and persist it in the `DoubtRepliesTable` for each reply.

#### Scenario: Syncing details with Bot Reply
- **GIVEN** the student opens a doubt detail page that contains an AI Bot reply
- **WHEN** the detail provider runs
- **THEN** a details request is sent, updating the replies thread locally, including the `source` field being correctly saved as "Bot".

