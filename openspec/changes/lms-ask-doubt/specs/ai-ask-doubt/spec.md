# Specs: LMS Ask Doubt (AI Assistant)

## ADDED Requirements

### Requirement: AI Hub Navigation
The system SHALL navigate from the AI Assistant hub to a dedicated "Ask a Doubt" route.

#### Scenario: User opens Ask a Doubt
- **WHEN** the user taps the "Ask a Doubt" card in the AI Assistant hub
- **THEN** the system SHALL transition to the `AskDoubtScreen`
- **AND** the transition SHALL be smooth (AppRoute default)
- **AND** the Ask Doubt route SHALL render within the existing app shell/navigation context used by the hub flow

### Requirement: Empty State & Suggestions
The system SHALL provide guidance when no messages are present in the current session.

#### Scenario: Initial empty state
- **WHEN** the `AskDoubtScreen` is opened for a new session
- **THEN** it SHALL display a localized empty-state greeting asking how the assistant can help
- **AND** it SHALL show 4 localized quick suggestion cards for concept explanation, problem solving, practice questions, and study tips
- **AND** the quick suggestion cards SHALL maintain consistent row heights when labels wrap or text scaling increases
- **AND** the quick suggestion card labels SHALL be visually centered within each tile
- **WHEN** a user taps a chip
- **THEN** the chip text SHALL be populated into the chat input field (or sent directly)

### Requirement: Multimedia Chat Interface
The system SHALL allow users to send text and images to the AI assistant.

#### Scenario: Sending a text doubt
- **WHEN** the user types a question and taps the "Send" (Up arrow) button
- **THEN** the message SHALL appear as a soft grey student bubble on the right
- **AND** the AI SHALL display a localized thinking indicator
- **AND** a response SHALL appear left-aligned without a surrounding bubble container

#### Scenario: Attaching an image
- **WHEN** the user taps the "Plus" button
- **THEN** the system SHALL create a mock image-backed doubt using the current placeholder attachment flow
- **AND** the attachment flow MAY use a predefined image source instead of a real picker in the current sprint
- **WHEN** the mock attachment is sent
- **THEN** the image SHALL be displayed within the student's message bubble

### Requirement: Visual Design & Feedback
The chat interface SHALL provide visual feedback for all interactive states.

#### Scenario: Typing and Sending
- **WHEN** the input field is empty
- **THEN** the "Send" button SHALL appear visually dimmed
- **AND** empty send attempts SHALL have no effect
- **WHEN** the user is typing
- **THEN** the input SHALL update in real time
- **WHEN** the software keyboard opens on device
- **THEN** the composer SHALL remain visible within the viewport
- **AND** the composer SHALL stay closely aligned to the keyboard edge
- **AND** keyboard spacing MAY be tuned by orientation, with portrait appearing near-flush and landscape allowing a small buffer
- **AND** the composer position SHALL respond to the actual rendered composer height instead of a fixed height assumption
- **WHEN** the user taps the input surface again after dismissing the keyboard
- **THEN** the keyboard SHALL reopen reliably
- **AND** the reopen behavior SHALL remain reliable even when the editable child handles the tap interaction
- **WHEN** a message is sent
- **THEN** the keyboard SHALL remain open (standard chat behavior)
- **AND** the view SHALL auto-scroll to the latest message

### Requirement: Localized and Token-Driven UI
The Ask Doubt implementation SHALL use shared localization resources and Cortex design tokens for user-facing UI.

#### Scenario: Rendering Ask Doubt surfaces and copy
- **WHEN** the Ask Doubt screen renders headers, actions, placeholders, prompts, empty-state labels, or mock assistant responses
- **THEN** those strings SHALL come from shared app localizations
- **AND** visible colors for surfaces, text, overlays, and cursors SHALL come from the design system instead of hardcoded literals

#### Scenario: Rendering session menu in dark mode
- **WHEN** the session overflow menu is opened in dark mode
- **THEN** the menu surface SHALL provide sufficient contrast with the page background
- **AND** all menu actions, not just destructive ones, SHALL remain clearly readable

#### Scenario: Managing a pinned session
- **WHEN** the user opens the overflow menu for a session that is already pinned
- **THEN** the primary pin action SHALL read as `Unpin`
- **AND** pinned sessions SHALL remain above unpinned sessions in the history list even after new chats are created

### Requirement: State Consistency & Race Condition Prevention
The system SHALL ensure that asynchronous AI responses are appended to the most recent session state.

#### Scenario: User clears chat during AI thinking
- **WHEN** the AI is in "Thinking" mode following a user message
- **AND** the user clears the chat session (or modifies the message history) before the AI response is received
- **THEN** the subsequent AI response SHALL NOT revert the chat to the stale state captured before the delay
- **AND** the AI response SHALL be appended to the current state of the session if it still exists
### Requirement: Proper Resource Management
The Ask Doubt implementation SHALL manage lifecycle-dependent resources correctly to prevent memory leaks.

#### Scenario: Using FocusNodes in interactive overlays
- **WHEN** an interactive field like the rename session dialog requires focus
- **THEN** the system SHALL manage the `FocusNode` lifecycle within a `StatefulWidget` or equivalent controller
- **AND** the `FocusNode` SHALL be explicitly disposed of when the parent widget is removed from the tree
- **AND** focus SHALL be requested programmatically when the overlay appears, rather than instantiating new nodes during build

### Requirement: Robust Resource Identifiers
The system SHALL use sufficiently unique identifiers for all internal resources to prevent collisions.

#### Scenario: Generating IDs for sessions and messages
- **WHEN** a new session or message (user/AI/image) is created
- **THEN** its `id` SHALL be generated with sufficient entropy to avoid collisions even when multiple items are created in rapid succession
- **AND** the generation logic SHALL incorporate microsecond-level precision combined with current state metadata (e.g., list length) to ensure uniqueness
