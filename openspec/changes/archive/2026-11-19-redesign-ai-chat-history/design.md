## Context

The current `AiChatHistoryScreen` renders conversations as a flat list with standard line dividers. Users lack temporal orientation ("when did I have this conversation?") and visual clarity regarding which chat is currently active. Furthermore, on the web implementation, conversations are sectioned into "Today", "Yesterday", "Previous 7 days", and past months, with clean styling and active selection highlights. This design brings that cohesive, modern experience to the mobile drawer.

## Goals / Non-Goals

**Goals:**
- Provide a pure, deterministic sectioning engine (`buildHistorySections`) that classifies `AiConversationDto` into `today`, `yesterday`, `previous7Days`, and distinct `monthYear` buckets.
- Ensure calendar-based midnight calculation to avoid Daylight Saving Time (DST) or timezone skew.
- Render section headers with subdued typography and accessible header semantics.
- Style list items without dividing lines, adding rounded surface selection highlights (`design.colors.surfaceVariant`) for the active conversation.
- Highlight the "+ New chat" button with active card and black styling when `currentChatId == null`.
- Support full localization across English, Arabic, Tamil, and Malayalam.
- Re-calculate boundaries on app resume (`AppLifecycleState.resumed`).

**Non-Goals:**
- Altering the backend API, pagination cursor mechanism, or conversation persistence models.
- Changing conversation deletion logic or confirmation dialogs.

## Decisions

### Decision 1: Strongly-Typed Sectioning Enum vs. String Formatting
- **Choice**: Define an enum `HistorySectionType { today, yesterday, previous7Days, monthYear }` and a view model `AiChatHistorySection`.
- **Rationale**: Isolates date classification logic from localization and UI rendering. The UI resolves display titles via `L10n.of(context)` and `DateFormat.yMMMM` / `DateFormat.MMMM` without hardcoded strings in data transformations.

### Decision 2: Pure Transformer with Injectable Clock
- **Choice**: Implement `buildHistorySections({required List<AiConversationDto> conversations, required DateTime now})`.
- **Rationale**: Passing `now` explicitly makes unit tests 100% deterministic, enabling easy testing of midnight transitions, year-end rollovers, leap years, and empty bucket suppression without mocking system clocks.

### Decision 3: Calendar-Based Midnight Arithmetic
- **Choice**: Compute boundaries using `DateTime(now.year, now.month, now.day - offset)` rather than `.subtract(Duration(days: offset))`.
- **Rationale**: `Duration(days: offset)` subtracts fixed 24-hour increments, which fails during 23-hour or 25-hour Daylight Saving Time transition days. Calendar arithmetic natively accounts for local day boundaries.

### Decision 4: Visual Language & Theme Tokens
- **Choice**: Active selection uses dark card styling (`design.colors.surfaceVariant`) and black accents, matching the app's widget palette (no green).
- **Choice**: Remove hairline dividers between history rows in favor of clean vertical list spacing and rounded item tap targets.
- **Choice**: Use `LucideIcons.squarePen` for the "+ New chat" button to match standard compose iconography.

## Risks / Trade-offs

- **[Risk]** Heavy conversation history lists might slow down re-sectioning on build.
  - **Mitigation**: History is paginated (typically 20-50 items). Iterating and bucketing sorted items takes < 0.2ms, well within the 16ms frame budget.
- **[Risk]** App kept running across midnight displays stale section boundaries.
  - **Mitigation**: Observe `WidgetsBindingObserver.didChangeAppLifecycleState` to trigger state refresh on `AppLifecycleState.resumed`.
