## Context

Currently, the `ExamPrescreen` is shown as a separate opaque route in `GoRouter`. Within its widget tree, it manually implements a dark overlay backdrop with a custom container placed at the bottom center of the screen to look like a bottom sheet. Because the route is opaque, the backdrop shows a solid black background behind it, which is visually unappealing and inconsistent with the platform's sheet presentation.

Additionally, when quiz mode is enabled, the user has to click "Start Exam Online" first, which then presents a separate popup dialog (`ExamModeSelectionDialog`) to select the mode.

## Goals / Non-Goals

**Goals:**
- Wrap `ExamPrescreen` contents in `AppBottomSheet` to reuse the design system's standardized sheet animations, backdrop, and drag gesture.
- Transition `test/:id` routes in `exams_routes.dart` and `study_routes.dart` using a custom page builder returning `CustomTransitionPage` with `opaque: false` to allow the underlying screen to remain visible.
- Inline the mode selection options (Regular vs Quiz) directly inside `ExamPrescreen` so they are visible immediately.
- Disable the "Start Exam Online" button until the user selects one of the options (when multiple options exist).
- Remove `ExamModeSelectionDialog` completely.

**Non-Goals:**
- Modify the test attempt player or assessment screens.
- Alter backend APIs or parameters for starting/resuming attempts.

## Decisions

### Decision 1: Use CustomTransitionPage with opaque: false in GoRouter
- **Rationale**: To remove the black background under the bottom sheet, we must configure the route itself to be transparent. Using `CustomTransitionPage(opaque: false, ...)` in `GoRoute.pageBuilder` ensures the route transition doesn't clear the screen underneath.
- **Alternative**: Using an imperative `showModalBottomSheet`. While feasible, this deviates from the repo's declarative GoRouter schema where exam details are deep-linkable and mapped to specific URLs like `/study/test/:id`.

### Decision 2: Inline Option Cards with Selected State
- **Rationale**: If the exam supports quiz mode (`enableQuizMode == true`) and is not a resume flow (`!isResuming`), we render two selection cards representing Regular Mode and Quiz Mode. We track the selection in a local state variable `bool? _isQuizMode`. When selected, the "Start Exam Online" button becomes enabled.
- **Alternative**: Dropdown selection or radio buttons. Interactive cards with icons are more touch-friendly, consistent with the previous design, and offer a premium UI/UX.

## Risks / Trade-offs

- **Risk**: Pop/dismiss behavior when user taps outside the sheet or drags it down.
  - **Mitigation**: `AppBottomSheet` handles gesture dismissal and calls its `onClose` callback. We pass `context.pop()` to `onClose` so the route is popped correctly when the sheet is closed.
