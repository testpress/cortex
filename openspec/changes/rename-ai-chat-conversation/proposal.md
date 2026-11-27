## Why

Students need the ability to rename past AI chat conversations from the conversation history drawer to better organize their study topics and distinguish related threads. The LearnLens backend provides a PATCH endpoint (`PATCH /chats/{chat_id}/`) to update conversation titles, but the mobile app does not currently support renaming conversations.

## What Changes

- Add `renameConversation` API call to `LearnLensNetworkClient` via `PATCH $baseUrl/chats/{chat_id}/` with `{'title': title}`.
- Expose `renameConversation` in `LearnLensRepository`.
- Implement `renameConversation` in `GenericAiChatNotifier`:
  - Disallow renaming when active generation is in-flight for the chat.
  - Trim and sanitize title (collapse internal whitespace, cap at 80 characters).
  - Short-circuit without network call if the sanitized title matches the existing title.
  - Update in-memory `conversationHistory` and `currentTitle` on success.
- Support inline renaming of conversation items directly within `AiChatHistoryScreen`:
  - Add "Rename" action to the conversation 3-dot options menu.
  - Inline `EditableText` with design token styling (`design.colors.primary`), accessible semantics, and keyboard submit/escape handling.
  - Error message display if rename fails, with graceful cancellation on touch blur or escape.
- Header rename action opens the history drawer/sidebar directly so users can manage their conversation names in context without a redundant modal dialog.
- Add localized strings for rename actions, success status, and error states across `en`, `ar`, `ml`, and `ta`.
- Add comprehensive unit and widget tests.

## Capabilities

### Modified Capabilities
- `generic-ai-chat-controller`: Add conversation renaming lifecycle management, in-flight generation conflict prevention, and unchanged title short-circuiting.
- `generic-ai-chat-history`: Add rename action to conversation item options menu and support inline renaming with keyboard and touch accessibility.

## Impact

- Network layer: `packages/core/lib/network/learnlens_network_client.dart`
- Repository layer: `packages/core/lib/data/repositories/learnlens_repository.dart`
- State layer: `packages/core/lib/data/providers/generic_ai_chat_provider.dart`
- UI layer: `packages/core/lib/screens/ai_chat_history_screen.dart`, `packages/core/lib/screens/ai_screen.dart`, `packages/core/lib/widgets/ai_chat_header.dart`
- Localization: `packages/core/lib/l10n/app_{en,ar,ml,ta}.arb` and generated files
- Automated tests: `packages/core/test/`
