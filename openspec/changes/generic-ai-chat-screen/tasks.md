## 1. Bottom Composer UI Updates

- [x] 1.1 Update `AiComposer` in `packages/core/lib/widgets/ai_composer.dart` to adopt the pill-shaped container layout with `Ask AI support` placeholder.
- [x] 1.2 Implement the circular up-arrow send button (`LucideIcons.arrowUp`) with disabled/active visual styling based on input text.
- [x] 1.3 Remove legacy image and camera attachment buttons from `AiComposer`.

## 2. Dedicated AI Chat Screen Layout & Components

- [x] 2.1 Refactor `AiScreen` in `packages/core/lib/screens/ai_screen.dart` to include header with `Back` navigation and `LucideIcons.menu` action button.
- [x] 2.2 Implement the clean canvas empty state when no messages are present.
- [x] 2.3 Implement the user message bubble with right-aligned timestamp and inline send error retry row (`Couldn't send message. Tap to retry`).
- [x] 2.4 Implement the assistant response card supporting Markdown text, action bar (Copy, More, timestamp), and generation error state (`Couldn't generate a response. Please try again.` with `[🔄 Try again]` button).
- [x] 2.5 Pin `AiComposer` to the bottom inside `SafeArea`.

## 3. Accessibility & Design System Compliance

- [x] 3.1 Ensure all interactive buttons have `AppSemantics.button` labels and minimum 48dp touch targets.
- [x] 3.2 Verify all styling derives strictly from `Design.of(context)` tokens with zero Material/Cupertino widget dependencies.

## 4. Verification & Widget Tests

- [x] 4.1 Add widget tests for `AiComposer` verifying pill container, placeholder, and adaptive send button.
- [x] 4.2 Add widget tests for `AiScreen` verifying empty state, user message, assistant card, and both error states.
- [x] 4.3 Run analyzer and widget tests to verify zero regressions.

## 5. Interactive Mock Data for Verification

- [x] 5.1 Define mock conversation data and response templates in `packages/core/lib/data/ai_chat_mock_data.dart` (keeping raw mock data out of `ai_screen.dart`).
- [x] 5.2 Wire interactive simulation in `AiScreen` using mock data (sending message, delayed markdown reply, auto-scroll).
- [x] 5.3 Support error simulation triggers ("error" / "fail") with actionable retry flows for send error and generation failure.
- [x] 5.4 Update widget tests to verify interactive mock flows and run analyzer.
