## Context

Currently, the `TestDetailScreen` provides a score and option to retake or exit. There is no way for students to review which specific questions they got wrong without retaking the entire test. This change utilizes the `ReviewAnswerDetailScreen`, a paged interface for studying results one question at a time.

## Goals / Non-Goals

**Goals:**
- Provide a paged review of all questions after a test is completed.
- Display each question as a card with previous and next buttons for navigation.
- Support status-based filtering (All, Correct, Wrong, Unanswered).
- Display the detailed explanation block from Phase 1 directly on the question card.

**Non-Goals:**
- This screen is NOT for re-taking the test.
- This screen is NOT for deep analytics (that belongs to `lms-review-analytics`).
- No vertical scrollable list of all questions (this is a paged interface).

## Decisions

- **Screen Component**: Use `ReviewAnswerDetailScreen` in `packages/courses/lib/screens/review_answer/review_answer_detail_screen.dart` utilizing a paged layout.
- **Question Card Widget**: Build the question review interface to show the full question, options, correct answer, and explanation without requiring expand/collapse action.
- **Filter State Management**: Use standard state management within the `ReviewAnswerDetailScreen` for filter selection and UI updates, adjusting the available pages based on the filter.
- **Result Navigation**: In `TestDetailScreen`, the `_buildResultView` will be updated to include a "Review Answers" button that pushes the `ReviewAnswerDetailScreen`.
- **Palette Synergy**: Re-use `TestAttemptAnswer` data map from the test session to determine correctness and user selection in the review view.

## Risks / Trade-offs

- **State Persistence**: If the student exits the review, results might be lost if only held in memory.
  - *Mitigation*: For now, this is a post-test ephemeral review. Persistence is handled in later phases via database/drift.
