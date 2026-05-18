## Why

Starting an exam takes an excessive amount of time (5 to 10 seconds) because all pages of questions are currently fetched sequentially, causing multiple round-trips to the server. Furthermore, the exam heartbeat sync timer continues to run in the background after the user exits the exam, causing resource drain. Finally, every individual option click or interaction immediately triggers a blocking network API call, leading to lagging UI and excessive/redundant server requests.

## What Changes

- **Parallelized Question Loading**: Optimize question fetching by executing page requests concurrently rather than sequentially after fetching the first page.
- **Heartbeat & Countdown Disposal**: Properly stop and cancel the heartbeat timer and the countdown timer when the exam session is exited or reset.
- **Debounced Answer Submissions**: Implement a debouncer for answer submissions in the repository to prevent excessive API calls on rapid option toggling and interactions, while ensuring pending changes are flushed when ending or exiting the exam.

## Capabilities

### New Capabilities
<!-- None needed as we are modifying existing capabilities and behavior -->

### Modified Capabilities
- `exam-lifecycle-operations`: Stop heartbeat/countdown timers on reset or exit.
- `exam-player-sections`: Debounce answer submissions during exam taking and parallelize initial question fetching.

## Impact

- `HttpDataSource` in `packages/core`: `getQuestions` will be updated to fetch additional pages in parallel.
- `ExamRepository` in `packages/exams`:
  - `reset` and `dispose` methods will cancel heartbeat and countdown timers.
  - `submitAnswer` will debounce network calls per question using a 1-second delay, with a flushing mechanism on exam completion/exiting.
- `ExamAttempt` notifier in `packages/exams`:
  - Call `reset()` on the repository when the notifier is disposed.
- `TestDetailScreen` in `packages/exams`:
  - Ensure the repository state is reset when exiting or when the screen is disposed.
