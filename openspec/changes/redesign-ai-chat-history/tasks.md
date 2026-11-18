## 1. Data Models & Sectioning Logic

- [x] 1.1 Define `HistorySectionType` enum and `AiChatHistorySection` view-model in `packages/core/lib/data/models/ai_chat_history_section.dart`.
- [x] 1.2 Implement pure `buildHistorySections({required List<AiConversationDto> conversations, required DateTime now})` with DST-safe calendar midnight arithmetic and deterministic tie-breaking.
- [x] 1.3 Write comprehensive unit tests for `buildHistorySections` verifying today, yesterday, previous 7 days, month/year grouping, DST transitions, null `updatedAt`, and empty bucket exclusion.

## 2. Localization

- [x] 2.1 Add `aiHistoryToday`, `aiHistoryYesterday`, `aiHistoryPrevious7Days` keys to `packages/core/lib/l10n/app_en.arb`, `app_ar.arb`, `app_ta.arb`, and `app_ml.arb`.
- [x] 2.2 Re-generate or update Flutter localization files to expose new getters on `L10n`.

## 3. History Drawer UI Redesign

- [x] 3.1 Update "+ New chat" button in `AiChatHistoryScreen` with compose icon (`LucideIcons.squarePen`), active rounded surface card (`design.colors.surfaceVariant`) and black styling when `currentChatId == null`.
- [x] 3.2 Implement section header rendering with subtle typography, accessible semantics, and localized formatting.
- [x] 3.3 Update conversation list item rendering with rounded selection highlight (`design.colors.surfaceVariant`) when active and remove horizontal dividing lines.
- [x] 3.4 Add `WidgetsBindingObserver` in `AiChatHistoryScreen` to recalculate section boundaries on `AppLifecycleState.resumed`.
- [x] 3.5 Remove redundant relative timestamp subtitle from conversation history items in `AiChatHistoryScreen`.

## 4. Verification & Testing

- [x] 4.1 Update and expand `packages/core/test/screens/ai_chat_history_screen_test.dart` to verify sectioned rendering, selection states, and interactions.
- [x] 4.2 Run test suite across `packages/core` to ensure all tests pass without regressions.
