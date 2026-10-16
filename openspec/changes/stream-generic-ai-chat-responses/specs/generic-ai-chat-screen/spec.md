## ADDED Requirements

### Requirement: Assistant Generating Indicator
The system SHALL show a generating indicator inside the assistant card while a streamed answer has not yet produced text.

#### Scenario: Waiting for the first delta
- **WHEN** a provisional assistant message exists with no text
- **THEN** the assistant card SHALL render an animated typing indicator with an accessible "Generating response" label instead of an empty card.

#### Scenario: Streaming text in progress
- **WHEN** a provisional assistant message has partial text
- **THEN** the assistant card SHALL render the partial Markdown and hide the copy and timestamp actions until completion.
