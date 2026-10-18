## MODIFIED Requirements

### Requirement: Chat Header Navigation
The system SHALL provide a dedicated header on the chat canvas with back navigation and conversation history access.

#### Scenario: User navigates back
- **WHEN** the user taps the back button in the header
- **THEN** the system navigates back to the previous screen or tab.

#### Scenario: User opens history menu
- **WHEN** the user taps the hamburger menu icon in the header
- **THEN** the system dismisses the keyboard and opens the conversation history drawer.

### Requirement: Empty Canvas State
The system SHALL render a guided empty state when no conversation messages exist.

#### Scenario: Viewing initial chat screen
- **WHEN** the user opens the AI chat screen with no active messages
- **THEN** the system displays a centered "What can I help with?" heading, four suggestion cards (Explain concept, Solve problem, Practice questions, Study tips), and the composer directly below the cards without a new-chat action.

#### Scenario: Choosing a suggestion
- **WHEN** the user taps a suggestion card
- **THEN** the system prefills the composer with that card's starter prompt, places the caret at the end, and focuses the composer without sending a message.

#### Scenario: Keyboard open on a small screen
- **WHEN** the keyboard reduces the available height below the empty state's content height
- **THEN** the empty state SHALL scroll and keep the composer visible above the keyboard.

### Requirement: Message Bubble Layout and Actions
The system SHALL display user messages and assistant responses with formatted timestamps and action controls.

#### Scenario: Rendering user message
- **WHEN** a user message is present in the thread
- **THEN** the system renders a right-aligned bubble no wider than 75% of the chat column, with a tightened top-end corner and a right-aligned timestamp below it.

#### Scenario: Rendering assistant message
- **WHEN** an assistant message is present in the thread
- **THEN** the system renders a left-aligned bordered card no wider than 75% of the chat column, with a tightened top-start corner and rendered Markdown, followed by a copy action and the timestamp on its own line below it.

#### Scenario: Assistant actions are limited to copy
- **WHEN** a completed assistant message is rendered
- **THEN** the system SHALL NOT show thumbs up, thumbs down, read aloud, share, or more actions.

### Requirement: Generation Error Recovery
The system SHALL display an actionable error card when AI response generation fails on the service.

#### Scenario: Generation failure response
- **WHEN** AI generation fails for an accepted message
- **THEN** the system renders an "AI Assistant" card containing "Couldn't generate a response. Please try again." and a "Try again" action button below the card.

#### Scenario: Retrying failed generation
- **WHEN** the user triggers retry on a failed assistant generation card
- **THEN** the system retrieves the preceding user prompt and regenerates the response using that prompt.

#### Scenario: Retrying while generation is in flight
- **WHEN** AI response generation is already in flight
- **THEN** the system ignores retry triggers to prevent race conditions and interleaved responses.

### Requirement: Bottom Composer Bar
The system SHALL provide a pill-shaped input bar with a "Message" placeholder and an adaptive circular send button.

#### Scenario: Composer input state
- **WHEN** the user types text into the input field
- **THEN** the up-arrow send button switches from an inactive/muted visual state to an active visual state.

#### Scenario: Composer docked in a conversation
- **WHEN** the thread has messages, is loading, or failed to load
- **THEN** the composer SHALL be docked at the bottom above a divider with a leading circular new-chat action.

#### Scenario: Starting a new chat from the composer
- **WHEN** the user taps the new-chat action next to the composer
- **THEN** the system SHALL reset to a new conversation and show the empty state.
