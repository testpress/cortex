## 1. Route Configuration

- [x] 1.1 Update `exams_routes.dart` to use `CustomTransitionPage` with `opaque: false` for both `/exams/test/:id` routes.
- [x] 1.2 Update `study_routes.dart` to use `CustomTransitionPage` with `opaque: false` for `/study/test/:id` route.

## 2. Refactor Exam Prescreen UI

- [x] 2.1 Update `exam_prescreen.dart` to use `AppBottomSheet` as its root widget and remove manual backdrop gestures and slide transition wrappers.
- [x] 2.2 Add `bool? _selectedIsQuizMode` state to track selection.
- [x] 2.3 Add inline card widgets for Regular Mode and Quiz Mode in `exam_prescreen.dart` when multiple modes are eligible.
- [x] 2.4 Add dynamic button styling and disabled state when mode selection is required but not yet selected.
- [x] 2.5 Ensure clicking "Start Exam Online" initiates attempt with the selected mode.

## 3. Deprecation and Cleanup

- [x] 3.1 Delete `packages/exams/lib/widgets/exam_mode_selection_dialog.dart` as it is no longer used.
