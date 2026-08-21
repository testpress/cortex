## 1. Setup and Routing

- [x] 1.1 Add the `ai_bot.png` asset to the app assets directory.
- [x] 1.2 Update `packages/testpress/lib/navigation/routes/ai_routes.dart` to add nested routes for `chat` (`AiChatImmersiveScreen`) and `history` (`AiChatHistoryScreen`).
- [x] 1.3 Update `packages/testpress/lib/navigation/app_router.dart` to change the AI tab icon to `LucideIcons.bot`.
- [x] 1.4 Export the new screens and widgets in `packages/core/lib/core.dart`.

## 2. Mock Data Layer

- [x] 2.1 Create `packages/core/lib/data/ai_chat_mock_data.dart` containing model definitions for `AiChatMessage` and `AiChatSession`, along with a list of pre-populated sessions.

## 3. UI Redesign Implementation & Screen Fixes

- [x] 3.1 Implement the welcome layout, history card, and "Start new chat" action in `packages/core/lib/screens/ai_screen.dart`.
- [x] 3.2 Refactor `packages/core/lib/screens/ai_screen.dart` to use localized strings and wrap interactive text button targets in `AppSemantics.button()`, ensuring compliance with WCAG 2.5.5 touch target size (48x48dp).
- [x] 3.3 Create the list-based chat history UI in `packages/core/lib/screens/ai_chat_history_screen.dart`.
- [x] 3.4 Implement accessibility semantics (`AppSemantics.scrollableList` and `AppSemantics.button`) and localization in `packages/core/lib/screens/ai_chat_history_screen.dart`.
- [x] 3.5 Create the conversation view with simulated typewriter responses in `packages/core/lib/screens/ai_chat_immersive_screen.dart`.
- [x] 3.6 Implement design motion tokens, history button semantics, motion preference checks, and `!mounted` guards in `packages/core/lib/screens/ai_chat_immersive_screen.dart`.

## 4. UI Composer & Markdown Polish

- [x] 4.1 Create the composer input text and attachment triggers layout in `packages/core/lib/widgets/ai_composer.dart`.
- [x] 4.2 Implement the Send button in `packages/core/lib/widgets/ai_composer.dart` using `AppIconButton` to meet the WCAG 48x48dp touch target requirement.
- [x] 4.3 Refactor `packages/core/lib/widgets/app_markdown.dart` to support rich layout styling using the design token parameters.

## 5. Localization Setup

- [x] 5.1 Add all user-visible English strings (e.g. "Your AI study companion", "Start new chat", "Recent chats", "View All", "New Chat", "How can I help you today?", "Ask anything...", and attachment labels) to `packages/core/lib/l10n/app_en.arb` and remove unused legacy keys.
- [x] 5.2 Re-generate localized helper files using the localization code generator script or build command.
