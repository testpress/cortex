## Why
The current custom exam flow needs a revamp to support a more granular and modular selection of subjects. Students need the ability to add multiple subject configurations (with specific difficulty levels, question types, and question counts for each) in a single custom exam attempt, which the current linear flow does not adequately support. This revamp improves customization and flexibility for practice.

## What Changes
- Replace the current linear wizard screens with a single unified "Builder" screen for custom exam configuration.
- Update subject selection to support a nested hierarchy (tree view/drill-down).
- Allow users to configure difficulty, question types, and number of questions per selected subject block.
- Display configured subject blocks as summary cards on the Builder screen, allowing the user to add more or remove existing blocks without navigating away.
- **BREAKING:** Update the POST `/api/v3/courses/{course_id}/custom-test/` payload to use the new `questionnaires` array format.
- Add robust error handling for API limits (daily/monthly) by catching and displaying HTTP 403 error messages.
- Conditionally hide the custom exam Floating Action Button (FAB) on the Exams tab if the AI tab feature flag is enabled, to prevent UI conflicts.

## Capabilities

### New Capabilities

### Modified Capabilities
- `custom-exam`: Updating the core API payload and logic to support the new `questionnaires` array and limits validation.
- `custom-exam-options-screen`: Revamping the UI flow to accommodate nested subjects, per-subject configuration filters, and a review screen.

## Impact
- `packages/exams`: Significant refactoring of existing screens (e.g., `custom_exam_options_screen.dart`, `custom_exam_config_screen.dart`) and their respective state providers to handle the multi-block configuration state.
- Custom Exam API models and repository methods will be updated to reflect the new request and response structures.
