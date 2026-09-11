## 1. DTO & Model Layer

- [x] 1.1 Create `LearnLensChatSessionDto` and `LearnLensMessageDto` in `packages/core/lib/data/models/learnlens_dto.dart` to parse chat session metadata, historical message turns, citations, and message types.
- [x] 1.2 Update `LearnLensChatResponseDto` to parse `chatId` (with fallback to `conversationId`), citations, and message types.


## 2. Network Client Layer

- [x] 2.1 Add `listChats` method in `LearnLensNetworkClient` to call `GET /v2/{orgUuid}/assets/{assetId}/chats/` (with optional `limit`, `cursor`, `before` support).
- [x] 2.2 Add `getChatMessages` method in `LearnLensNetworkClient` to call `GET /v2/{orgUuid}/chats/{chatId}/messages/` (with optional `limit`, `cursor`, `before` support).
- [x] 2.3 Update `submitChat` in `LearnLensNetworkClient` to accept `chatId` and send it in the request payload.
- [x] 2.4 Refactor list extraction helper `_extractList` in `LearnLensNetworkClient` to eliminate duplicated response parsing logic across `listChats` and `getChatMessages`.
- [x] 2.5 Ensure `LearnLensNetworkClient` 401 retry interceptor seamlessly updates authentication headers and retries in-flight requests.


## 3. Repository & Provider Layer

- [x] 3.1 Add `fetchChats`, `fetchChatMessages`, and `fetchLatestChatHistory` domain methods in `LearnLensRepository`.
- [x] 3.2 Update `submitChat` in `LearnLensRepository` to accept and pass `chatId`.
- [x] 3.3 Implement `resolveLearnLensSession` in `learnlens_provider.dart` for reusable, centralized session resolution and token expiration checks across lesson tabs.
- [x] 3.4 Fix concurrency race condition in `LearnlensSession.refreshSession` to ensure robust token return during automatic 401 retries.

## 4. UI & State Integration in AITab

- [x] 4.1 Update `_AITabState` to track `_isLoadingHistory`, `_historyError`, and active `_chatId`.
- [x] 4.2 Implement initial chat history hydration in `AITab`, loading the latest chat session and its messages for the video asset using `fetchLatestChatHistory`.
- [x] 4.3 Populate `_messages` with historical turns, falling back to introductory greeting when no prior chat exists.
- [x] 4.4 Update `_sendMessage` to pass `_chatId` and maintain the persistent thread across multiple turns.
- [x] 4.5 Add loading and error state views in `AITab` during history fetch with a retry action.
- [x] 4.6 Guard async gaps with `widget.lesson.id` checks and `if (!mounted) return;` to prevent race conditions during rapid lesson navigation.
- [x] 4.7 Deduplicate loading bubble removal across submission success and error paths.

## 5. Verification & Tests

- [x] 5.1 Add unit tests for `LearnLensNetworkClient` and `LearnLensRepository` verifying chat listing, message history parsing, query parameters, and session error recovery.
- [x] 5.2 Add widget tests for `AITab` testing history hydration, fallback greeting, and persistent message submission.
