## Why

Currently, LearnLens AI Chat in video lessons (`AITab`) only keeps conversation messages in local widget state (`_messages`). When a learner navigates away from the video or refreshes the app, the chat is lost and starts over with a generic greeting. LearnLens v2 now exposes durable chat persistence endpoints (`GET .../assets/{asset_id}/chats/`, `GET .../chats/{chat_id}/messages/`, and `POST .../chat/` with `chat_id`) to allow restoring and continuing prior chat sessions for an asset across visits.

## What Changes

- **DTO Layer**: Add DTO models for chat sessions (`LearnLensChatSessionDto`) and chat messages (`LearnLensMessageDto`), parsing fields such as `id` (`chat_id`), `title`, `role`, `content`, `citations`, and `created`.
- **Network Layer**: Add methods in `LearnLensNetworkClient` to list chats for an asset (`GET /v2/{orgUuid}/assets/{assetId}/chats/`) and fetch messages for a chat (`GET /v2/{orgUuid}/chats/{chatId}/messages/`).
- **Repository Layer**: Add `getLatestChat` or `fetchChats` and `fetchChatMessages` in `LearnLensRepository`, updating `submitChat` to pass `chat_id` and track the active `chat_id`.
- **UI & State Layer (`AITab`)**:
  - On opening the AI Support tab, automatically restore the latest active chat session and its historical messages for that asset.
  - If existing chat history exists, render the persisted messages immediately. If no chat exists, show the initial greeting.
  - Retain the active `chat_id` and pass it with subsequent queries so new turns are appended to the same thread.
  - Handle loading and error states during chat history retrieval gracefully with retry options.

## Capabilities

### New Capabilities
<!-- No new standalone capabilities required; this enhances the existing video-ai-chat feature. -->

### Modified Capabilities
- `video-ai-chat`: Extend requirements to include retrieving asset-specific chat history (`GET /chats/` & `GET /chats/{chat_id}/messages/`) upon entering the tab and appending new turns using the persistent `chat_id`.

## Impact

- `packages/courses/lib/network/learnlens_network_client.dart`: New GET endpoints for chats and messages; update `submitChat` to use `chat_id`.
- `packages/courses/lib/repositories/learnlens_repository.dart`: Repository methods for chat listing, message retrieval, and session resumption.
- `packages/core/lib/data/models/learnlens_dto.dart`: New DTOs for `LearnLensChatSessionDto` and `LearnLensMessageDto`.
- `packages/courses/lib/widgets/lesson_detail/ai_tab.dart`: Lifecycle loading of history, rendering historical messages, and state handling.
