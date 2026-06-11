# Tasks: exam-mode-selection-dialog

## 1. Spec Alignment

- [x] 1.1 Confirm the change scope matches the current exam prescreen start flow and quiz-capable metadata behavior.
- [x] 1.2 Verify the dialog behavior does not overlap with existing pause/resume or submission dialogs.
- [x] 1.3 Confirm quiz mode uses the same exam backend contract as regular mode and does not require new quiz-only endpoints.
- [x] 1.4 Confirm the quiz question flow requires explicit `Check` and `Continue` actions before moving between questions.
- [x] 1.5 Confirm quiz mode does not expose a `Try Again` action and instead uses the continue flow after incorrect review.

## 2. UX Definition

- [x] 2.1 Define the mode-selection dialog layout, titles, button labels, and cancel behavior in terms of existing Cortex UI patterns.
- [x] 2.2 Define the visual state for both available choices so the dialog remains consistent with the app design system.

## 3. Flow Contract

- [x] 3.1 Document how quiz eligibility is detected from exam metadata.
- [x] 3.2 Document how the selected mode is carried through the active attempt session.
- [x] 3.3 Document how resumed attempts bypass the dialog and restore the prior mode.
- [x] 3.4 Document which existing attempt/question/submission APIs remain shared across regular and quiz mode.
- [x] 3.5 Document that option selection alone does not reveal the correct answer in quiz mode.
- [x] 3.6 Document the quiz review state, including correct answer and explanation rendering after `Check`.
- [x] 3.7 Document the final quiz completion card with score, `Retake Test`, and `Back to Chapter` actions.
- [x] 3.8 Document the answer-evaluation rule that exact option-ID matches are required for a correct state.

## 4. Validation

- [x] 4.1 Review the proposal, design, and spec together for consistency.
- [x] 4.2 Confirm the change is ready for implementation planning and downstream task execution.

## 5. Bug Fixes

- [x] 5.1 Update `QuizReviewResultDto.fromJson` to parse `questionId` correctly by checking nested `question.id` or top-level `id` in the API response.
- [x] 5.2 Update `QuizReviewResultDto.fromJson` to parse `correctAnswers` correctly by checking both `correct_option_ids` (top-level and nested) and nested `options` with `is_correct = true`.
- [x] 5.3 Ensure `isAnswerCorrect` in `_injectReviewOverlay` prefers `review.result` directly if non-null, and falls back to comparing selections against correct answers.
- [x] 5.4 Verify that practice quiz attempts immediately show correctness without flashing, and regular exams freeze options on submit/check until API response returns.
- [x] 5.5 Parse `attempt_type` in `AttemptDto.fromJson` to ensure `attempt.isQuizMode` is accurately set.
- [x] 5.6 Force the questions URL to `/api/v2.5/attempts/{id}/questions/` when initializing quiz-mode attempts, enabling local correct option highlights.
- [x] 5.7 Sort questions loaded in quiz mode by section order/ID and then by question order to prevent section interleaving.
- [x] 5.8 Construct the quiz answer check URL using `/api/v2.2/` instead of `/api/v2.2.1/` so submissions do not fail with a 404.
