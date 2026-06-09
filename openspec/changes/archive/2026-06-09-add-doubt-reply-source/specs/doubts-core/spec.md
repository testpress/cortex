## MODIFIED Requirements

### Requirement: Detail and Follow-ups Syncing
The `DoubtRepository` SHALL sync doubt details and comment threads by calling the `/api/v3/helpdesk/<pk>/` endpoint.
- **Sync Behavior**: When a doubt is retrieved, its details and follow-ups SHALL be fetched from the remote server, and the local `doubts` and `doubt_replies` tables SHALL be updated.
- **Source Attribute**: The parser SHALL extract the `source` attribute (e.g. "Bot" or "Human") from the API payload and persist it in the `DoubtRepliesTable` for each reply.

#### Scenario: Syncing details with Bot Reply
- **GIVEN** the student opens a doubt detail page that contains an AI Bot reply
- **WHEN** the detail provider runs
- **THEN** a details request is sent, updating the replies thread locally, including the `source` field being correctly saved as "Bot".
