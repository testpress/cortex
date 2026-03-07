# Tasks: lms-test-detail-refinement

## 1. Submission Flow Implementation
- [x] 1.1 Create `SubmitConfirmationDialog` with state-aware summary (answered/unanswered count).
- [x] 1.2 Refactor `TestResultView` to act as a modal overlay with a dimmed background.
- [x] 1.3 Update `TestDetailScreen` logic to sequence the confirmation and result overlays.
- [x] 1.4 Link "Review Answers" and "View Analytics" buttons to appropriate navigation placeholders.

## 2. Visual Polish & Scaling
- [x] 2.1 Reduce `SubmitConfirmationDialog` and `TestResultView` card widths and internal padding.
- [x] 2.2 Scale down icon sizes (32px -> 24px) and headline font sizes (24px -> 20px) in overlays.
- [x] 2.3 Reduce vertical padding in buttons to create a more compact, premium look.
- [x] 2.4 Refine `TestQuestionCard` and `OptionCard` sizing (padding and font size reductions).

## 3. Terminology & Cleanup
- [x] 3.1 Replace all instances of "Assessment" with "Test" in UI strings and localized keys.
- [x] 3.2 Remove legacy material imports and unused scoring logic.
- [x] 3.3 Ensure the background remains visible but dimmed behind active overlays.
