## Why

Custom practice exams allow learners to take targeted sessions on their own terms — choosing what course to practice, the scope of topics, the source and number of questions, difficulty, and how they want to be tested. This adds a self-directed study mode that is distinct from the assigned exams tied to course lessons. Where assigned exams are pre-configured by the institution, custom practice is entirely learner-driven and can be repeated and adjusted freely.

## What Changes

- Introduces a new **Custom Exam Options screen** that appears before a custom practice exam session begins.
- Users can select: course, practice scope (full course or selected lessons), question source, number of questions, difficulty level, and attempt mode (Test / Quiz).
- When "Selected lessons" is chosen as the practice scope, a conditional lesson picker is revealed inline for topic-level selection.
- A primary action confirms the configuration and initiates the exam session.

## Capabilities

### New Capabilities

- `exam-options-screen`: The configuration screen shown before a custom practice exam. Covers the user-selectable options, conditional lesson picker behaviour, and the primary action that proceeds to the exam.

### Modified Capabilities

<!-- None. Existing exam specs (exam-lifecycle-operations, exam-mode-selection-dialog, etc.) are not changing at the requirements level. -->

## Impact

- `packages/exams` — new screen added; existing exam entry flow updated to route through the config screen.
- No changes to existing exam player, review, or analytics screens.
- No API changes expected at this stage; question source and difficulty options will be driven by whatever the existing exam API already exposes.
