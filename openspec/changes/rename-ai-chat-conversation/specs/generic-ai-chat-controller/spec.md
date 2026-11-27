## ADDED Requirements

### Requirement: Conversation Renaming Lifecycle Management
The system SHALL support renaming an existing conversation via `LearnLensRepository.renameConversation` and requesting inline rename when opening history.

#### Scenario: Successful conversation rename
- **WHEN** `renameConversation(chatId, newTitle)` is invoked with a valid non-empty trimmed title up to 80 characters
- **THEN** the system SHALL update `isRenamingConversation: true`, dispatch `PATCH /chats/{chat_id}/` via the repository, update the title in `conversationHistory` and `currentTitle` (if active), and reset `isRenamingConversation: false`.

#### Scenario: Short-circuiting unchanged conversation title
- **WHEN** `renameConversation(chatId, newTitle)` is called with a sanitized title identical to the existing title in `conversationHistory`
- **THEN** the system SHALL return `true` immediately without making a network request.

#### Scenario: Rejecting invalid or empty titles
- **WHEN** `renameConversation` is called with an empty title or title exceeding 80 characters
- **THEN** the system SHALL return `false` without making a network call.

#### Scenario: Guarding against renaming during in-flight generation
- **WHEN** `renameConversation` or `requestRenameConversation` is called for a conversation that currently has an active AI generation in progress
- **THEN** the system SHALL reject the operation, return `false`, and not call the repository.

#### Scenario: Requesting rename on history opening
- **WHEN** `requestRenameConversation(chatId)` is called
- **THEN** the system SHALL store `pendingRenameChatId: chatId` so the history drawer opens directly with that conversation in inline editing mode.
