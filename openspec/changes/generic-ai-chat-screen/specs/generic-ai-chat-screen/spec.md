## ADDED Requirements

### Requirement: Chat Header Navigation
The system SHALL provide a dedicated header with back navigation and conversation history access.

#### Scenario: User navigates back
- **WHEN** the user taps the back button in the header
- **THEN** the system navigates back to the previous screen or tab.

#### Scenario: User opens history menu
- **WHEN** the user taps the hamburger menu icon in the header
- **THEN** the system triggers the conversation history drawer or navigation.

### Requirement: Empty Canvas State
The system SHALL render a clean, distraction-free canvas when no conversation messages exist.

#### Scenario: Viewing initial chat screen
- **WHEN** the user opens the AI chat screen with no active messages
- **THEN** the system displays a blank chat canvas with the bottom composer pinned at the bottom.

### Requirement: Message Bubble Layout and Actions
The system SHALL display user messages and assistant responses with formatted timestamps and action controls.

#### Scenario: Rendering user message
- **WHEN** a user message is present in the thread
- **THEN** the system renders a right-aligned rounded bubble with a right-aligned timestamp below it.

#### Scenario: Rendering assistant message
- **WHEN** an assistant message is present in the thread
- **THEN** the system renders a left-aligned bordered card containing rendered Markdown, with copy, more menu, and timestamp actions below it.

### Requirement: Inline Send Error Recovery
The system SHALL display an inline retry indicator when sending a message fails, preserving the user message bubble.

#### Scenario: Message send failure
- **WHEN** submitting a user query encounters a transport failure
- **THEN** the user bubble remains visible, and the system displays "Couldn't send message. Tap to retry" in red below the bubble.

### Requirement: Generation Error Recovery
The system SHALL display an actionable error card when AI response generation fails on the service.

#### Scenario: Generation failure response
- **WHEN** AI generation fails for an accepted message
- **THEN** the system renders an "AI Assistant" card with "Couldn't generate a response. Please try again." and a "Try again" action button.

### Requirement: Bottom Composer Bar
The system SHALL provide a pill-shaped input bar with an adaptive circular send button.

#### Scenario: Composer input state
- **WHEN** the user types text into the input field
- **THEN** the up-arrow send button switches from an inactive/muted visual state to an active visual state.
