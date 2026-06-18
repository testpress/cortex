## Why

Currently, when a user goes to start an exam, the prescreen is shown using a manual overlay containing a black/dark background, which looks unpolished and lacks consistent animations. Furthermore, choosing between Regular Mode and Quiz Mode is done via a separate popup dialog, creating extra cognitive friction. 

## What Changes

- Replace the manual, custom overlay in `ExamPrescreen` with the design system's standardized `AppBottomSheet`.
- Update the GoRouter routes for test detail prescreens (`test/:id`) in both `exams_routes.dart` and `study_routes.dart` to use transparent page routes (`CustomTransitionPage` with `opaque: false`), allowing the underlying page to remain visible beneath the bottom sheet backdrop.
- Deprecate/remove the separate `ExamModeSelectionDialog` popup dialog.
- Embed the Regular Mode and Quiz Mode choices directly within the `ExamPrescreen` bottom sheet.
- Keep the "Start Exam Online" / "Resume Exam Online" button disabled until the user selects one of the available modes (if the exam supports both modes). If the exam only supports regular mode, or if a paused attempt is being resumed, the button is enabled by default.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `exam-mode-selection-dialog`: Integrate the mode selection inline in the bottom sheet instead of presenting it in a separate modal dialog.

## Impact

- `packages/exams/lib/screens/exam_prescreen.dart`: Major UI refactoring to use `AppBottomSheet` and implement inline mode selection.
- `packages/exams/lib/widgets/exam_mode_selection_dialog.dart`: Deprecate and remove.
- `packages/testpress/lib/navigation/routes/exams_routes.dart`: Convert `test/:id` routes to transparent `CustomTransitionPage`.
- `packages/testpress/lib/navigation/routes/study_routes.dart`: Convert `test/:id` routes to transparent `CustomTransitionPage`.
