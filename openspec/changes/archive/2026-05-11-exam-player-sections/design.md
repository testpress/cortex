## Context

Decoupling the active countdown timer and attempt answers from local widget `setState` is essential to prevent state loss during UI re-builds or sheet resizing. Centralizing the state inside Riverpod family streams ensures complete robustness.

## Goals / Non-Goals

**Goals:**
- Rewrite `ExamRepository` to manage section states, optimistic answer syncing, and heartbeat timer countdowns.
- Overhaul `TestDetailScreen` to consume the `examAttemptProvider` stream state.
- Unify question mappers to use canonical `QuestionDto`/`AnswerDto` models.

**Non-Goals:**
- Implement answer review details and analytical panels.

## Decisions

### Decision: Centralized Attempt Stream
Store all active attempt state (including remaining time, selected answers, and sections) in `ExamAttemptState` and stream it via `examAttemptProvider`, making the active player widget completely stateless regarding state storage.

### Decision: Core DTO Type substitution
Fully substitute old local types like `TestQuestion` or `TestAttemptAnswer` with core SDK mappers `QuestionDto` and `AnswerDto` to ensure system-wide type safety.

## Risks / Trade-offs

- **Risk**: Redundant network calls during rapid option selection.
- **Mitigation**: Debounce optimistic state updates on local repository state before dispatching heartbeat payloads.
