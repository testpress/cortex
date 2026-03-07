## Why

Following the completion of a test, students need a consolidated view of their performance. A detailed review screen allows students to scan through the test questions, identify patterns in their mistakes, and study explanations in a paged, unified view.

## What Changes

- **New Screen**: Implement `ReviewAnswerDetailScreen` which displays a paged review of all questions from a completed test.
- **Question Card**: Each question is presented as a card with 'Previous' and 'Next' buttons for navigation:
    - **Card View**: Shows the full question text, options, the user's selected answer, the correct answer, and the detailed explanation.
- **Filtering**: Add filter options to filter by "All", "Correct", "Incorrect", and "Unanswered".
- **Navigation Integration**: Add a "Review Answers" button to the `TestDetailScreen` result view (Phase 1 completion view) that navigates to this review interface.

## Capabilities

### New Capabilities
- `lms-exam-review`: Handles the post-test paged review experience, including filtering and status summaries.

### Modified Capabilities
- `lms-test-detail`: Update the "Final Submission & Summary" requirement to include a navigation path to the detailed exam review.

## Impact

- **Packages**: `courses` (new screen and widget updates).
- **Widgets**: New paged review widgets displaying the question and explanations along with navigation buttons.
- **Localization**: New strings for filters ("All", "Wrong", "Correct", "Unanswered") and "Exam Review" title.
