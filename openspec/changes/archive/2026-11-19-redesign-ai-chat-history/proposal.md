## Why

The current AI chat history drawer displays conversations in a flat, unsectioned list separated by line dividers, making it hard for users to quickly scan and locate conversations across timeframes. Restructuring the drawer into localized temporal sections ("Today", "Yesterday", "Previous 7 days", and distinct past months) and introducing clear active item states (matching the app's dark card styling) significantly improves conversation navigation and aligns the mobile experience with the web design.

## What Changes

- Group conversation history into chronological sections: Today, Yesterday, Previous 7 days, and past months.
- Automatically hide empty time sections.
- Redesign the drawer list layout:
  - Add subdued section headers.
  - Remove horizontal dividing lines between conversations for a cleaner list appearance.
  - Highlight the currently active conversation, or highlight "+ New chat" when starting a new session.
  - Update the "+ New chat" button with a compose icon and card styling matching the web view.
- Localize all section headers across supported languages.
- Update date boundaries automatically when the user returns to the app across midnight.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `ai-chat-history`: Enhance the chat session history requirement from a flat list to strongly-typed temporal sections (Today, Yesterday, Previous 7 days, Month/Year) and active selection states.

## Impact

- `packages/core`: AI chat history drawer UI, history sectioning logic, localization strings, and corresponding tests.
