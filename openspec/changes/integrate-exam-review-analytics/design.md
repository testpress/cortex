## Context

The monorepo contains scaffolded UI screens for both `ReviewAnalyticsScreen` (subject performance analytics breakdown) and `ReviewAnswerDetailScreen` (interactive question/answer solutions review with Ask Doubt, Comment, and Report dialogs). Currently, these screens generate mock in-memory data (`MockReviewAnalyticsFactory`) and rely on local active session states rather than fetching historical attempt metrics, subject analytics, or full solutions from the backend.

We need to connect these UI elements to actual Testpress API endpoints:
1. Subject Analytics API: `GET /api/v2.4/attempts/<attempt_id>/review/subjects/`
2. Solutions Review API: `GET /api/v2.2.1/attempts/<attempt_id>/review/` (paginated list of review items, translating v2.3 attempt URL paths).

## Goals / Non-Goals

**Goals:**
- Implement unified model/DTO definitions for `ReviewItemDto`, `ReviewQuestionDto`, `ReviewAnswerDto`, and `SubjectAnalyticsDto` in `packages/core`.
- Extend backend-facing components (`DataSource`, `HttpDataSource`, `MockDataSource`, `ExamRepository`) to query review data.
- Transition `ReviewAnalyticsScreen` to load subject breakdown from the real subject analytics endpoint.
- Transition `ReviewAnswerDetailScreen` to load, display, and filter actual paginated review questions, answers, and solutions from the server.
- Bind Ask Doubt, Add Comment, and Report Issue actions on review cards to actual server calls.

**Non-Goals:**
- Creating a new DB layer for local persistence of review data (fetching directly via network/repository cache is sufficient).
- Redesigning the visual interfaces of existing scaffolded components (we will retain the look-and-feel of existing metrics cards, donuts, tables, and dialogs).

## Decisions

### 1. Model Definitions
Introduce DTOs inside `packages/core/lib/data/models/review_models.dart`:
- `ReviewItemDto`: represents a question-level submission status. Includes `selectedAnswers` (List of selected answer IDs), `result` ("Correct", "Incorrect", "Unanswered"), `marks`, `duration`, `bookmarkId`, and the relational `ReviewQuestionDto`.
- `ReviewQuestionDto`: represents the solved question details. Includes `id`, `questionHtml`, `direction` (instructions passage HTML), `explanationHtml`, `type`, and `answers` (List of `ReviewAnswerDto`).
- `ReviewAnswerDto`: represents an option. Includes `id`, `textHtml`, `isCorrect` (Boolean).
- `SubjectAnalyticsDto`: represents topic-wise performance. Includes `id`, `name`, `total`, `correct`, `incorrect`, `unanswered`, `correctPercentage`.

### 2. URL Translation for Review Endpoint
When requesting review items, the native attempt endpoint returned is typically `/api/v2.3/attempts/<id>/`. We must translate this path by replacing `v2.3` with `v2.2.1` and appending `review/` to ensure parity with the standard SDK solutions endpoint.

### 3. API Integration & Routing
We will adapt the navigation routes in the shell:
- Tapping **Review Answers** or **Analytics** will trigger direct async fetching in the screen’s `initState` or using a stateful loading pattern, keeping performance smooth with appropriate loading indicators.

## Risks / Trade-offs

- **[Risk] Path Versioning Differences** ➔ Mitigated by executing path validation helper methods when constructing backend queries from `AttemptDto.reviewUrl`.
- **[Risk] High Payload Sizes on Large Exams** ➔ Mitigated by utilizing pagination mechanisms when retrieving the complete set of solutions.

### 4. Clean Architecture Refactoring (ReviewAnalyticsScreen)
To resolve the Single Responsibility Principle (SRP) violation on the screen and separate business/math logic from presentation:
- Introduce `ReviewAnalyticsState` to cleanly hold loading states, error states, and calculated overview and subject breakdowns.
- Create `ReviewAnalyticsController` (as an auto-dispose family Riverpod `Notifier`) that encapsulates all competitive marking calculations ($$\text{Correct} \times 4 - \text{Incorrect}$$), DTO score string parsing, and background repository fetches.
- Refactor `ReviewAnalyticsScreen` into a declarative, highly readable view that subscribes to the notifier, making the business calculations 100% testable in isolation.

### 5. Multi-Section Page View Synchronization (TestDetailScreen)
When section transitions occur:
- The active section index changes, swapping the entire questions list in state.
- The `PageView` builds with the new section's questions.
- To prevent displaying a stale page index from the previous section (which causes random question jumping or index out of bounds), we must inject an `examAttemptProvider` listener in `TestDetailScreen` that automatically resets `_currentQuestionIndex` and calls `_pageController.jumpToPage(0)` upon section index changes.
