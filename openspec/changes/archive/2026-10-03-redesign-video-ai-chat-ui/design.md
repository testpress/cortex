# Design

## Context

The video lesson AI chat widget (`ai_tab.dart`) and video lesson viewer (`video_lesson_viewer.dart`) require styling and visual updates to align with the design system.

## Goals / Non-Goals

**Goals:**
- Invert background and AI message card colors (white screen background, grey AI message card).
- Render matching 28×28 circular avatars for AI (left) and User (right).
- Capture and display 24hr creation timestamps (`HH:mm`) under chat messages.
- Style the composer with a focus-highlighted text field and dual-state filled send button with paper plane icon.
- Update the tab name to "Ask AI" and active tab indicator to a highlighted pill background.

**Non-Goals:**
- Changing backend API contracts or chat flow logic.
- Modifying other tabs' inner contents or functionalities.

## Decisions

- **Decision 1: Container & Card Colors**: Use `design.colors.card` (white) for the chat background and `design.colors.surface` (light grey) for AI response cards.
- **Decision 2: Avatars**: Render 28×28 circular avatars: neutral `surfaceVariant` with sparkles icon for AI on the left, and `accent2` with user icon for user messages on the right.
- **Decision 3: Timestamps**: Store fixed `DateTime` creation timestamp on `_ChatMessage` instantiation and render formatted in 24hr `HH:mm` at the start of each bubble.
- **Decision 4: Send Button & Focus Highlight**: Render a filled rounded button with `LucideIcons.send` in white, using `accent2` when active and 35% opacity when inactive, while highlighting the input box border on focus/dirty.
- **Decision 5: Tab Header & Indicator**: Update tab label to "Ask AI" (`videoLessonTabAiSupport`) and use `BoxDecoration` with `primaryContainer` for the active tab pill indicator.

## Risks / Trade-offs

- *[Tab Bar Width & Overflow]* → Ensure tab labels fit comfortably or scroll cleanly without clipping when highlighted background is applied.
