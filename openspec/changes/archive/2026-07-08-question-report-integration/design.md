## Context

The exam review screen has a UI for reporting errors in questions, but it is currently not integrated with the backend API. We need to hook up the UI to submit reports and provide proper visual feedback to the user, ensuring they cannot submit duplicate reports for the same question during a session.

## Goals / Non-Goals

**Goals:**
- Integrate the report dialog with the `POST /api/v2.5/questions/<question_id>/reportees/` endpoint.
- Track reported questions in the local `ExamAttemptState` to prevent duplicate submissions.
- Implement optimistic error handling (gracefully handle `400 Bad Request` if already reported).
- Disable the "Report" button in the footer for questions that have already been reported.

**Non-Goals:**
- Changing the design of the report dialog or the report options.
- Persisting the locally tracked `reportedQuestions` state across app restarts (this relies on the API response for long-term state).

## Decisions

1. **API Integration in Data Layer**
   - Add `Future<void> reportQuestion(String questionId, Map<String, dynamic> payload)` to `DataSource` and implement it in `HttpDataSource` using the existing `apiClient`.

2. **State Management in Repository Layer**
   - Add a `Set<String> reportedQuestions` to `ExamAttemptState` to track questions that have been reported locally.
   - Add `reportQuestion` method to `ExamRepository` and implement it in `OnlineExamRepository`.
   - In `OnlineExamRepository`, catch `DioException`. If the status code is `400` and the detail message contains "already reported", update the local state to mark it as reported instead of bubbling up a generic error.

3. **UI Wiring in Screen Layer**
   - In `_ReportReviewDialogState` (`review_dialog_components.dart`), handle the form submission. Pass the `questionId`, `type` (selected radio button), `description`, and `examId`.
   - Show success (`AppToast`) on successful submission.
   - For any `ApiException`, surface `e.message` (already extracted by the exception layer) directly in the error toast. For all other unexpected errors, fall back to the generic `reviewReportFailed` localized string.
   - In `ReviewFooterActions`, watch the `reportedQuestions` state. If `reportedQuestions.contains(question.id)`, set the `onTap` for the report button to `null` to disable it automatically.

## Risks / Trade-offs

- **Risk:** The backend changes the 400 error message format (e.g., stops returning "already reported").
  **Mitigation:** The optimistic UI relies on the specific string matching for "already reported". If it changes, the app will show a generic error toast instead of gracefully updating the local state, which is a safe fallback.
- **Risk:** Losing local state on app restart.
  **Mitigation:** The Optimistic UI handles this: if the state is lost, the user can click report again, but the API will return the 400 error, which we catch and then update the state to disable the button again.
