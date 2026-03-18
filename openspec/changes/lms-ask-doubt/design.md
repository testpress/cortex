# Design: LMS Ask Doubt (AI Assistant)

## Context
The "Ask a Doubt" feature is a dedicated route within the AI Assistant package. It leverages the global design tokens and localization system so the screen feels native to the Cortex shell rather than like a one-off custom surface.

## Goals / Non-Goals

**Goals:**
- Provide a dedicated `AskDoubtScreen`.
- Implement a 2x2 grid of "Quick Suggestions" in the empty chat state.
- Create a floating Chat Input bar with an integrated attachment button, placeholder voice affordance, and prominent send action.
- Keep all user-facing labels, prompts, mock responses, and accessibility copy localized through `packages/core` l10n resources.
- Use existing Cortex semantic colors, typography, spacing, and surfaces instead of hardcoded values.

**Non-Goals:**
- Implementing the "History Drawer" fully if it requires complex backend storage changes in the first sprint (mock history is acceptable).
- Voice recording functionality (placeholder only).

## Decisions

### 1. Screen Architecture
- **Widget**: `AskDoubtScreen` (StatefulWidget or ConsumerWidget).
- **Layout**: `Column` containing a custom `AppHeader` (mimicking the minimal reference header), a scrollable `ListView` for messages, and a fixed `PreferredSize` or `BottomAppBar` equivalent for the input bar.
- **Shell Context**: Ask Doubt currently renders within the existing shell/navigation context reached from the AI Assistant hub rather than introducing a separate shell root.
- **Routing**: The `AskDoubtScreen` is pushed directly from `AIAssistantPage` using `AppRoute` instead of being registered as a root immersive route.
- **Separation**: Ask Doubt UI concerns should be split into focused widgets when a screen file grows beyond lightweight orchestration. The screen should coordinate state and composition, while drawer, menu, empty state, and message-list presentation live in dedicated files.

### 2. Message UI
- **Student Bubbles**: Right-aligned, using a soft neutral grey bubble that is darker than the page background but not near-black, with support for optional image headers.
- **AI Responses**: Left-aligned and rendered without a surrounding bubble/container so the assistant copy reads directly on the page, closer to the reference chat style.
- **Actions**: Bubble action affordances should inherit design-token icon colors and spacing.

### 3. Input System
- **State**: `TextEditingController` for the message.
- **Image Support**: The attachment action currently uses a mock image source and sends an image-backed placeholder message immediately instead of maintaining a local pre-send preview state.
- **Composer**: A single floating pill surface with small left/right/bottom inset so it visually floats above the page background.
- **Keyboard Behavior**: The floating composer must translate above the software keyboard on device instead of remaining fixed under it.
- **Landscape Handling**: In landscape or similarly short viewports, keyboard avoidance must keep the composer visible within the remaining viewport rather than lifting it beyond the visible content area.
- **Dynamic Placement**: Keyboard avoidance should be derived from the actual composer size and the currently visible viewport, not from a fixed estimated height.
- **Focus Behavior**: Repeated taps on the input surface should reliably reopen the software keyboard even after the keyboard was dismissed while focus remained on the field.
- **Tap Detection**: Keyboard reopening should not depend only on high-level gesture recognition for the editable region; the composer should respond reliably even when the text field consumes the gesture.
- **Keyboard Gap**: The floating offset above the keyboard should tighten while the keyboard is visible so the composer does not appear detached from it.
- **Portrait Keyboard Gap**: In portrait, the keyboard-visible gap should collapse to the minimum possible value so the composer feels attached to the keyboard rather than floating above it.
- **Orientation-Specific Gap**: Keyboard-visible spacing should be orientation-aware: near-flush in portrait, but allowed a small buffer in landscape so the composer remains comfortably legible in short viewports.
- **Portrait Inset Tuning**: Portrait keyboard placement may apply a small inset compensation so the composer aligns to the visible keyboard edge rather than to an over-reported system inset.
- **Portrait Tightness**: Portrait tuning should prefer the smallest comfortable gap above the keyboard and can be refined independently from landscape spacing.
- **Portrait Priority**: If portrait still feels visually detached, prefer reducing the gap further rather than reusing the landscape buffer.
- **Send Button**: A circular button within the input field that becomes visually dimmed when no input is present. Empty submissions are ignored by the send handler.
- **Copy**: Placeholder text, semantics labels, and action labels must come from shared localizations.
- **Suggestion Cards**: The four empty-state suggestion cards should keep a stable visual height across rows, even when labels wrap or text scaling is larger.
- **Suggestion Card Alignment**: Empty-state suggestion labels should read centered within each card rather than left-weighted.

### 4. Session Controls
- **History Drawer**: The history drawer should remain a dedicated surface with readable active/inactive states.
- **Chat Menu**: The per-session overflow menu must use a surface and text treatment that preserves readable contrast in both light and dark mode.
- **Pin State Labeling**: The session overflow menu should reflect the current pin state of the session, showing `Unpin` for already pinned chats.
- **Pinned Ordering**: Pinned chats should remain grouped at the top of history even when new unpinned chats are created afterward.

### 5. Animations
- **Slide-up**: Chat bubbles should enter with a subtle slide-up and fade-in.
- **Thinking Indicator**: A localized loading indicator accompanies AI response wait times.

## Risks / Trade-offs

- **Risk**: Keyboard covering the input bar on some Android devices.
- **Trade-off**: Using `AppScroll` vs a standard `ListView` - `ListView` is better for chat history with `reverse: false` and manual scrolling to bottom.
- **Risk**: The current attachment flow is still a mock and does not yet cover real file selection or pre-send preview behavior.
- **Trade-off**: Mock AI responses remain local placeholder content for now, but they should still be localized because they are visible product copy.
