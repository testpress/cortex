## Why

Following the completion of an assessment or test, students need a consolidated view of their performance. The current result view only shows the final score. A detailed review screen allows students to scan all questions, identify patterns in their mistakes, and study explanations in a high-density list format.

## What Changes

- **New Screen**: Implement `ExamReviewScreen` which displays a scrollable list of all questions from a completed assessment.
- **Question Accordion**: Each question in the list will follow an expand/collapse pattern:
    - **Header**: Shows question number, subject, correctness status badge, and the question snippet.
    - **Expanded Content**: Shows the full question text, the user's selected answer, the correct answer, and the detailed explanation.
- **Filtering**: Add filter chips at the top of the list to filter by "All", "Correct", "Incorrect", and "Unanswered".
- **Navigation Integration**: Add a "Review Answers" button to the `TestDetailScreen` result view (Phase 1 completion view) that navigates to this list.

## Capabilities

### New Capabilities
- `lms-exam-review`: Handles the post-test list-based review experience, including filtering and status summaries.
- `lms-review-answer-detail`: Manages the single-question focused review experience with interactive action dialogs (Ask Doubt, Comment, Report).

### Modified Capabilities
- `lms-test-detail`: Update the "Final Submission & Summary" requirement to include a navigation path to the detailed exam review.

## Impact

- **Packages**: `courses` (new screen and widget updates).
- **Widgets**: New `ReviewQuestionListItem` accordion widget.
- **Localization**: New strings for filters ("All", "Wrong", "Correct", "Unanswered") and "Exam Review" title.
