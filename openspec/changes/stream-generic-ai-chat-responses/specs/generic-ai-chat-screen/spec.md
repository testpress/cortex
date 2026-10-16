## ADDED Requirements

### Requirement: Assistant Generating Indicator
The system SHALL show a generating indicator inside the assistant card while a streamed answer has not yet produced text.

#### Scenario: Waiting for the first delta
- **WHEN** a provisional assistant message exists with no text
- **THEN** the assistant card SHALL render an animated typing indicator with an accessible "Generating response" label instead of an empty card.

#### Scenario: Streaming text in progress
- **WHEN** a provisional assistant message has partial text
- **THEN** the assistant card SHALL render the partial Markdown and hide the copy and timestamp actions until completion.

#### Scenario: Runtime motion and accessible status
- **WHEN** motion preferences or design tokens change while waiting for text
- **THEN** the indicator SHALL stop or resume its ticker accordingly, use design motion and spacing tokens, and expose the generating status once to assistive technology.
