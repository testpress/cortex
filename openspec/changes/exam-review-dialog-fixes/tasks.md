## 1. Replace Ask Doubt Dialog with Navigation

- [x] 1.1 In `review_answer_detail_screen.dart`, replace the `_showAskDoubtDialog` call in `onAskDoubt` with a `context.push('/home/discussions/doubts/ask?question_id=${currentQuestion.id}')` call
- [x] 1.2 Delete the `_showAskDoubtDialog` method entirely from `_ReviewAnswerDetailScreenState`
- [x] 1.3 Remove any imports or local variables that were only used by `_showAskDoubtDialog` (e.g. `_stripHtml` if it is no longer referenced elsewhere)

## 2. Fix Comment & Report Dialog Button Alignment

- [x] 2.1 In `review_dialog_components.dart`, update `BaseReviewDialog` button row: remove `Expanded` from both buttons, set `mainAxisAlignment: MainAxisAlignment.end` so Cancel sits left of the action button at natural width
- [x] 2.2 Apply the same fix to `ReportReviewDialog` button row

## 3. Verify

- [x] 3.1 Confirm `_stripHtml` is not used anywhere else in the file before removing it
- [x] 3.2 Hot-reload and navigate to the exam review screen — tap "Ask Doubt" on any question and confirm it opens `AskDoubtFormScreen` with the correct question ID shown in the context badge
- [x] 3.3 Tap "Comment" — verify Cancel button is left-aligned and "Post Comment" is right-aligned at natural width
- [x] 3.4 Tap "Report" — verify Cancel button is left-aligned and "Report" is right-aligned at natural width
- [x] 3.5 Confirm tapping back from the ask doubt form returns to the exam review screen at the same question
