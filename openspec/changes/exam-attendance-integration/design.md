## Context

Before entering the stateful exam player, users must be shown a details summary, historical attempts overview, and standard testing instructions. This decouples the network data fetching and pre-exam consent from the main active timer loop.

## Goals / Non-Goals

**Goals:**
- Implement `ExamPrescreen`.
- Support robust routing and dynamic state extraction for `LessonDto`/`Lesson`.
- Leverage Riverpod family providers to load detail summaries and historical tables.

**Non-Goals:**
- Implement the active exam player sections and heartbeat timers.
- Implement `ExamInstructionsScreen` (not needed for now).

## Decisions

### Decision: Decoupled pre-exam routing
Updating `AppRouter` to treat `/study/test/:id` as an overview screen instead of dropping the user directly into an active exam player ensures users can review their progress first and select when to launch the player at `/player`.

### Decision: Type-safe router extra parsing
Using defensive type verification (`extra is LessonDto ? extra : extra is Lesson ? extra.toDto() : null`) ensures the app remains backwards compatible with legacy course mappers while transitioning to the new Core SDK models.

## Risks / Trade-offs

- **Risk**: Stale historical attempts showing up on return.
- **Mitigation**: Invalidate `examAttemptsProvider(attemptsUrl)` after pop actions to trigger dynamic data refreshes.
