## Why
During an active exam, the `QuestionPalette` widget provides a bottom sheet grid that lets users quickly see all question statuses (answered, marked, unvisited) and jump to any specific question. Currently, on the exam review screen, users can only navigate sequentially using 'Next' and 'Previous' buttons. Adding this same palette widget to the review screen will allow users to see an overview of their performance (correct, incorrect, skipped) and jump directly to specific questions during review, significantly improving navigation and user experience.

## What Changes
- Add a trigger button/widget (e.g., "View All Questions") to the bottom of the exam review screen, similar to the active exam screen.
- Reuse the existing `QuestionPalette` widget to display the grid of question numbers.
- Update `QuestionPalette` and related widgets to support a "review mode" where colors reflect correctness (e.g., green for correct, red for incorrect, grey for unattempted) rather than exam progress status.
- Add navigation logic so tapping a question number in the palette during review mode jumps directly to that question in the review page view.

## Capabilities

### New Capabilities

### Modified Capabilities
- `lms-exam-review`: Update the review screen to include the question palette trigger and integrate the question navigation logic.

## Impact
- `packages/exams`: `QuestionPalette` widget and related shape/legend components to support "review mode".
- `packages/exams`: `ReviewAnswerDetailScreen` or wherever the review mode is hosted to show the palette trigger and handle jumps.
