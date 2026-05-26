## 1. Models Update

- [x] 1.1 Add `pausedAttemptsCount` to `ExamDto` in `packages/core/lib/data/models/exam_dto.dart` and parse it in `fromJson`.
- [x] 1.2 Fix missing `state` mapping in `AttemptDto.fromJson` in `packages/core/lib/data/models/attempt_dto.dart`.
- [x] 1.3 Preserve retake/resumption settings (`disableAttemptResume`, `allowRetake`, `maxRetakes`) when creating `ExamDto` in `packages/exams/lib/screens/test_detail_screen.dart`.




## 2. Repository Resumption Logic

- [x] 2.1 Update `ExamRepository.startStandaloneExam` in `packages/exams/lib/repositories/exam_repository.dart` to fetch attempts and resume the 'Running' attempt if `pausedAttemptsCount > 0`.
- [x] 2.2 Update `ExamRepository.startCourseLinkedExam` to apply the identical resumption logic if applicable.
- [x] 2.3 Add empty attempts safety checks in `ExamRepository.startStandaloneExam` to fall back to `createAttempt`.
- [x] 2.4 Add empty attempts safety checks in `ExamRepository.startCourseLinkedExam` to fall back to `createAttempt`.



## 3. UI: Exam Prescreen

- [x] 3.1 Modify `ExamPrescreen` in `packages/exams/lib/screens/exam_prescreen.dart` to check `exam.pausedAttemptsCount > 0` and dynamically render "Resume Exam Online".

## 4. UI: Exit Interception & Dialog

- [x] 4.1 Create `PauseConfirmationDialog` widget in `packages/exams/lib/widgets/test_detail/pause_confirmation_dialog.dart`.
- [x] 4.2 Update `TestDetailScreen` in `packages/exams/lib/screens/test_detail_screen.dart` to use `canPop: false` inside `PopScope`.
- [x] 4.3 Connect `TestHeader.onExit` and the `PopScope` callback to trigger `_showPauseConfirmation`.
- [x] 4.4 Implement "Pause" action in the dialog to execute `Navigator.of(context).pop()` and reset the attempt state safely.

## 5. UI: WebView/HTML Option Indicator Rendering Fix

- [x] 5.1 Update `removeEmptyNodes` inside `packages/core/lib/widgets/app_html.dart` to check and preserve elements with the `.indicator` class (or their descendants).
- [x] 5.2 Prevent parent wrapper elements of custom option indicators from being removed in `removeEmptyNodes` inside `packages/core/lib/widgets/app_html.dart`.



## 6. Subject Mapping API Translation

- [x] 6.1 In `packages/core/lib/data/sources/http_data_source.dart`, update the `getQuestions` method to replace `'v2.3'` with `'v2.2.1'` in the questions URL before making the GET request.


