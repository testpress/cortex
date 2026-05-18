## Context

The exam player features several performance and lifecycle issues:
1. **Slow Initial Load**: Chained, sequential network requests are made for each page of questions.
2. **Timer Leakage**: Background timers (countdown and heartbeat) continue running after exiting the exam screen.
3. **Excessive Network Traffic**: Every single option tap or unselection immediately triggers an HTTP request.

## Goals / Non-Goals

**Goals:**
- Perform paginated question fetching concurrently in parallel (after page 1) to significantly improve loading speed.
- Safely dispose of and cancel the heartbeat timer and countdown timer when exiting/resetting the exam.
- Debounce option selection/marking API calls per question, while still updating the UI state optimistically.
- Flush all pending debounced API calls when the exam is submitted or exited.

**Non-Goals:**
- Changing backend response schemas or endpoints.
- Rewriting the offline caching layer or other UI components.

## Decisions

### Decision 1: Parallelize Paginated Loading in HttpDataSource
We will modify `getQuestions(questionsUrl)` in `HttpDataSource`:
- Request page 1 sequentially.
- Extract `count` and calculated `perPage` from page 1.
- Calculate `totalPages = (count / perPage).ceil()`.
- If `totalPages > 1`, generate the URIs for pages 2 to `totalPages` and fire them in parallel using `Future.wait`.
- Combine page 1 results and the concurrent results.
- **Alternative considered**: Fetching pages in chunks of N. Since the safety break is 50 pages and typically exams have <= 5-10 pages, concurrent loading of all remaining pages is safe and faster.

### Decision 2: Debounced Answer Submissions in ExamRepository
We will implement debouncing within `ExamRepository` using a mapping of timers:
```dart
final Map<String, Timer> _submitTimers = {};
final Map<String, AnswerDto> _pendingAnswers = {};
```
- When `submitAnswer(answerUrl, answer)` is called:
  - Immediately update `_currentState.answers` and emit the new state (optimistic update).
  - Cancel any active `Timer` for `answer.questionId`.
  - Store the latest answer in `_pendingAnswers[answer.questionId] = answer`.
  - Create a new `Timer(const Duration(seconds: 1), ...)` to perform the actual HTTP request.
- When the timer executes, perform the HTTP PUT call. If it fails, perform the standard rollback.
- Add a synchronous `_flushPendingAnswers()` helper to immediately trigger all pending API calls for any active timers when ending the exam (`endExam`), resetting (`reset`), or disposing (`dispose`).

### Decision 3: Proper Timer Cleanup on Exit and Reset
- Update `ExamRepository.reset()` to call `stopHeartbeat()`, `stopCountdown()`, and cancel all active debouncing timers.
- In `_TestDetailScreenState.dispose()`, call `ref.read(examAttemptProvider.notifier).reset()` to ensure that when exiting/leaving the screen, all timers are cleared and stopped.

## Risks / Trade-offs

- **[Risk]** User leaves screen or ends exam before the 1-second debounce completes, potentially losing the last selection.
  - **Mitigation** The `reset()` and `endExam()` methods will synchronously flush any pending debounced submissions before completing.
