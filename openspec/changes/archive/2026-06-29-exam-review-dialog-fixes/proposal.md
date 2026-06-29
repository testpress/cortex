## Why

When a student is reviewing their exam answers in `ReviewAnswerDetailScreen`, tapping the "Ask Doubt" button currently opens a minimal inline dialog with a plain text field — disconnected from the fully-featured `AskDoubtFormScreen` in the `discussions` package. Additionally, the Comment and Report dialogs have a layout issue where Cancel and the action button are both stretched to equal widths using `Expanded`, resulting in an unbalanced, oversized Cancel button. Both issues affect the post-exam review UX and can be addressed together.

## What Changes

- The `onAskDoubt` callback in `ReviewAnswerDetailScreen` will navigate to the existing `AskDoubtFormScreen` instead of showing the current local dialog.
- `AskDoubtFormScreen` will receive the `questionId` of the currently displayed question so it can pre-populate the doubt context.
- The `_showAskDoubtDialog` method in `review_answer_detail_screen.dart` will be replaced with a route push.
- In `review_dialog_components.dart`, the Comment dialog (`BaseReviewDialog`) and Report dialog (`ReportReviewDialog`) button rows will be fixed: Cancel becomes a natural-width button on the left, and the action button (Post Comment / Report) sits right-aligned beside it.

## Capabilities

### New Capabilities

- `exam-review-ask-doubt-navigation`: Navigation from the exam review screen's "Ask Doubt" button to the existing `AskDoubtFormScreen`, passing the current `questionId` as context.

### Modified Capabilities

- `lms-exam-review`: The "Ask Doubt" action in the per-question review view now navigates to the full doubt form instead of an inline dialog.

## Impact

- **`packages/exams/lib/screens/review_answer/review_answer_detail_screen.dart`**: Replace `_showAskDoubtDialog` with a `context.push` call to the `AskDoubtFormScreen` route.
- **`packages/exams/lib/screens/review_answer/widgets/review_dialog_components.dart`**: Fix button alignment in `BaseReviewDialog` and `ReportReviewDialog` — remove `Expanded` from both buttons, align row to the right.
- **`packages/discussions`**: No changes needed — `AskDoubtFormScreen` already accepts `questionId` as an optional parameter.
- **Dependencies**: No new package dependencies required.
