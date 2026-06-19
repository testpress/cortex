## Context

The exam player module needs a clearer user experience during the submission phase and a simpler analytics landing screen post-submission. The current landing page has excessive charts and details that should be hidden until requested via navigation.

## Goals / Non-Goals

**Goals:**
- Provide a blocking loader interface in the exam player when the status is `submitting` to prevent extra user inputs while requests are flushing.
- Consolidate the two buttons in `TestResultView` into a single button to simplify user options on completion.
- Refactor the `ReviewAnalyticsScreen` to hide the progress bar, section donut charts, and tables from the landing page.
- Add a new sub-route to display the detailed graphical and tabular reports when "Subject-wise Performance" is tapped.

**Non-Goals:**
- Fetching new backend data for the subject-wise details screen; we should reuse the same controller/provider logic or pass the payload.
- Redesigning the main `SubjectAnalyticsScreen` which displays global/course-level paginated analytics.

## Decisions

### 1. Handling the Submitting State in TestDetailScreen
- **Decision:** Check if `state.status == ExamAttemptStatus.submitting` and render a full-screen overlay (e.g., `ColoredBox` with a loading indicator and message) above the layout.
- **Rationale:** This blocks any gestures on the screen while `endExam` flushes pending answers and waits for the final attempt response.

### 2. Consolidating Buttons in TestResultView
- **Decision:** Remove the separate `onReviewAnswers` and `onViewAnalytics` callback parameters in `TestResultView` and replace them with a single callback parameter `onReview` (labeled "Review").
- **Rationale:** Clicking "Review" will navigate the user to `/exams/test/:id/review-analytics` (or `/study/test/:id/review-analytics`), where they can see the overall metrics and decide which details to explore.

### 3. Subject-wise Details Route and Screen
- **Decision:** Create a new sub-route `/exams/test/:id/review-analytics/subject-performance` (and `/study/test/:id/review-analytics/subject-performance`).
- **Rationale:** This sub-route will be backed by a new widget `ReviewSubjectPerformanceScreen` that accepts `ReviewRoutePayload` and renders the components (`OverallPerformanceCard`, `SectionDonutList`, `DonutLegend`, `SectionTable`) that were removed from `ReviewAnalyticsScreen`.

## Risks / Trade-offs

- **[Risk]** `ReviewRoutePayload` is required for calculation on the sub-route.
  - **Mitigation** If the user navigates directly or refreshes and the payload is missing, the sub-route will show a fallback/error view or return to the main analytics screen.
