## 1. Implementation

- [x] 1.1 Update `setPausedAttemptsCount` in `exam_providers.dart` to save `last_local_paused_update` in the database JSON metadata.
- [x] 1.2 Update `revalidate` in `exam_providers.dart` to check `last_local_paused_update` from the database JSON metadata and keep local overrides if within 5 minutes.
- [x] 1.3 Terminate active section in `ExamRepository.endExam` on the server before ending the exam.

## 2. Verification

- [x] 2.1 Verify that launching the exam, ending/submitting it, restarting the app, and returning to the exam keeps the CTA as "Start" and does not revert to "Resume".
- [x] 2.2 Verify that ending/submitting an exam terminates the active section first and transitions the overall attempt on the server to completed.
