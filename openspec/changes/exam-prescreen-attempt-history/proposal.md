## Why

Currently, users cannot view their past exam attempts or performance directly on the exam pre-screen. Displaying a historical table of completed attempts before starting a new exam provides immediate context on past performance and offers a quick way to review mistakes without navigating away from the core flow.

## What Changes

- Add a "Previous Attempts" table UI to the `ExamPrescreen` widget below the metadata section.
- The table will display: humanized Date (excluding time), Score, Correct, Incorrect, and a "Review" action button for completed attempts.
- Fetch attempt data on-demand via the existing `examAttemptsProvider(attemptsUrl)` without introducing new database schemas or offline persistence.
- Implement skeleton loading states while the attempt data is being fetched.
- Ensure the "Review" action routes seamlessly to the review analytics/answers screens by passing the `AttemptDto` in the `ReviewRoutePayload`, allowing those screens to lazily fetch the detailed questions and answers from the backend.

## Capabilities

### New Capabilities
- `exam-prescreen-attempt-history`: Displaying a table of past completed attempts with review actions on the exam pre-screen.

### Modified Capabilities
- None

## Impact

- `packages/exams/lib/screens/exam_prescreen.dart` (UI updates to show the history table and skeleton loader).
- `packages/exams/lib/providers/exam_providers.dart` (Utilization of the `examAttemptsProvider`).
- No impact on local DB storage or backward compatibility of existing attempt structures.
