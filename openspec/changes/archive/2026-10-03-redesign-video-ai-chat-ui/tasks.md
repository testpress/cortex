# Tasks

## 1. Background & AI Message Colors

- [x] 1.1 Invert AI Chat screen background to white and AI message cards to light grey in `ai_tab.dart` and verify color contrast

## 2. Avatars & Timestamps

- [x] 2.1 Add circular user profile avatar to user messages and neutral sparkles avatar to AI messages in `ai_tab.dart`
- [x] 2.2 Store creation timestamp on `_ChatMessage` and display in 24hr format (`HH:mm`) under each bubble

## 3. Send Button & Input Focus Highlight

- [x] 3.1 Style send button with filled container and paper plane icon with active/inactive fill states in `ai_tab.dart`
- [x] 3.2 Add focus/dirty border highlight in `AppTextField` and `ai_tab.dart`

## 4. Tab Bar & Localization

- [x] 4.1 Update video lesson tab bar active tab indicator decoration in `video_lesson_viewer.dart` to a highlighted background style
- [x] 4.2 Update tab label to "Ask AI" (`videoLessonTabAiSupport`) across all localization files and regenerate code

## 5. Accessibility Review Fixes

- [x] 5.1 Remove semantic label from AI bubble container so AppMarkdown timestamp links stay reachable to screen readers
- [x] 5.2 Wrap inner `GestureDetector` on send button with `ExcludeSemantics` to prevent double tap handler in semantics tree
- [x] 5.3 Replace hardcoded English sender strings with localized ARB keys (`videoAiSenderAi`, `videoAiSenderYou`, `videoAiLoadingSemantic`, `videoAiChatMessageSemantic`)
- [x] 5.4 Extract send button magic values to named constants (`_sendButtonInnerSize`, `_sendButtonIconSize`, `_sendButtonDisabledAlpha`)
