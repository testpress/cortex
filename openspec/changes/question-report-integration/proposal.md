## Why

Users currently cannot report issues they find in questions (e.g., typos, wrong answers) directly from the exam review screen to the backend. Hooking up the report dialog box allows users to easily report questions, providing valuable feedback to improve content quality without disrupting their review flow.

## What Changes

- Enable the ability to submit question error reports directly from the exam review screen.
- Maintain a local session history of reported questions so users don't accidentally report the same question multiple times.
- Provide clear visual feedback when a report is successfully submitted or if it fails.
- Automatically disable the report button for questions that have already been reported, either in this session or previously (handled via an optimistic API response).

## Capabilities

### New Capabilities

- `exam-question-reporting`: Core capability for allowing learners to report errors on exam questions, including handling submission and already-reported states.

### Modified Capabilities

- `lms-exam-review`: The review screen is extended to integrate the question reporting flow, handling success/error feedback and disabling the report action when appropriate.

## Impact

- **API Integration:** Will require communication with the backend reporting endpoints.
- **State Management:** The exam review session state will be updated to track reported questions.
- **UI:** The exam review screen's dialogs and footer actions will be updated to reflect the reported status and handle submissions.
