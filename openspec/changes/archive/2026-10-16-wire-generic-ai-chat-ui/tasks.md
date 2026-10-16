## 1. Riverpod State Controller & Models

- [x] 1.1 Define `GenericAiChatState` and message view models in `packages/core/lib/data/providers/generic_ai_chat_provider.dart`.
- [x] 1.2 Implement `GenericAiChatNotifier` with methods `sendMessage`, `retryLastSend`, `retryGeneration`, and `startNewChat`.
- [x] 1.3 Wire optimistic message rendering with RFC 4122 v4 UUID `requestId` creation.
- [x] 1.4 Wire `startConversation` (for initial message) and `sendFollowUpMessage` (for active threads) to `LearnLensRepository`.

## 2. In-Flight Polling & Error Recovery

- [x] 2.1 Implement background polling (2s interval) via `repository.getConversationStatus` when turn returns with `processing` status.
- [x] 2.2 Wire automatic polling timer cleanup on notifier disposal.
- [x] 2.3 Implement send error recovery preserving `requestId` for idempotent replay.
- [x] 2.4 Implement generation failure recovery resubmitting the preceding prompt on user action.
- [x] 2.5 Map 429 quota exhaustion errors and expose `retry_at` for composer disabling.

## 3. Conversation History & Navigation

- [x] 3.1 Implement history loading and cursor pagination in the controller via `repository.listConversations`.
- [x] 3.2 Implement `selectConversation(String chatId)` loading message history via `repository.getMessages` ordered oldest to newest.
- [x] 3.3 Implement `startNewChat()` resetting state to an empty canvas.
- [x] 3.4 Build `AiChatHistorySheet` allowing users to view recent conversations and select or create chats.

## 4. UI Integration in `AiScreen`

- [x] 4.1 Convert `AiScreen` to `ConsumerStatefulWidget` and bind composer submissions to `genericAiChatProvider`.
- [x] 4.2 Replace local mock message list with reactive provider state.
- [x] 4.3 Connect inline send error retry and assistant generation failure `[🔄 Try again]` buttons to controller actions.
- [x] 4.4 Connect header menu icon (`LucideIcons.menu`) to open `AiChatHistorySheet`.
- [x] 4.5 Clean up and remove mock simulation code from `ai_screen.dart`.

## 5. Automated Tests & Static Analysis

- [x] 5.1 Add unit tests for `GenericAiChatNotifier` verifying conversation creation, follow-ups, and polling in `packages/core/test/data/providers/generic_ai_chat_provider_test.dart`.
- [x] 5.2 Add unit tests for history pagination, conversation selection, and canvas reset.
- [x] 5.3 Update widget tests in `packages/core/test/screens/ai_screen_test.dart` to verify provider-driven UI rendering and interactions.
- [x] 5.4 Run static analysis and all tests across `packages/core` to verify 0 errors and warnings.

## 6. Institute Settings & AI Tab Visibility

- [x] 6.1 Add `enableAiChatbot` to `InstituteSettings` mapping backend field `enable_ai_chatbot`.
- [x] 6.2 Update `NavTab.active` in `packages/testpress/lib/navigation/app_router.dart` to check `settings?.enableAiChatbot ?? false`.
- [x] 6.3 Remove `SHOW_AI_TAB` from `config/elearn_brilliantpala.json` and remove `AppConfig.showAiTab`.
- [x] 6.4 Update navigation tests and verify full test suite.
