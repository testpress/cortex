## Why

When a user submits/ends an exam, the app correctly updates the local cache to set the paused attempts count to 0, which immediately displays the "Start" button on the exam pre-screen. However, when the app is restarted (e.g. closed and reopened), the in-memory timestamp (`_lastLocalPausedUpdate`) guarding against stale network responses is lost. Consequently, the background fetch (SWR revalidation) receives a stale CDN-cached response from the server that still contains `paused_attempts_count = 1`, and overwrites the local cache, causing the button to change back to "Resume".

## What Changes

- We will persist the last local paused update timestamp across app restarts (e.g., in `SharedPreferences` or database).
- We will update the `revalidate` method in `ExamDetail` to load and check this persisted timestamp instead of a transient in-memory field.
- If the persisted timestamp is within the 5-minute threshold, the background fetch will ignore the server's stale `paused_attempts_count` and preserve the local value (0 or updated count).
- In `ExamRepository.endExam`, we will check if the attempt has sections and if the active section's state is `'Running'`. If so, we will end the active section on the server by invoking `_dataSource.endSection(currentSection.endUrl)` before calling `_dataSource.endExam(endUrl)`. This ensures that the overall attempt correctly transitions to `"Completed"` status on the server.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `exam-attendance-flow`: Refine the SWR caching strategy on the exam details pre-screen so that the timestamp of the last local update to the paused attempts count is persisted across app restarts, preventing stale background API fetches from overwriting user actions (like submitting/ending an exam) for up to 5 minutes.

## Impact

- `packages/exams/lib/providers/exam_providers.dart`: Modify `ExamDetail` to load and store the last local update timestamp persistently.
- `packages/core/lib/data/db/`: (Optional, if database is chosen for persistence) or using `SharedPreferences`/settings provider. Let's see what shared preferences or settings utilities are available in `packages/core` to decide the best storage option.
