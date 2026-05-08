## Context

To support stateful countdowns, subject filtering, and robust answer submission inside the test player, the exam data models and data sources must match the true Testpress v2.2.1 JSON schemas. This requires introducing `SectionDto` and refactoring `ExamDto`, `AttemptDto`, `AnswerDto`, and `QuestionDto` models along with adding new endpoint operations to the `DataSource` layers.

## Goals / Non-Goals

**Goals:**
- Implement `SectionDto` to manage multi-section exam structures.
- Update model parsing schemas in core package to correctly map v2.2.1 fields and nested objects.
- Add lifecycle operations for attempts and sections to both `HttpDataSource` and `MockDataSource`.

**Non-Goals:**
- Implement any UI or router logic inside the exams package.
- Modify course player components or local lesson list screens.

## Decisions

### Decision: Direct model mapping over translation layers
Instead of converting v2.2.1 API JSON structures to legacy internal models, we are updating the core DTO classes to natively parse the nested/structured Testpress v2.2.1 API shapes directly. This reduces translation overhead and ensures complete parity between local cache and remote states.

### Decision: Abstract new operations on DataSource interface
Adding lifecycle methods (`getAttempts`, `startAttempt`, `startSection`, `endSection`) to `DataSource` ensures both the HTTP client and mock datasets are fully capable of handling test-launcher and stateful countdown logic in the player.

## Risks / Trade-offs

- **Risk**: API endpoint path variations across test/live environments.
- **Mitigation**: Utilize configurable path parameters and dynamic response helpers inside `NetworkUtils`.
