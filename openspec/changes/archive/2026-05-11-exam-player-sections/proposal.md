## Why

To support section-aware exams with robust real-time state, we need a complete rewrite of `TestDetailScreen` and `ExamRepository`. Driving the player via a centralized `ExamAttemptState` stream ensures robust section tab-switching, optimistic answer state management, server heartbeat time synchronization, and countdown timer logic decoupled from local UI `setState`.

## What Changes

- **`ExamRepository` State Extensions:** Implement section-aware timer countdowns, optimistic answer state updates, server-side heartbeat time syncs, and section tab-switching methods.
- **`TestDetailScreen` Stateful Overhaul:** Consumes the centralized `examAttemptProvider` stream, removes local `_answers`/`_questions` states, adds section tab headers, and supports dynamic subject filtering.
- **Widgets and Subsystems Integration:** Update `option_card.dart`, `question_palette.dart`, `test_header.dart`, and `test_question_card.dart` to use core `QuestionDto` and `AnswerDto` types.

## Capabilities

### New Capabilities

### Modified Capabilities
- `exam-player`: Upgraded the active exam player to be stateful, section-aware, and dynamically synchronized with the server timer and section schemas.

## Impact

- Provides a resilient exam player experience with automatic server-time sync on heartbeat, protecting against page-reload state loss.
