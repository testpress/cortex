## Why

The backend enforces a hard limit on the total number of questions (e.g., 200) for a custom exam, spanning across all selected subjects/questionnaires. Currently, the frontend only caps the slider at the individual block level without considering the total already used. This allows users to add more total questions than the limit permits, resulting in a confusing backend API error at generation time. We need to transparently enforce the remaining quota in the UI to prevent errors and improve the user experience.

## What Changes

- Add a dynamic calculation of used vs. remaining quota based on the `CustomTestConfigDto` limit and the currently added blocks.
- Update the custom exam builder screen to disable the `+ Add Questionnaire` button when the remaining quota drops below the minimum required (1).
- Display the used/total budget contextually on the builder screen (e.g., "Total Questions: 150 / 200").
- Update the `+ Add` button text to reflect the state ("Add Questionnaire", "Add More Questionnaires", or "Limit Reached").
- Update the `CustomExamSubjectBottomSheet` slider to dynamically cap its maximum value at the remaining quota instead of the absolute max.
- Clamp the internal `_noOfQuestions` state against the remaining quota to fix a bug where hitting "Save" without touching the slider bypasses the visual limit.

## Capabilities

### New Capabilities

- `custom-exam-total-limit-enforcement`: Frontend enforcement of the global question limit across multiple questionnaire blocks in the custom exam builder.

### Modified Capabilities

- `custom-exam`: Updating the requirements for the custom exam builder UI to respect a shared limit pool instead of isolated per-block limits.

## Impact

- **UI**: `CustomExamBuilderScreen`, `CustomExamSubjectBottomSheet`
- **State**: No changes to the state model, but derived state (used questions, remaining questions) will be calculated in the UI.
- **Data Models**: No changes. `CustomTestConfigDto` already provides `limits.maxQuestionsPerTest` which we will use as the total pool size.
