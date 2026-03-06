## Context

Currently, the `TestDetailScreen` provides a score and option to retake or exit. There is no way for students to review which specific questions they got wrong without retaking the entire test. This change introduces the `ExamReviewScreen`, a list-based overview for studying results.

## Goals / Non-Goals

**Goals:**
- Provide a summary-style list of all questions after a test is completed.
- Support status-based filtering (All, Correct, Wrong, Unanswered).
- Use an accordion pattern to keep the list dense while allowing detailed review.
- Support the detailed explanation block from Phase 1.

**Non-Goals:**
- This screen is NOT for re-taking the test.
- This screen is NOT for deep analytics (that belongs to `lms-review-analytics`).
- No paged navigation (this is a vertical list, the paged review belongs to `lms-review-answer-detail`).

## Decisions

- **New Screen Component**: Create `ExamReviewScreen` in `packages/courses/lib/screens/exam_review_screen.dart`.
- **Question Accordion Widget**: Create `ReviewQuestionListItem` as a custom stateful widget rather than using `ExpansionTile` to ensure pixel-perfect alignment with the design's header icons and spacing.
- **Filter State Management**: Use standard `setState` within the `ExamReviewScreen` for filter selection and UI updates.
- **Result Navigation**: In `TestDetailScreen`, the `_buildResultView` will be updated to include a "Review Answers" button that pushes the `ExamReviewScreen`.
- **Palette Synergy**: Re-use `TestAttemptAnswer` data map from the test session to determine correctness and user selection in the review list.

## Risks / Trade-offs

- **Memory Usage** (low risk): Rendering a list of 50-100 questions with complex widgets. 
  - *Mitigation*: Use `ListView.builder` for the review list.
- **State Persistence**: If the student exits the review, results might be lost if only held in memory.
  - *Mitigation*: For now, this is a post-test ephemeral review. Persistence is handled in later phases via database/drift.
