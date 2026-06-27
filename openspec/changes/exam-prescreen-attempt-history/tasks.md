## 1. Component Implementation

- [x] 1.1 Create `ExamHistorySkeleton` widget to display shimmer table rows during loading state. (Removed in favor of `Skeletonizer` on the main widget)
- [x] 1.2 Create the `ExamHistoryTable` widget to render the list of completed `AttemptDto` models displaying Date, Score, Correct, Incorrect, and the Review action button.

## 2. Prescreen UI Integration

- [x] 2.1 Verify the removal of the early return block `if (lesson == null && lessonDetailAsync.isLoading)` in `exam_prescreen.dart` so that `isMetadataLoading` successfully triggers the skeleton UI layout.
- [x] 2.2 Watch `examAttemptsProvider(attemptsUrl)` within the `ExamPrescreen` build method, gracefully handling null `attemptsUrl`.
- [x] 2.3 Filter the fetched attempts to only include those where `state == 'Completed'`.
- [x] 2.4 Render the `ExamHistoryTable` below the metadata block or skeleton if `examAttemptsProvider` is actively loading.

## 3. Review Navigation

- [x] 3.1 Implement the `onReviewTapped` callback on the history table action button.
- [x] 3.2 Construct the `ReviewRoutePayload` populated strictly with the selected `AttemptDto` (and empty lists/maps for questions/answers) and push to the `/review-analytics` or `/review-answers` route.

## 4. Retake functionality

- [x] 4.1 Update `ExamPrescreenActionButton` to display "Retake Exam Online" if there are past completed attempts and no running attempts.
- [x] 4.2 Update `ExamRepository` attempt creation endpoints to accept `isPartial` flag and pass `is_partial: true` to the backend.
- [x] 4.3 Propagate `isPartial` flag through the route navigation and `TestDetailScreen` into the `ExamAttemptNotifier`.
