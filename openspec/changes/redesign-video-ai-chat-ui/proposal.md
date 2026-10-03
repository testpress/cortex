# Proposal

## Why

The current AI chat interface and lesson tabs in video lessons have styling and presentation mismatches when compared to the updated design. Specifically, the background and AI bubble card colors are inverted, user messages lack an avatar icon on the right, messages lack timestamps, the send button and input focus styling need refinement, and the active tab indicator needs to use a highlighted background style rather than an underline.

## What Changes

- Invert background and AI response card colors: Set the main chat background to white and the AI response message box to light grey.
- Add user profile circular avatar icon to the right of user chat message bubbles.
- Add message creation timestamps in 24hr format (`HH:mm`) under both AI and user bubbles.
- Update the send button with filled container styling and white paper airplane icon (`LucideIcons.send`), with dynamic active/inactive fill and focus border highlight.
- Update the tab name from "AI Chat" to "Ask AI" across all localization files.
- Redesign the video lesson tab bar active indicator from an underline to a highlighted pill/block background for the active tab.

## Capabilities

### Modified Capabilities
- `video-ai-chat`: Update UI presentation for AI chat messages, chat background, input box, send button, timestamps, and user message avatar.
- `video-lesson-viewer`: Update lesson detail tab bar active tab highlight styling and tab title.

## Impact

- `packages/courses/lib/widgets/lesson_detail/ai_tab.dart`: Chat UI layout, bubble colors, send button, timestamps, and user avatar.
- `packages/courses/lib/widgets/lesson_detail/video_lesson_viewer.dart`: Tab bar active indicator decoration and styling.
- `packages/core/lib/l10n/`: Updated "Ask AI" translations across all languages.
- `packages/core/lib/widgets/app_text_field.dart`: Support focusNode and custom borderColor.
