## 1. Study Route Configuration

- [x] 1.1 Register `AppRouteNames.assessmentDetail` at `/study/assessment/:id` in `StudyRoutes` to render `ExamPrescreen`
- [x] 1.2 Add player sub-route `/study/assessment/:id/player` rendering `AssessmentDetailScreen` in quiz mode
- [x] 1.3 Configure review sub-routes `/study/assessment/:id/review-analytics`, `subject-performance`, and `review-answers`

## 2. Assessment Prescreen Adaptation

- [x] 2.1 Update `ExamPrescreen` to detect `paused` attempts and enable resume
- [x] 2.2 Suppress mode selection bottom sheet for assessment lessons
- [x] 2.3 Hide `OfflineExamActionButton` in `ExamPrescreenBottomBar` for assessments

## 3. Assessment Controller & State Hydration

- [x] 3.1 Implement `AssessmentController` to coordinate attempt lifecycle with `startCourseLinkedExam`
- [x] 3.2 Hydrate `attemptStates` and `currentIndex` from `ExamAttemptState` on resume
- [x] 3.3 Implement `selectOption`, `checkAnswer`, `next`, `previous`, `pauseExam`, and `endExam`
- [x] 3.4 Invalidate `lessonDetailProvider` and `examAttemptsProvider` on pause and completion

## 4. Assessment Player & Option Cards

- [x] 4.1 Create `AssessmentOptionCard` supporting singleSelect/multiSelect and hybrid HTML rendering
- [x] 4.2 Integrate `PauseConfirmationDialog` and `PopScope` into `AssessmentDetailScreen`
- [x] 4.3 Implement score summary result view with retake and review navigation actions

## 5. Tests & Verification

- [x] 5.1 Add widget tests in `assessment_detail_screen_test.dart` for question rendering, pause dialog, and hydrated answers
- [x] 5.2 Add route tests in `study_routes_test.dart` and `app_router_test.dart`
