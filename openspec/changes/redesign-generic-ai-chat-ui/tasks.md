## 1. Shared Styling and Strings

- [x] 1.1 Add `aiChatCanvasColor` in `packages/core/lib/widgets/ai_chat_canvas.dart` and export it from `core.dart`.
- [x] 1.2 Add empty-state heading, suggestion labels, and starter prompts to all four ARB files; change `aiComposerPlaceholder` to `Message`; regenerate localizations.
- [x] 1.3 Add an optional `textStyle` to `AppMarkdown` that defaults to the current 14dp body.

## 2. Chat Widgets

- [x] 2.1 Restyle `AiChatHeader` to the canvas color with the muted `Back` label and menu icon.
- [x] 2.2 Restyle `AiComposer`: 48dp pill, `Message` placeholder, neutral send circle, optional external controller and focus node, optional leading new-chat action.
- [x] 2.3 Restyle `AiUserMessageBubble`: 75% max width, tightened top-end corner, timestamp below, neutral sending label.
- [x] 2.4 Restyle `AiAssistantCard`: 75% max width, tightened top-start corner, 16dp Markdown, copy action with timestamp below it, restyled generating and failure states.
- [x] 2.5 Add `AiSuggestionCard` in `packages/core/lib/widgets/ai_suggestion_card.dart` and export it.

## 3. Screens and Navigation

- [x] 3.1 Update `AiScreen`: canvas background, guided empty state with prefill, docked composer bar with divider and new-chat action, 16dp list padding, keyboard dismissal on opening history.
- [x] 3.2 Rebuild `AiChatHistoryScreen` as a scrim plus start-side drawer with title, close, `New Chat`, divided rows, and the existing loading, empty, error, and pagination states.
- [x] 3.3 Present `/ai/history` as a non-opaque overlay page in `packages/testpress/lib/navigation/routes/ai_routes.dart`.

## 4. Tests

- [x] 4.1 Update `ai_screen_test.dart` for the empty state, suggestion prefill, docked composer, new-chat action, and the new assistant footer layout.
- [x] 4.2 Update `ai_composer_test.dart` for the placeholder, external controller, and new-chat action.
- [x] 4.3 Add `ai_message_widgets_test.dart` covering bubble and card shape, width cap, and the excluded actions.
- [x] 4.4 Add `ai_chat_history_screen_test.dart` covering the drawer layout, selection, new chat, dismissal, and the empty and error states.

## 5. Review

- [x] 5.1 Analyze `packages/core` (lib and chat tests) and `packages/testpress` navigation.
- [x] 5.2 Compare the implementation against `info/svg/image1.png` to `image4.png` and refine discrepancies.
- [ ] 5.3 Run the chat widget tests (left to the requester) and archive the change.

Review notes: analysis is clean for `packages/core` and `packages/testpress/lib/navigation`. The empty, active, streaming, failure, history, dark, right-to-left, small-phone keyboard, and tablet states were rendered with a throwaway harness and compared against the reference images. The project test suite has not been run.

## 6. Review refinements

- [x] 6.1 Use design tokens for the layout-settle delay and background cursor color.
- [x] 6.2 Document inherited near-bottom streaming scroll behavior.
- [x] 6.3 Run the redesigned chat widget regression tests and record failures.

Review validation: the chat regression run reported 42 passing tests, seven history-drawer failures and a message-widget test-loading error. Screen and composer tests completed without failures. Full passing validation and archival (5.3) remain pending; no history or message-widget implementation was changed in this review.
