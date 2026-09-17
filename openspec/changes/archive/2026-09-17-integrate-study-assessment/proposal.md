## Why

When users attempt to launch an assessment/quiz item from the chapter details screen within the Study tab, `LessonRouter.navigateToLesson` resolves the item to `AppRouteNames.assessmentDetail`. Currently, the assessment flow lacks alignment with standard exams: it needs to open through `ExamPrescreen` for attempt history and actions, launch into `AssessmentDetailScreen` via a dedicated player route in quiz mode, support pause/exit confirmation, and hydrate previously answered questions on resume.

## What Changes

- Update `StudyRoutes` to register `AppRouteNames.assessmentDetail` at `/study/assessment/:id` rendering `ExamPrescreen`, and add child routes for the player (`/player`) and review screens (`/review-analytics`, `/review-answers`).
- Implement `AssessmentController` to manage attempt synchronization, instant answer checking, and state hydration (answers, checked status, last question index) on resume.
- Integrate `PauseConfirmationDialog` into `AssessmentDetailScreen` to prevent accidental progress loss on back navigation.
- Extract `AssessmentOptionCard` to support single-select, multi-select, and media-safe HTML rendering.

## Capabilities

### Modified Capabilities
- `centralized-navigation`: Route study assessments through `ExamPrescreen` with dedicated player and review child routes.
- `assessment-detail-live-data`: Bind `AssessmentDetailScreen` to live attempt data with answer hydration, pause dialog, and quiz mode completion flow.

## Impact

- `packages/testpress/lib/navigation/routes/study_routes.dart`: Assessment and review route definitions.
- `packages/exams/lib/providers/assessment_controller.dart`: Attempt controller and state management.
- `packages/exams/lib/screens/assessment_detail_screen.dart`: Assessment player and pause confirmation integration.
- `packages/exams/lib/screens/exam_prescreen.dart`: Assessment prescreen adaptation.
