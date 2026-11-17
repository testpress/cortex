## Context

The design for the AI chat header has been updated. The previous layout featured a textual Back button and a trailing menu icon. The updated design moves the history menu to the leading position, displays the active conversation title, and adds trailing controls for starting a new chat and accessing conversation options (such as deleting the conversation).

This document outlines the technical changes needed across `AiChatHeader` and `AiScreen` to reflect this updated design.

## Goals / Non-Goals

**Goals:**
- Update `AiChatHeader` to match the updated header layout using design tokens.
- Display the active conversation title with single-line truncation.
- Wire the New Chat button to reset the chat session via `startNewChat()`.
- Wire the 3-dot overflow menu to trigger conversation deletion with confirmation.
- Adhere strictly to WCAG 2.5.5 (48×48dp touch targets) and neutral UI guidelines (zero raw Material widgets).

**Non-Goals:**
- In-place conversation renaming (deferred until backend renaming API integration).
- Tablet/desktop split-view responsive rail transformations (managed under a separate responsive layout milestone).

## Decisions

### Decision 1: `AiChatHeader` parameter signature
The updated header requires callbacks for each discrete user action:
- `onMenu`: Invoked when tapping the leading hamburger button.
- `title`: Optional/nullable title displayed next to the menu icon.
- `onNewChat`: Optional callback when tapping the compose button.
- `onDelete`: Optional callback when selecting "Delete" from the overflow menu.

*Rationale*: Keeping the header purely presentational maintains clean separation of concerns and allows simple unit and widget testing.

### Decision 2: 3-Dot Overflow Menu via Anchored Popup
The 3-dot menu opens an anchored popup menu positioned using `CompositedTransformFollower` and `LayerLink`, identical to the pattern used in `AiChatHistoryScreen`.
- *Rationale*: Consistency across the app for dropdown option sheets without introducing heavy third-party dropdown packages or raw Material `PopupMenuButton`.

### Decision 3: Active Conversation Deletion Flow
When "Delete chat" is selected from the header's 3-dot menu:
1. `showConfirmationDialog` is displayed asking the learner to confirm deletion.
2. Upon confirmation, `genericAiChatProvider.notifier.deleteConversation(chatId)` is called.
3. Since the active chat is being deleted, `deleteConversation` automatically resets the canvas via `startNewChat()`.
4. A toast confirmation (`aiConversationDeleted`) is shown to the user.

*Rationale*: Reuses the hardened deletion logic already built and verified in the data layer.

## Risks / Trade-offs

- **[Risk]** Long conversation titles might crowd the trailing action buttons on narrow mobile screens (e.g. 320dp width). → **Mitigation**: Title is wrapped in `Expanded` with `TextOverflow.ellipsis` and `maxLines: 1`. Trailing buttons have fixed widths.
- **[Risk]** Learner taps Delete while AI is actively generating. → **Mitigation**: Delete action checks `hasActiveGeneration(chatId)` and displays `aiCannotDeleteWhileGenerating` toast if in flight.
