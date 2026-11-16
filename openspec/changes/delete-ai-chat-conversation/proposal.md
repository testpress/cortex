## Why

Students need the ability to delete past AI chat conversations from their history drawer to maintain a tidy workspace and remove obsolete discussions. The LearnLens backend provides a dedicated endpoint to soft-delete conversations (`DELETE /api/v2/{org_uuid}/generic/chats/{chat_id}/`), but the Flutter application does not yet integrate this endpoint or provide a delete action in the history UI.

## What Changes

- Add `deleteConversation` network call to `LearnLensNetworkClient` invoking `DELETE $baseUrl/chats/{chat_id}/`.
- Expose `deleteConversation` in `LearnLensRepository`.
- Implement `deleteConversation` in `GenericAiChatNotifier`:
  - Guard against active generation conflicts (handling HTTP 409 `generation_in_progress`).
  - Remove the deleted conversation from the in-memory `state.conversations` list.
  - Reset the active chat to a clean empty state (`startNewChat()`) if the deleted conversation is currently active.
- Add an accessible delete action on each conversation item in `AiChatHistoryScreen` with a confirmation dialog.
- Add localized strings for delete confirmation and status notifications.
- Add unit and widget tests covering deletion success, active conversation reset, and in-flight generation conflict handling.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `generic-ai-chat-controller`: Add conversation deletion lifecycle management, in-flight generation conflict prevention, and active conversation reset.
- `generic-ai-chat-history`: Add delete action button per conversation item with confirmation dialog and list removal.

## Impact

- Network layer: `packages/core/lib/network/learnlens_network_client.dart`
- Repository layer: `packages/core/lib/data/repositories/learnlens_repository.dart`
- State layer: `packages/core/lib/data/providers/generic_ai_chat_provider.dart`
- UI layer: `packages/core/lib/screens/ai_chat_history_screen.dart`
- Localization: `packages/core/lib/l10n/app_{en,ar,ta,ml}.arb`
- Automated tests: `packages/core/test/network/learnlens_network_client_test.dart`, `packages/core/test/data/providers/generic_ai_chat_provider_test.dart`, `packages/core/test/screens/ai_chat_history_screen_test.dart`
