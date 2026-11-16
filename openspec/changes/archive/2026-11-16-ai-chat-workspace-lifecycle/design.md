## Context

The Cortex app provides an AI Chat workspace powered by LearnLens and Testpress. While the workspace UI, empty state, and history drawer exist, individual learner access needs to respect the `can_generate` policy returned by the session endpoint. Furthermore, if a student backgrounds the app while an answer is being generated, the app must re-synchronize canonical conversation state on resume without creating duplicate turns or losing context. Finally, when an assistant response is stopped, the retained partial answer must be presented with distinct non-error styling.

## Goals / Non-Goals

**Goals:**
- Respect learner-level access state: parse `can_generate` from `AiChatPolicyDto` and handle restricted student access state gracefully in `AiScreen`.
- Automatically synchronize conversation status and message history on application resumption (`AppLifecycleState.resumed`).
- Support stopped generation states in `AiGenerationDto`, `GenericAiChatMessage`, and `AiAssistantCard` with a subtle "Stopped" label and no error banner.
- Maintain full test coverage across widget and state transitions.

**Non-Goals:**
- Media attachment selection, image picker integration, or pre-upload compression (handled in a separate dedicated media change).
- Backend session generation alterations.

## Decisions

### Decision 1: Surface `can_generate` through `AiChatPolicyDto` and Rich Restriction Card
- **Context**: The Testpress session creation endpoint (`/api/v3/ai-chat/sessions/create/`) returns `policy.can_generate: bool`.
- **Choice**: Add `canGenerate` (default `true`) to `AiChatPolicyDto`. If `canGenerate == false`, `AiScreen` displays a dedicated access restriction card (`_AiRestrictedAccessCard`) with a lock icon, bold title ("AI chat not available"), descriptive explanation directing the student to contact their administrator, styled with a warm background tint and vertical accent bar, and disables the composer.
- **Alternative considered**: Removing the AI tab entirely when unauthenticated. *Rejected*: Sessions are acquired lazily on screen mount, so the tab must remain visible if the institute enables AI chatbot, and communicate restricted learner access in-context.

### Decision 2: Use `WidgetsBindingObserver` for Canonical State Re-sync
- **Context**: When the app is in the background, active SSE streams or HTTP connections may drop or finish remotely.
- **Choice**: `_AiScreenState` implements `WidgetsBindingObserver` and calls `syncCanonicalState()` in `didChangeAppLifecycleState(AppLifecycleState.resumed)`.
- **Implementation**: `syncCanonicalState` fetches `getConversationStatus` and `getMessages` for the active `currentChatId`, silently updating title, message list, and generation state.
- **Alternative considered**: Polling continuously while in background. *Rejected*: Violates battery/network efficiency and system lifecycle guidelines.

### Decision 3: Distinct Rendering for `stopped` Generation State
- **Context**: When an active generation was halted, the retained partial text is valid assistant content, not a failure.
- **Choice**: In `AiAssistantCard`, evaluate `isStopped`. When true, omit the "Try again" retry button and generation error banner, rendering the partial Markdown text with a subtle `l10n.aiStoppedResponse` ("Stopped") label.

## Risks / Trade-offs

- **[Risk] State flicker on resume**: Re-syncing messages on resume might jump the scroll position.
  - *Mitigation*: Only replace messages if the canonical items contain updates, preserving active scroll offsets.
- **[Risk] Network failure on resume**: Offline resumption could throw errors during canonical sync.
  - *Mitigation*: `syncCanonicalState` catches exceptions silently so the UI remains interactive with existing cached messages.
