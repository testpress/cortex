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

