# Design: Generic AI Chat Screen Redesign

## Context

The existing `AiScreen` in `packages/core/lib/screens/ai_screen.dart` hosts a welcome banner, static mock cards, and an extra button to launch chat. Users need a direct, conversational experience immediately upon selecting the AI tab. The UI must match the provided reference designs while adhering strictly to `packages/core/docs/ai_context.md` (Neutral UI, runtime design tokens, accessibility constraints).

## Goals / Non-Goals

**Goals:**
- Replace the existing `AiScreen` with a dedicated conversation interface.
- Provide a clean header with Back and Hamburger menu actions.
- Support all message states:
  - Empty state (clean canvas).
  - User message bubble with right-aligned timestamp.
  - AI Assistant Markdown card with Copy, Overflow, and timestamp actions.
  - In-flight pending state.
  - Send error indicator (`Couldn't send message. Tap to retry`).
  - Generation error indicator (`Couldn't generate a response. Please try again.` with `[🔄 Try again]`).
- Implement pill-shaped bottom composer with circular up-arrow send button.
- Ensure 48dp minimum touch targets and WCAG accessibility standards.

**Non-Goals:**
- Modifying the bottom navigation bar or tab routing shell.
- Implementing complete API network integration or Riverpod caching services (handled in the subsequent logic change).

## Decisions

### Decision 1: Direct Transformation of `AiScreen`
Transform `packages/core/lib/screens/ai_screen.dart` directly into the unified chat screen.
- *Rationale*: Eliminates redundant routing indirection (`/ai` -> `/ai/chat`) and satisfies the requirement that selecting the AI tab immediately presents the chat experience.
- *Alternatives considered*: Keeping `AiScreen` as a router wrapper. Rejected to avoid dead code and unnecessary widget hierarchy nesting.

### Decision 2: Neutral Primitives & Design Tokens
Use only platform-neutral core primitives (`AppText`, `AppCard`, `AppScroll`) and context-derived styling (`Design.of(context)`).
- *Rationale*: Enforces architecture boundaries and ensures identical pixel-perfect rendering across iOS and Android without Material/Cupertino widget pollution.

### Decision 3: Decomposed Message Components
Break down the screen into modular, testable UI components:
- `_AiChatHeader`: Top bar with back button and menu button.
- `_AiUserMessageBubble`: User query container with timestamp and optional send error retry row.
- `_AiAssistantCard`: Left-aligned card rendering Markdown via `AppMarkdown`, action row, and generation error states.
- `AiComposer`: Pill-shaped input container with dynamic send button states.

## Risks / Trade-offs

- [Risk] Bottom composer overlapping virtual keyboard on mobile.
  -> *Mitigation*: Wrap bottom composer in `SafeArea(top: false)` and let Flutter's standard resize-to-avoid-bottom-insets manage keyboard avoidance smoothly.
- [Risk] Markdown rendering performance on long threads.
  -> *Mitigation*: Use `ListView.builder` / lazy rendering so offscreen assistant cards are not parsed or inflated prematurely.
