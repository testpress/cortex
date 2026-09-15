## 1. Localization and Services

- [x] 1.1 Add localized strings for manual sync action and feedback toasts in `packages/core/lib/l10n/app_en.arb` and generate localizations.
- [x] 1.2 Disable automatic foreground connectivity listener in `packages/core/lib/data/services/sync_manager.dart`.
- [x] 1.3 Add `syncExam(int downloadId)` to `OfflineExamSyncService` in `packages/core/lib/data/services/offline_exam_sync_service.dart`.

## 2. Controller and Offline Exams UI

- [x] 2.1 Expose `syncExam(int downloadId)` on `OfflineExams` notifier in `packages/core/lib/data/providers/offline_exams_provider.dart`.
- [x] 2.2 Update `_ExamCardActions` in `packages/exams/lib/screens/offline_exams_list_screen.dart` to show "Sync" button with loading indicator when `exam.status == 'PENDING_SYNC'`, and hide actions when `exam.status == 'SYNCED'`.
- [x] 2.3 Add feedback toasts for sync success and failure in `packages/exams/lib/screens/offline_exams_list_screen.dart`.

## 3. Verification & Tests

- [x] 3.1 Run tests across core and exams packages and verify flutter analyze passes cleanly.
