## 1. Network Layer Performance Optimization

- [x] 1.1 Update `HttpDataSource.getQuestions` to fetch remaining paginated question pages concurrently using `Future.wait` after the first page is fetched.

## 2. Exam Attempt Repository & Debouncer Logic

- [x] 2.1 Add debouncer variables and a `_flushPendingAnswers` helper to `ExamRepository` to manage question-level submission debouncing.
- [x] 2.2 Update `ExamRepository.submitAnswer` to optimistically emit local state updates immediately, while debouncing the network call by 1 second.
- [x] 2.3 Update `ExamRepository.endExam` to immediately flush all pending debounced answers before finishing the submission.
- [x] 2.4 Update `ExamRepository.reset` to flush pending answers, cancel any active debouncing timers, and properly call `stopHeartbeat()` and `stopCountdown()`.
- [x] 2.5 Update `ExamRepository.dispose` to perform the same complete timer and pending answer cleanup.

## 3. UI and State Management Integration

- [x] 3.1 Wrap `TestDetailScreen` in `PopScope` to call `ref.read(examAttemptProvider.notifier).reset()`, ensuring that exiting the exam screen cleanly stops all timers without throwing a StateError.
