## 1. Localization & Semantic Labels

- [x] 1.1 Reuse existing localized strings (`aiStartNewChat`, `aiMoreActionsSemantic`) for header actions.

## 2. Header Component Redesign

- [x] 2.1 Refactor `AiChatHeader` to place the hamburger menu button on the leading left edge.
- [x] 2.2 Add single-line truncated title display beside the leading menu icon.
- [x] 2.3 Add trailing New Chat compose button (`LucideIcons.squarePen`) with 48×48dp touch target.
- [x] 2.4 Add trailing 3-dot overflow menu button (`LucideIcons.moreVertical`) with anchored popup option to delete active chat.
- [x] 2.5 Respect motion preferences in header overflow popup: smooth fade transition when enabled, zero duration when disabled.
- [x] 2.6 Remove unused `onBack` parameter from `AiChatHeader` and `AiScreen`.

## 3. Screen Integration

- [x] 3.1 Pass `state.currentTitle` to `AiChatHeader` in `AiScreen`.
- [x] 3.2 Wire `onNewChat` to call `startNewChat()` from `AiScreen`.
- [x] 3.3 Wire `onDelete` to trigger active conversation deletion with confirmation dialog in `AiScreen`.
- [x] 3.4 Move `confirmAndDeleteConversation` to `packages/core/lib/utils/ai_chat_actions.dart` and privatize `_warnIfAiGenerating`.
- [x] 3.5 Replace sentinel `AiConversationDto(chatId: '')` in `selectConversation` with `firstOrNull`.

## 4. Verification & Testing

- [x] 4.1 Update and expand `ai_chat_header_test.dart` for new button positions, title, and actions.
- [x] 4.2 Update `ai_screen_test.dart` to verify header integration and active conversation deletion.
- [x] 4.3 Run `flutter analyze packages/core` and full AI test suite to verify 0 regressions.
- [x] 4.4 Add tests in `ai_screen_test.dart` for delete failure path (toast shown, chat stays active) and in-flight generating guards.
