## Why

The Generic AI Chat screen is wired to LearnLens and streams answers, but its visuals predate the approved design. The reference screens in `info/svg/` (`image1.png` empty chat, `image2.png` active conversation, `image3.png`/`image4.png` history drawer) show a softer canvas, a guided empty state, asymmetric message bubbles, a docked composer with a new-chat action, and history as a side drawer. This change brings the existing UI in line with those references without touching the data layer.

## What Changes

- **Canvas and header**: Render the chat on a soft off-white canvas derived from design tokens, with the `Back` label and menu icon in the muted slate tone shown in the reference.
- **Empty state**: Replace the blank canvas with a centered "What can I help with?" heading, four suggestion cards (Explain concept, Solve problem, Practice questions, Study tips), and the composer directly below them. Tapping a card prefills the composer with a starter prompt and focuses it.
- **Message bubbles**: User bubbles and assistant cards use 16dp corners with one tightened corner (top-end for the user, top-start for the assistant), cap at 75% of the column width, and place the timestamp below the bubble. The assistant card keeps only the copy action; the timestamp sits on its own line under it.
- **Composer**: Pill input with a `Message` placeholder and a 32dp send circle that is neutral dark when active and faded when inactive. In an active conversation the composer is docked above a top divider with a leading circular `+` action that starts a new chat.
- **Streaming and errors**: Keep the generating indicator, send-failure retry, generation-failure retry, init banner, and quota banner, restyled to the same visual language.
- **Conversation history**: Present `/ai/history` as a start-side drawer over a dimmed chat (title, close, full-width `New Chat`, divided list of title and relative time) instead of a full page.
- **Out of scope by request**: No thumbs up/down, speaker, share, or more actions under the assistant card, and no subject chips in the history list.

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `generic-ai-chat-screen`: Empty state, bubble layout, assistant actions, composer, and history entry point change to match the reference.
- `generic-ai-chat-history`: History is presented as a dismissible drawer overlay.
- `ai-screen`: The direct chat interface opens on the guided empty state instead of a blank canvas.

## Impact

- `packages/core/lib/screens/ai_screen.dart`, `ai_chat_history_screen.dart`: Layout for the empty state, docked composer, and drawer presentation.
- `packages/core/lib/widgets/ai_chat_header.dart`, `ai_composer.dart`, `ai_user_message_bubble.dart`, `ai_assistant_card.dart`: Restyled to the reference.
- `packages/core/lib/widgets/ai_chat_canvas.dart`, `ai_suggestion_card.dart`: New shared canvas color helper and suggestion card.
- `packages/core/lib/l10n/*.arb` and generated localizations: New empty-state strings; composer placeholder becomes `Message`.
- `packages/testpress/lib/navigation/routes/ai_routes.dart`: `/ai/history` becomes a transparent overlay page.
- `packages/core/test/`: Updated screen and widget tests, new history drawer and message widget tests.
- No changes to `genericAiChatProvider`, `LearnLensRepository`, the network client, DTOs, session handling, institute gating, or the Web JSON request path.
