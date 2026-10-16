## Why

With the LearnLens data and network layer consolidated and merged into `packages/core`, `AiScreen` must be wired to the real backend. Currently, `AiScreen` relies on local mock state, preventing users from creating live conversations, streaming/polling responses, recovering from failures, and viewing conversation history.

## What Changes

- **Riverpod State Management**: Introduce `genericAiChatProvider` managing active conversation state, message lists, turn submission lifecycle, and error conditions.
- **Live Message Submission**: Wire `AiScreen` to dispatch queries through `LearnLensRepository`, supporting both initial conversation creation (`startConversation`) and existing thread follow-ups (`sendFollowUpMessage`).
- **Async Turn Polling**: Implement automatic status polling via `getConversationStatus` when a submitted turn returns in `processing` state.
- **Error Recovery Affordances**:
  - Wire inline send error retry to re-dispatch the pending request with its original `requestId`.
  - Wire the assistant failure card's `[🔄 Try again]` button to resubmit the preceding query.
  - Surface 429 quota exhaustion errors with countdowns derived from `retry_at`.
- **Conversation History Drawer**: Connect the header menu action to a conversation drawer/sheet powered by `listConversations`, allowing students to switch conversations and reset to a new chat.
- **Dynamic Policy Enforcement**: Link `AiComposer` max characters and send validations to the active `AiChatPolicyDto`.

## Capabilities

### New Capabilities
- `generic-ai-chat-controller`: State controller coordinating optimistic turn lifecycle, background polling, and error recovery.
- `generic-ai-chat-history`: UI and state management for browsing previous conversation history and switching active chats.

### Modified Capabilities
- `ai-screen`: Binds `AiScreen` to live Riverpod state, replacing mock state simulation with real backend communication.
- `ai-tab`: AI tab visibility is governed dynamically by `InstituteSettings.enableAiChatbot` rather than static build-time config flags.

## Impact

- `packages/core/lib/data/config/institute_settings.dart`: Add `enableAiChatbot` parsed from backend `enable_ai_chatbot` field.
- `packages/core/lib/data/config/app_config.dart`: Remove static `showAiTab` build flag.
- `config/elearn_brilliantpala.json`: Remove deprecated `SHOW_AI_TAB` configuration.
- `packages/testpress/lib/navigation/app_router.dart`: Update `NavTab.ai` visibility condition to evaluate `settings?.enableAiChatbot ?? false`.
- `packages/core/lib/data/providers/generic_ai_chat_provider.dart`: New Riverpod notifier and state definitions.
- `packages/core/lib/screens/ai_screen.dart`: Refactor from `StatefulWidget` to `ConsumerStatefulWidget` binding composer, message stream, and action callbacks to the provider.
- `packages/core/lib/widgets/ai_chat_history_sheet.dart`: New sliding drawer/sheet for conversation selection.
- `packages/core/test/`: Comprehensive unit tests for the controller and updated widget tests for `AiScreen`.
