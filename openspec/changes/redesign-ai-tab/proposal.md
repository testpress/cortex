## Why

The current AI screen displays placeholder greetings, quick action cards (such as "Ask Doubt"), and recent help sections that are outdated. They need to be replaced with an interactive mock AI study companion chatbot experience to support a mock UI redesign experiment.

## What Changes

- **AiScreen Revamp:** Clean up the UI of `AiScreen` by removing the greeting, quick actions card, and recent help list. Replace them with a welcome section prompting users to start a new chat, and a "Recent chats" list linking to past sessions.
- **Immersive Chat Screen:** Create a new `AiChatImmersiveScreen` providing a full conversational mock AI chat interface, incorporating a typing animation, typewriter message generation, and auto-scroll behaviors.
- **Chat History Screen:** Create `AiChatHistoryScreen` to display a scrollable list of all past mock chat sessions with humanized timestamps.
- **AI Composer Widget:** Add a reusable `AiComposer` widget with text input and media attachment buttons.
- **Rich Markdown Styling:** Enhance `AppMarkdown` to support rich text formatting (custom blockquotes, inline/block code, table styles) for rendered AI responses.
- **Mock Data Layer:** Establish standard structures (`AiChatMessage`, `AiChatSession`) and lists of pre-populated mock chat sessions in `ai_chat_mock_data.dart`.
- **Navigation Integration:** Update `AiRoutes` to register child routes (`/ai/chat`, `/ai/history`) and change the tab navigation icon to `LucideIcons.bot`.
- **Localization cleanup:** Clean up outdated localization entries associated with the old AI screen from `app_en.arb` (and other locale arb files).

## Capabilities

### New Capabilities

- `ai-immersive-chat`: Provides a full conversational chat interface with mock AI responses and typing indicators.
- `ai-chat-history`: Displays a list of recent and archived chat sessions with formatted timestamps.
- `ai-composer`: A dedicated input widget for typing messages and triggering actions.

### Modified Capabilities

- `ai-screen`: Revamped root screen focusing on onboarding and navigation to immersive experiences.
- `app-markdown`: Enriched styling support for markdown elements.
- `navigation`: Added child routes for chat and history screens.

## Impact

- **UI Screens & Widgets:**
  - Modified `packages/core/lib/screens/ai_screen.dart` (revamped welcome/history UI).
  - Created `packages/core/lib/screens/ai_chat_immersive_screen.dart` (immersive chat UI).
  - Created `packages/core/lib/screens/ai_chat_history_screen.dart` (chat history UI).
  - Created `packages/core/lib/widgets/ai_composer.dart` (composer input).
  - Modified `packages/core/lib/widgets/app_markdown.dart` (improved markdown rendering).
- **Data Layer:**
  - Created `packages/core/lib/data/ai_chat_mock_data.dart` (mock chat sessions and model definitions).
- **Navigation Router:**
  - Modified `packages/testpress/lib/navigation/routes/ai_routes.dart` (nested chat/history subroutes).
  - Modified `packages/testpress/lib/navigation/app_router.dart` (AI tab icon update to bot icon).
- **Localization:**
  - Modified `packages/core/lib/l10n/app_en.arb` (and other locale arb files) to remove outdated keys and prepare for new strings.
