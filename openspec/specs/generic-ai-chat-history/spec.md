# generic-ai-chat-history Specification

## Purpose
TBD - created by archiving change wire-generic-ai-chat-ui. Update Purpose after archive.
## Requirements
### Requirement: Conversation History Retrieval & Pagination
The system SHALL display the student's previous AI chat conversations and support infinite cursor-based pagination.

#### Scenario: Loading initial conversation list
- **WHEN** the user opens the conversation history drawer or sheet
- **THEN** the system SHALL call `repository.listConversations(limit: 20)` and display previous chats ordered by most recent activity.

#### Scenario: Paginating conversation history
- **WHEN** the user scrolls to the bottom of the history list and a `next_cursor` exists
- **THEN** the system SHALL fetch the next page of conversations using the cursor and append them to the list.

### Requirement: Conversation Switching & Canvas Reset
The system SHALL allow switching between previous conversations and starting a new chat.

#### Scenario: Selecting a previous conversation
- **WHEN** the user taps an existing conversation from the history list
- **THEN** the system SHALL set `currentChatId` to the selected conversation, fetch its message history via `repository.getMessages(chatId)`, and render the loaded messages ordered oldest to newest.

#### Scenario: Starting a new conversation from history
- **WHEN** the user taps the "New Chat" button in the history sheet or header
- **THEN** the system SHALL reset `currentChatId` to null, clear the message canvas, and present a clean empty conversation canvas.

### Requirement: Conversation Deletion Action and Confirmation
The history drawer SHALL provide a confirmation-gated delete action on conversation items.

#### Scenario: Display options action
- **WHEN** conversation history items are rendered in the history drawer
- **THEN** each item SHALL display an accessible options button (3 dots) with at least 48×48dp touch target.

#### Scenario: Opening conversation actions
- **WHEN** the user taps the options action on a conversation item
- **THEN** the system SHALL display an anchored contextual options menu positioned adjacent to the options button offering conversation options including deletion.

#### Scenario: Non-overlapping interactive semantics
- **WHEN** conversation history items are rendered with delete actions
- **THEN** the open-chat interaction and semantics SHALL be scoped to the title/timestamp area, preventing nested button semantics with the delete button.

#### Scenario: Confirming conversation deletion
- **WHEN** the user taps the delete action on a conversation item
- **THEN** the system SHALL display a confirmation dialog prompting the user with the conversation title and a destructive confirm action before dispatching the deletion.

#### Scenario: Deletion attempted during active generation
- **WHEN** the user taps the delete action on a conversation while a response is actively generating for it
- **THEN** the system SHALL immediately display a warning toast without prompting for confirmation.

#### Scenario: Cancelling conversation deletion
- **WHEN** the user cancels the confirmation dialog
- **THEN** the conversation SHALL remain in the history list without making any network call.

#### Scenario: Successful deletion updates drawer
- **WHEN** deletion completes successfully
- **THEN** the conversation item SHALL be removed from the history list.

