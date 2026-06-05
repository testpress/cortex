# Proposal: exam-mode-selection-dialog

## Why

Some exams expose an additional quiz-capable start path, but the current Cortex exam entry flow only covers the standard regular start experience. Users need a clear pre-start choice when quiz mode is enabled so they can enter the exam in the intended mode without leaving the current UI.

## What Changes

- Add a modal mode-selection step to the exam start flow when quiz mode is available.
- Preserve the existing regular exam start behavior when quiz mode is not available.
- Route the selected mode through the active exam session so the chosen path is preserved for the attempt lifecycle.
- Keep the dialog and resulting flow aligned with the current Cortex UI patterns.

## Capabilities

### New Capabilities
- `exam-mode-selection-dialog`: Presents a pre-start dialog for eligible exams and routes the user into regular mode or quiz mode based on their selection.

### Modified Capabilities
- None

## Impact

- Exams package start flow and prescreen entry handling
- Exam attempt/session orchestration
- Dialog UI and localized labels
- Metadata handling for quiz-capable exams
