## ADDED Requirements

### Requirement: Remote Doubt Syncing
The `DoubtRepository` SHALL support syncing the doubts list from the remote `/api/v3/helpdesk/` endpoint.
- **Sync Behavior**: The system SHALL fetch doubts from the remote source and batch-update the local `doubts` Drift table.
- **Filtering**: The API request SHALL allow filtering by ticket status, topic ID, content ID, and question ID.

#### Scenario: Syncing doubts from API
- **GIVEN** the student is on the doubts list screen
- **WHEN** the list provider is initialized
- **THEN** a remote sync request is sent, and local database entries are updated on success

### Requirement: Detail and Follow-ups Syncing
The `DoubtRepository` SHALL sync doubt details and comment threads by calling the `/api/v3/helpdesk/<pk>/` endpoint.
- **Sync Behavior**: When a doubt is retrieved, its details and follow-ups SHALL be fetched from the remote server, and the local `doubts` and `doubt_replies` tables SHALL be updated.

#### Scenario: Syncing details
- **GIVEN** the student opens a doubt detail page
- **WHEN** the detail provider runs
- **THEN** a details request is sent, updating both the doubt's status and its replies thread locally

## MODIFIED Requirements

### Requirement: Local Doubt Creation
The `DoubtRepository` SHALL support creating a new doubt by posting to the server-side `/api/v3/helpdesk/` endpoint.
- **Persistence**: Upon a successful API response, the newly created doubt and its details SHALL be saved into the local `doubts` table.
- **Error Handling**: If the API request fails, the system SHALL propagate the error to the calling provider without saving to the local database.

#### Scenario: Creating a doubt via API
- **GIVEN** a student submits the doubt form
- **WHEN** the backend responds with a 201 Created status
- **THEN** the new doubt record SHALL be inserted into the local database and the UI updated reactively
