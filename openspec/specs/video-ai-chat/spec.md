# video-ai-chat Specification

## Purpose
TBD - created by archiving change video-ai-chat-mcq. Update Purpose after archive.

## Requirements

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

### Requirement: AI Chat UI Layout and Theming
The system SHALL display the AI Chat tab with a white background, grey AI response bubble containers, avatars for both AI and user messages, message timestamps, and a styled interactive send button.

#### Scenario: AI Chat Messages Rendering
- **WHEN** the user views the AI Chat tab
- **THEN** the screen background SHALL be white
- **AND** the AI response message bubbles SHALL have a light grey background
- **AND** AI messages SHALL display a neutral sparkles avatar on the left
- **AND** user messages SHALL display a profile avatar on the right
- **AND** messages SHALL display fixed creation timestamps in 24hr format (`HH:mm`) under each bubble
- **AND** the send button SHALL render with a themed background container and paper plane icon
- **AND** the text field border SHALL highlight when focused or containing text

### Requirement: AI Chat Accessibility
The system SHALL ensure all interactive elements in the AI Chat tab are reachable and correctly announced by screen readers (TalkBack/VoiceOver).

#### Scenario: Timestamp Links Reachable by Screen Reader
- **WHEN** an AI message contains timestamp links (e.g., `[1:23]`)
- **THEN** each link SHALL be individually focusable and activatable by screen readers
- **AND** the AI bubble container SHALL NOT suppress child semantics with a merged label

#### Scenario: Send Button Announced Once
- **WHEN** a screen reader focuses the send button
- **THEN** it SHALL be announced as a single button with a localized label
- **AND** the tap action SHALL fire exactly once on activation

#### Scenario: Semantic Labels Are Localized
- **WHEN** a screen reader reads chat messages
- **THEN** sender labels ("AI", "You") SHALL be announced in the device's active locale
- **AND** the message semantic label SHALL use localized ARB strings
