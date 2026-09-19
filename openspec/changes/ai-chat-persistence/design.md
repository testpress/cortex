## Context

In `packages/courses/lib/widgets/lesson_detail/ai_tab.dart`, `AITab` manages chat state entirely within widget-local state (`_messages`). When a learner navigates away from the video lesson or reloads the course, the conversation history is lost. LearnLens v2 now provides PostgreSQL-backed persistence and exposes authenticated endpoints to list chats for an asset and retrieve message history for a chat.

## Goals / Non-Goals

**Goals:**
- Implement DTOs for LearnLens chat listing, message history, citations, and message types (`LearnLensChatSessionDto`, `LearnLensMessageDto`).
- Extend `LearnLensNetworkClient` with methods to:
  - `listChats(orgUuid, assetId, sessionToken)`: `GET /v2/{org_uuid}/assets/{asset_id}/chats/` (with optional `limit`, `cursor`, `before` for forward-compatible pagination)
  - `getChatMessages(orgUuid, chatId, sessionToken)`: `GET /v2/{org_uuid}/chats/{chat_id}/messages/` (with optional `limit`, `cursor`, `before` for forward-compatible pagination)
  - Update `submitChat` to pass and receive `chat_id` (while retaining `conversation_id` compatibility).
- Extend `LearnLensRepository` to expose clean domain methods (`fetchChats`, `fetchChatMessages`, `fetchLatestChatHistory`, `submitChat`).
- Centralize session resolution with `resolveLearnLensSession` and handle 401 token refresh retries safely in `LearnLensNetworkClient`.
- Update `AITab`:
  - Fetch existing chat history for the video asset on initialization via `fetchLatestChatHistory`.
  - If existing messages are found, render them in chronological order.
  - Maintain the active `chat_id` across turns.
  - Guard against race conditions during fast lesson switching via lesson ID verification.
  - Display loading indicator during history fetch and retry option on failure.
  - If no previous chat exists, show the standard welcoming AI tutor greeting.

**Non-Goals:**
- AI MCQ persistence & attempt history (tracked separately for PR 2).
- Multi-chat management UI (creating multiple parallel threads, deleting or renaming chats) — auto-resuming the latest active chat for the asset fulfills Phase 1 requirements.
- Offline SQLite/Drift persistence — LearnLens PostgreSQL serves as the server-authoritative source of truth.

## Decisions

### 1. Auto-resume the latest chat for the asset via repository helper
- **Rationale**: Students typically study one lesson at a time and expect to pick up where they left off. `fetchLatestChatHistory` queries `GET /chats/`, sorts by `updatedAt` descending, and automatically fetches messages for `chats.first.id`.
- **Alternative considered**: Showing a list of previous chat threads before opening chat. Rejected because it adds unnecessary friction for a video companion tutor.

### 2. DTO and API path design (with optional future pagination support)
- **Rationale**: Aligns strictly with Swagger documentation:
  - `GET /v2/{org_uuid}/assets/{asset_id}/chats/`
  - `GET /v2/{org_uuid}/chats/{chat_id}/messages/`
  - `POST /v2/{org_uuid}/assets/{asset_id}/chat/` with body `{ "query": ..., "chat_id": ..., "learner_id": ... }`
- **Forward-compatibility**: Optional query parameters (`limit`, `cursor`, `before`) are supported in the network client and repository methods so future features (e.g. infinite scrolling for long conversations) can use them without client-side refactoring.
- **Fallback**: Support both `chat_id` and `conversation_id` in request/response bodies to ensure robust forward/backward compatibility.


### 3. Centralized session resolution and race-safe token refresh
- **Rationale**: Multiple tabs (`AITab`, `VideoMcqTab`) require the same authentication workflow (checking enable flag, validating org ID, checking expiry with 60s buffer, force refreshing when needed). Moving this to `resolveLearnLensSession` removes code duplication. Furthermore, `refreshSession()` captures the response in a local variable before updating provider state to eliminate race conditions during concurrent 401 retries.

### 4. Asynchronous history hydration with smooth UI states and navigation guards
- **Rationale**: While fetching history, display an animated loading indicator in the chat body. Check `widget.lesson.id` after async gaps to prevent stale history from overwriting a newly selected lesson during fast switching. Once hydrated, scroll smoothly to the latest message.

## Risks / Trade-offs

- **[Risk] Slower initial tab load if network is congested**
  → *Mitigation*: Show a lightweight inline loading indicator (`AppLoadingIndicator`) in the chat body while preserving the rest of the video viewer controls and tab header.
- **[Risk] Session token expiry during long video sessions**
  → *Mitigation*: Leverage `LearnLensNetworkClient` 401 interceptor which automatically refreshes the session token and retries in-flight requests.

