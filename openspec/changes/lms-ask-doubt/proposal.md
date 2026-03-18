# Proposal: LMS Ask Doubt (AI Assistant)

## Context
The AI Assistant hub serves as the central location for personalized student support. One of the core pillars of this experience is the ability for students to quickly "Ask a Doubt" and receive immediate, context-aware assistance.

## Goals
- **Seamless Entry**: Trigger the doubt workflow from the AI Assistant landing page.
- **Dedicated Chat Route**: Provide a focused Ask Doubt chat environment for exploring doubts.
- **Attachment Placeholder**: Support a lightweight attachment affordance backed by mock image message behavior in the first sprint.
- **Quick Guidance**: Offer suggestion chips (e.g., "Explain Concept", "Solve Problem") to reduce friction for new users.

## What Changes
1.  **AIAssistant Navigation**: Update `AIAssistantPage` to navigate to the new `AskDoubtScreen`.
2.  **New AskDoubtScreen**: Create a dedicated chat interface in `packages/ai_assistant` that is pushed from the AI Assistant hub.
3.  **Chat UI System**: Implement specialized message bubbles for Student and AI roles, incorporating the current premium light-surface styling.
4.  **Integrated Input Bar**: A sophisticated input system supporting text, a mock attachment action, and voice (optional placeholder).
5.  **History Access**: A slide-out drawer or similar mechanism to access past doubts (as seen in reference).

## Capabilities

### New Capabilities
- `ai-ask-doubt`: A full-featured chat environment for students to interact with the AI study assistant.

### Modified Capabilities
- `ai-assistant-hub`: Enhanced to support navigation and state persistence for active doubt sessions.

## Impact
- `packages/ai_assistant`: Core feature implementation (Screens, Widgets, Providers).
- `packages/core`: Utilization of `AppRoute`, `AppHeader`, and refined `AppText` for chat bubbles.
- `packages/testpress`: Integration of the new route within the main shell.
