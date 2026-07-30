## ADDED Requirements

### Requirement: AI Chat Session Authentication
The system SHALL authenticate with the LearnLens API by passing an X-Session-Token generated via the `/ai-sessions/create/` endpoint.

#### Scenario: AI Session Initialization
- **WHEN** the user opens an AI-enabled video lesson
- **THEN** the system calls the session creation endpoint and caches the returned session token.

### Requirement: Submitting AI Chat Queries
The system SHALL allow users to submit queries and display markdown-formatted responses.

#### Scenario: Valid Chat Query
- **WHEN** the user submits a question in the AI Chat tab
- **THEN** the system calls the LearnLens Chat API using the cached session token and displays the markdown response.

### Requirement: Interactive Video Timestamps
The system SHALL parse `<span class="video-timestamp">` tags in the chat response and make them clickable links that control video playback.

#### Scenario: Navigating via Timestamp
- **WHEN** the user clicks on a timestamp in the chat response
- **THEN** the video player seeks to the specified timestamp and resumes playback.
