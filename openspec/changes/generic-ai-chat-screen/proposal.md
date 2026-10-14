# Proposal: Generic AI Chat Screen Redesign

## Why

The current AI screen (`AiScreen`) displays an outdated onboarding/mock dashboard with static cards, requiring an extra navigation step to start a chat. To deliver a seamless conversational AI experience, the AI tab needs to open directly into a clean, dedicated chat screen supporting real-time conversation flows, visual status transitions (sending, in-flight, success), and explicit error recovery states (send failure vs. generation failure).

## What Changes

- **Direct Chat Entry Point**: Replace the static mock dashboard in `packages/core/lib/screens/ai_screen.dart` with a dedicated, focused AI chat screen that loads directly when navigating to the AI tab.
- **Header Component**:
  - Left navigation button: `Back` arrow with label returning to previous screen/tab.
  - Right action button: Hamburger menu (`LucideIcons.menu`) to access conversation history.
- **Chat Canvas & Message Layout**:
  - **Empty Canvas**: Clean white canvas when no conversation history is active.
  - **User Message Bubble**: Right-aligned, soft-tinted bubble with a right-aligned timestamp (e.g., `14:36`).
  - **Send Error State**: Inline alert indicator (`Couldn't send message. Tap to retry`) directly below the user bubble with an active retry tap target.
  - **AI Assistant Response Card**: Left-aligned bordered card supporting rich Markdown rendering via `AppMarkdown`.
  - **AI Response Actions**: Action bar below the assistant card containing a Copy button, overflow menu (`...`), and timestamp.
  - **Generation Error State**: Placeholder card with `AI Assistant` label, inline error message (`Couldn't generate a response. Please try again.`), and a distinct action pill (`[🔄 Try again]`).
- **Bottom Composer**:
  - Pill-shaped input container with rounded full border and subtle stroke.
  - Multiline text field with placeholder `"Ask AI support"`.
  - Circular up-arrow send button (`↑`) reflecting disabled/active states based on text input.
- **Design System & Accessibility Compliance**:
  - Strictly use core primitives (`AppText`, `AppCard`, `AppScroll`) and context tokens (`Design.of(context)`).
  - Ensure 48dp minimum touch targets and appropriate semantics (`AppSemantics.button`, `AppSemantics.header`).

## Capabilities

### New Capabilities
- `generic-ai-chat-screen`: UI specification for the dedicated chat interface, including empty state, user message bubble, assistant response card, send error recovery, and generation failure handling.

### Modified Capabilities
- `ai-screen`: Updates the primary root AI tab requirement to present the dedicated conversational chat interface directly instead of an onboarding dashboard.

## Impact

- `packages/core/lib/screens/ai_screen.dart`: Complete redesign to house the dedicated chat interface.
- `packages/core/lib/widgets/ai_composer.dart`: Updated to the pill-shaped design with circular up-arrow action button.
- `packages/core/lib/screens/ai_chat_immersive_screen.dart`: Harmonized or refactored to share components.
