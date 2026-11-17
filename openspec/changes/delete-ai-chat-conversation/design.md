## Context

The LearnLens generic AI chat backend exposes `DELETE /api/v2/{org_uuid}/generic/chats/{chat_id}/` to soft-delete conversations (operation `delete_conversation_v2__org_uuid__generic_chats__chat_id___delete`). When deleted, the conversation and its associated turns disappear from history routes (`GET /chats/`) and return HTTP 204. Attempting to delete a conversation while generation is in progress returns HTTP 409 (`generation_in_progress`).

Currently, `AiChatHistoryScreen` lists conversations with cursor-based pagination and allows opening existing conversations or starting a new chat, but offers no deletion capability.

## Goals / Non-Goals

**Goals:**
- Provide a clean, accessible delete action per conversation in `AiChatHistoryScreen`.
- Require confirmation before permanently deleting a conversation to prevent accidental data loss.
- Wire `deleteConversation` through `LearnLensNetworkClient`, `LearnLensRepository`, and `GenericAiChatNotifier`.
- Reconcile in-memory state: remove the deleted conversation from `state.conversations` and reset the chat canvas (`startNewChat()`) if the deleted conversation was the active one.
- Handle generation concurrency (preventing delete or surfacing HTTP 409 if a response is generating).

**Non-Goals:**
- Batch / multi-select conversation deletion.
- Individual message deletion within a conversation.
- Conversation renaming (`PATCH /chats/{id}/`).

## Decisions

### 1. Network & Repository Integration
- `LearnLensNetworkClient.deleteConversation({required String chatId, CancelToken? cancelToken})`: Calls `DELETE $baseUrl/chats/$chatId/` via `_guard()`.
- Maps HTTP 204 to successful completion.
- Maps HTTP 409 to `LearnLensException` with conflict error type.
- `LearnLensRepository.deleteConversation` forwards to the client.

### 2. State & Active Conversation Transition
- In `GenericAiChatNotifier.deleteConversation(String chatId)`:
  - If `state.isStreaming && state.activeConversationId == chatId`, abort or reject with conflict message.
  - Await `_repository.deleteConversation(chatId: chatId)`.
  - Filter out `chatId` from `state.conversations`.
  - If `state.activeConversationId == chatId`, invoke `startNewChat()` to clear active messages and reset to the clean canvas.

### 3. UI Presentation & Confirmation
- Add a trailing options button (`LucideIcons.moreVertical`, min 48×48dp touch target) in each history item row of `AiChatHistoryScreen`.
- Tapping opens an anchored contextual options menu with a destructive delete action.
- Tapping Delete opens a confirmation dialog with localized title, conversation name, cancel action, and a destructive delete action (`isDestructive: true`).
- On confirmation, dispatch `deleteConversation(item.id)`. On failure, show an error toast.

## Risks / Trade-offs

- **[Risk] User deletes the currently active conversation from the history drawer.**  
  → *Mitigation*: The notifier automatically triggers `startNewChat()`, ensuring the background chat canvas gracefully resets to the empty state without showing stale messages.
- **[Risk] Deletion attempted while generation is in progress (HTTP 409).**  
  → *Mitigation*: Disable the delete action if `state.isStreaming` on the active chat, and catch HTTP 409 to surface an explanatory warning.
