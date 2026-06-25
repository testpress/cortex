## MODIFIED Requirements

### Requirement: Remote Doubt Syncing
The `DoubtRepository` SHALL support syncing the doubts list from the remote `/api/v3/helpdesk/` endpoint.
- **Sync Behavior**: The system SHALL fetch doubts from the remote source and batch-update the local `doubts` Drift table.
- **Filtering**: The API request SHALL allow filtering by ticket status, topic ID, content ID, question ID, and query type (`query_type`).
- **Parsing**: The parser SHALL extract the `query_type` attribute from the API payload and persist it in the `DoubtsTable` for each doubt.

#### Scenario: Syncing doubts from API
- **GIVEN** the student is on the doubts list screen
- **WHEN** the list provider is initialized or a filter is changed
- **THEN** a remote sync request is sent including the current filters, and local database entries are updated on success
