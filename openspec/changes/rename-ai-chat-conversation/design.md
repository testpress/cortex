## Context

The AI Chat interface in Cortex allows students to interact with LearnLens to ask questions, practice concepts, and review past discussions. Conversations are managed in Riverpod via `genericAiChatProvider` and displayed in the `AiChatHistoryScreen` drawer overlay. While conversation deletion was previously added, renaming conversations was not yet implemented on the client.

## Goals / Non-Goals

**Goals:**
- Provide a clean, accessible inline conversation rename flow in `AiChatHistoryScreen`.
- Support triggering rename from the screen header by opening the history drawer with that conversation immediately in inline rename mode.
- Ensure all design tokens (colors, typography, spacing, radius) are strictly resolved from context (`Design.of(context)`).
- Provide localized feedback and error handling with talkback/screen reader accessibility.
- Guard against redundant network calls and in-flight AI generation conflicts.

**Non-Goals:**
- Separate modal popup dialogs for renaming (renaming is performed in-place within the history drawer).
- Batch renaming of multiple conversations.

## Decisions

- **Inline editing in history drawer**: Rather than displaying modal alert dialogs, tapping "Rename" enters an inline editing state on the specific conversation row in the history drawer. This provides an intuitive, distraction-free editing experience aligned with modern mobile sidebar conventions.
- **Header Rename action opens history drawer directly in rename mode**: When the user selects "Rename" from the active chat header overflow menu, the app records `pendingRenameChatId` and opens the history drawer directly. When `AiChatHistoryScreen` initializes, it immediately enters inline edit mode on that active conversation, preselecting the text and requesting keyboard focus without asking the user to tap Rename a second time.
- **Short-circuit unchanged titles**: If a user submits a rename with the identical sanitized string, `GenericAiChat.renameConversation` returns `true` immediately without initiating an unnecessary HTTP `PATCH` call.
- **Design Tokens & Accessibility**: The inline `EditableText` uses `design.colors.primary` for cursor and selection highlighting, wrapped with semantic labels for accessibility, and action labels in popup menus use `ExcludeSemantics` to avoid duplicate announcements.

## Risks / Trade-offs

- **[Touch blur handling]** → In touch environments, tapping outside the inline field submits the rename. If an error occurs, blur must not infinitely loop retries, allowing graceful cancellation.
- **[Network latency during rename]** → In-memory state displays a loading indicator (`isSubmittingRename`) and disables duplicate submissions while `renameConversation` is in flight.
