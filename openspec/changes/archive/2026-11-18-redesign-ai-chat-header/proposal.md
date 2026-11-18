## Why

The design for the AI chat header has been updated. The updated design places the history menu icon on the leading edge alongside the active conversation title, and adds trailing actions for starting a new chat and accessing conversation options (including deleting the conversation). This change updates `AiChatHeader` and `AiScreen` to align with the updated design.

## What Changes

- **Leading Navigation**: Move the history menu toggle (`LucideIcons.menu`) to the leading edge of the header.
- **Conversation Title**: Display the active conversation title beside the menu icon, with single-line truncation and fallback to the default AI chat label.
- **New Chat Action**: Add a compose button (`LucideIcons.squarePen`) on the trailing edge to reset the canvas and start a new chat session.
- **Conversation Options**: Add a 3-dot overflow menu (`LucideIcons.moreVertical`) on the trailing edge with an option to delete the active conversation.
- **Accessibility**: Maintain standard 48×48dp touch targets (WCAG 2.5.5) and localized semantic labels for all header actions.

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `generic-ai-chat-screen`: Update header requirements to reflect the updated layout (leading history menu, active title display, trailing new chat and overflow actions).
- `ai-screen`: Wire the active conversation title and header actions to the chat controller.

## Impact

- `packages/core/lib/widgets/ai_chat_header.dart`: Updated layout, title display, and action buttons.
- `packages/core/lib/screens/ai_screen.dart`: State wiring for active title, new chat, and conversation deletion.
- `packages/core/lib/l10n/*.arb` and generated files: Localized strings for header actions and semantics.
- `packages/core/test/widgets/ai_chat_header_test.dart`, `packages/core/test/screens/ai_screen_test.dart`: Updated test suites.
