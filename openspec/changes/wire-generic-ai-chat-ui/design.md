## Context

The LearnLens data and network infrastructure (`LearnLensRepository`, `LearnLensNetworkClient`, `LearnLensSessionManager`, DTOs) has been implemented and merged in `packages/core`. The visual layout of `AiScreen` was previously redesigned but currently relies on simulated in-memory state. We now need a robust Riverpod-driven state layer to connect `AiScreen` to the live LearnLens backend, supporting full conversation lifecycles, background polling, error recovery, and conversation switching.

## Goals / Non-Goals

**Goals:**
- Provide a robust Riverpod controller (`genericAiChatProvider`) managing live conversational state.
- Support seamless turn creation: starting new conversations (`/chats/`) and follow-ups (`/chats/<id>/messages/`).
- Implement optimistic user message rendering with client-side UUID request tracking.
- Handle long-running generations via periodic polling (2s interval) when `processing` state is returned.
- Wire up interactive error recovery: send error retry with preserved request ID, generation error retry, and 429 quota exhaustion handling.
- Provide a slide-over/bottom sheet conversation history drawer for listing and switching active chats.
- Maintain zero regressions and strict compliance with `Design.of(context)` tokens and accessibility primitives.

**Non-Goals:**
- Server-sent events (SSE) streaming routes (`/stream/`) — deferred to future enhancement; current implementation focuses on standard JSON responses with polling fallback.
- Rich attachment uploading (attachments remain disabled per backend session policy).
- Modifying course/video lesson subtabs in `packages/courses`.

## Decisions

### Decision 1: Riverpod `Notifier<GenericAiChatState>` Architecture
Implement `GenericAiChatNotifier` managing immutable `GenericAiChatState`.
- *Rationale*: Centralizes all state transitions (sending, in-flight, success, send error, generation error, 429 rate limit) outside of the widget tree, making the UI reactive, testable, and independent of Flutter widget lifecycle.
- *Alternatives considered*: Keeping local state in `_AiScreenState`. Rejected because conversation state would be wiped on tab switches or route transitions, and testing complex network flows would require cumbersome widget tests.

### Decision 2: Optimistic Turn Lifecycle & RFC 4122 v4 Request Preservation
When the user taps send:
1. Validate query length against `AiChatPolicyDto.maxMessageCharacters`.
2. Generate an RFC 4122 v4 UUID (`requestId`).
3. Optimistically prepend/append the user message to the UI with `isSending: true`.
4. Dispatch `startConversation` (if `currentChatId == null`) or `sendFollowUpMessage` (if `currentChatId != null`).
5. If the network call fails before server acceptance, mark `hasSendError: true` on that message while retaining its `requestId`. Tapping "Retry" resubmits the exact same request ID, ensuring backend idempotency without duplicate message creation.
- *Rationale*: Follows the strict idempotency requirements in the API specification.

### Decision 3: Background Status Polling for Pending Generations
If the API returns an accepted turn with `generation.status == 'processing'`:
1. Mark UI state as `isGenerating: true`.
2. Initiate a periodic timer (every 2 seconds, backoff up to 5s) calling `repository.getConversationStatus(chatId)`.
3. When the status reaches `completed`, fetch message history to reconcile the assistant answer and clear `isGenerating`.
4. When status reaches `failed`, display the generation error card with the server's `error_message`.
5. Ensure polling cancels immediately on screen dispose or manual navigation.
- *Rationale*: The backend generation limit is up to 150s. Polling status ensures UI reliably recovers even if the client temporarily loses connectivity or receives a provisional processing response.

### Decision 4: History Drawer & Conversation Switching
Build `AiChatHistorySheet` accessible from the header's menu icon:
- Fetches active conversations using `repository.listConversations()`.
- Supports cursor-based infinite scroll pagination.
- Allows switching active conversation: selecting a history item sets `currentChatId` and loads message history via `repository.getMessages(chatId)`.
- Provides a "New Chat" button resetting state to a clean canvas.
- *Rationale*: Matches the design spec without forcing complex full-screen page transitions.

### Decision 5: Dynamic Tenant Feature Flagging over Static `AppConfig` Build Flags
- **Context & Change**: Static compile-time build flags (`AppConfig.showAiTab` backed by `SHOW_AI_TAB` in `config/*.json`) have been removed. Visibility for the AI Chat tab is now strictly driven at runtime by remote tenant settings (`InstituteSettings.enableAiChatbot`).
- **Rationale**:
  1. **Dynamic Provisioning**: AI Chatbot access is a tenant-level capability provisioned on the backend. Hardcoding client build flags required separate app builds and store updates to toggle access per institute.
  2. **Single Universal Binary**: Driving visibility through `InstituteSettings` allows instant toggling and rollout of AI chat per institute without requiring app re-compilation or flavor proliferation.
  3. **Architectural Distinction**: While compile-time `AppConfig` flags remain the convention for structural app flavors (e.g., `SHOW_PROFILE_TAB`, `SHOW_EXAM_TAB`), AI features are licensed backend capabilities and intentionally governed by dynamic remote institute policy.


## Risks / Trade-offs

- [Risk] Polling timers could leak if screen is popped while generation is in-flight.
  -> *Mitigation*: Tie polling lifecycle to Riverpod notifier `ref.onDispose` and cancel active timers immediately.
- [Risk] Duplicate messages shown during pagination or turn reconciliation.
  -> *Mitigation*: Use `repository.prependMessages` with strict `message_id` deduplication.
- [Risk] 429 rate-limiting lockouts causing user confusion.
  -> *Mitigation*: Parse `retry_at` timestamp from `LearnLensException` and render a clear countdown banner disabling the composer until expiration.
