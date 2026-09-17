## Context

Assessment and quiz lessons launched from the Study tab need to follow the standardized exam architecture while offering an interactive, instant-feedback quiz experience. This requires a structured prescreen entry point, a dedicated player route, seamless pause and resume state hydration, and access to review analytics.

## Goals / Non-Goals

**Goals:**
- Provide a consistent entry flow for assessment lessons via `ExamPrescreen` on `/study/assessment/:id`.
- Support dedicated quiz player on `/study/assessment/:id/player` with instant feedback and answer hydration on resume.
- Safeguard active attempt progress via `PauseConfirmationDialog` and cache invalidation on pause/finish.
- Provide post-attempt review routes for analytics, subject performance, and answer explanations.

**Non-Goals:**
- Modifying general exam (non-quiz) UI or changing existing lesson routing outside of assessments.

## Decisions

- **Prescreen Entry & Player Route**: Map `AppRouteNames.assessmentDetail` to `/study/assessment/:id` rendering `ExamPrescreen`. On starting/resuming, navigate to `/study/assessment/:id/player?isQuizMode=true` rendering `AssessmentDetailScreen`.
- **Prescreen Adaptation**: Recognize `paused` attempts for resume, suppress exam mode selection sheets, and hide offline action buttons for assessments.
- **Dedicated Assessment Controller**: Implement `AssessmentController` using Riverpod to coordinate attempt synchronization, single-select instant checking, multi-select evaluation, and cache invalidation on finish/pause.
- **Answer Hydration on Resume**: When syncing an existing attempt, hydrate `attemptStates` with previously submitted options and checked statuses, and restore `currentIndex` to the first unanswered or last viewed question.
- **Pause & Exit Interception**: Intercept back gestures in `AssessmentDetailScreen` via `PopScope` to display `PauseConfirmationDialog` before exiting.
- **Hybrid Option Rendering**: Use `AssessmentOptionCard` with `AppHtml` for media embeds (`video`, `iframe`) and `AppHtmlV2` with `AbsorbPointer` for lightweight text options.
- **Forward-Only Assessment Progression**: Unlike standard exams in `TestDetailScreen` (which maintain bidirectional navigation and a question palette even in quiz mode), `AssessmentDetailScreen` specifically implements a forward-only interactive stepper (Check Answer → Continue) for `LessonType.assessment` study lessons, where instant verification and explanations lock each question sequentially.

## Risks / Trade-offs

- **Risk**: User exits without explicitly selecting pause in the dialog.
  - *Mitigation*: Back gestures trigger the confirmation dialog, requiring explicit confirmation before exiting.
- **Trade-off**: Running assessments under `ExamPrescreen` introduces an extra step compared to direct launch, but provides necessary parity for attempt history and retake capabilities.
