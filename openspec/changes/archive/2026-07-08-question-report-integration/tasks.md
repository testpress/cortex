## 1. Core Data Layer Updates

- [x] 1.1 Add `reportQuestion` method signature to `DataSource` (packages/core/lib/data/sources/data_source.dart)
- [x] 1.2 Implement `reportQuestion` in `HttpDataSource` (packages/core/lib/data/sources/http_data_source.dart) to POST to `/api/v2.5/questions/<question_id>/reportees/`

## 2. Local State & Repository Layer

- [x] 2.1 Update `ExamAttemptState` to include `final Set<String> reportedQuestions` (packages/exams/lib/repositories/exam_repository.dart)
- [x] 2.2 Add `reportQuestion` method signature to `ExamRepository` interface
- [x] 2.3 Implement `reportQuestion` in `OnlineExamRepository` with optimistic error handling for HTTP 400 "already reported" and local state updates

## 3. UI Integration

- [x] 3.1 Update `_ReportReviewDialogState` (packages/exams/lib/screens/review_answer/review_dialog_components.dart) to submit the report using `ExamRepository.reportQuestion`
- [x] 3.2 Implement success toast and error toast handling within `_ReportReviewDialogState`
- [x] 3.3 Update `ReviewFooterActions` to disable the "Report" button if the current question is in the `reportedQuestions` state
