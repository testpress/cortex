## ADDED Requirements

### Requirement: Conversation Deletion Management
The controller SHALL coordinate with `LearnLensRepository` to delete conversations and reconcile in-memory state.

#### Scenario: Successfully delete conversation
- **WHEN** `deleteConversation(chatId)` is called
- **THEN** the controller SHALL invoke `repository.deleteConversation(chatId)` and remove the conversation from `state.conversations`.

#### Scenario: Deleting active conversation resets canvas
- **WHEN** the deleted conversation matches `state.activeConversationId`
- **THEN** the controller SHALL reset `activeConversationId` to null, clear loaded messages, and reset the state to a clean new chat.

#### Scenario: Deleting inactive conversation preserves active canvas
- **WHEN** the deleted conversation does not match `state.activeConversationId`
- **THEN** the controller SHALL remove the item from history while leaving the currently active conversation and messages intact.

#### Scenario: In-flight generation conflict handling
- **WHEN** conversation deletion is attempted while an AI response is actively generating for that conversation
- **THEN** the system SHALL reject the deletion attempt and prevent data inconsistencies.

#### Scenario: In-flight deletion concurrency guard
- **WHEN** `deleteConversation` is called while another deletion is already in-flight (`isDeletingConversation == true`)
- **THEN** the controller SHALL immediately return `false` without making redundant network calls.
