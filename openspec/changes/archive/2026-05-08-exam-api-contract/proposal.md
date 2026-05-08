## Why

To support section-aware test playing, countdowns, and real-time answer submissions, we need to align our core exam DTOs and DataSources with the real Testpress API v2.2.1. Currently, sections are missing, MCQ/MCA fields are not parsed properly, and the DataSource interface is missing critical attempt and section-lifecycle methods.

## What Changes

- Add a new `SectionDto` for exam sections support.
- Update `ExamDto`, `AttemptDto`, `AnswerDto`, and `QuestionDto` to align with v2.2.1 JSON shapes (supporting nested question structures, single/multiple select mapping, score fields, etc.).
- Add attempt and section lifecycle methods (`getAttempts`, `startAttempt`, `startSection`, `endSection`) to `DataSource` and implement them in `HttpDataSource` and `MockDataSource`.
- Add the `examDetail` endpoint in `ApiEndpoints`.
- Add a helper `performDynamicNetworkRequest` inside `NetworkUtils` to parse dynamic payloads smoothly.

## Capabilities

### New Capabilities
- `exam-sections-api`: Support parsing exam sections with orders, instructions, and durations from API endpoints.
- `exam-lifecycle-operations`: Support fetching, starting, and ending exam attempts and section-specific periods via network operations.

### Modified Capabilities

## Impact

- `packages/core`: Adding models, updating endpoints, updating HTTP/Mock data sources, and dependencies.
