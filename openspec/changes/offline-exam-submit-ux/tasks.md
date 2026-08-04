## 1. Database Schema

- [x] 1.1 Add `syncedAt` nullable `DateTimeColumn` to `OfflineExamDownloadsTable` in `offline_exam_tables.dart`
- [x] 1.2 Bump `schemaVersion` from `1` to `2` in `AppDatabase` *(skipped per user — no migration needed)*
- [x] 1.3 Add `onUpgrade` branch: when `from < 2`, call `m.addColumn(...)` *(skipped per user — no migration needed)*
- [x] 1.4 Update the status enum comment in `offline_exam_tables.dart` to include `SYNCED`
- [x] 1.5 Run `dart run build_runner build --delete-conflicting-outputs` to regenerate `app_database.g.dart`

## 2. Sync Service — Retain Row Instead of Delete

- [x] 2.1 In `OfflineExamSyncService.syncPendingExams()`, replace `_db.deleteDownload(download.id)` (success path) with an `upsertDownload` call that sets `status = 'SYNCED'` and `syncedAt = DateTime.now().toUtc()`
- [x] 2.2 Verify the permanent-failure 4xx path still calls `deleteDownload` (no change needed, just confirm)

## 3. Localisation — New Toast String

- [x] 3.1 Add `offlineExamSavedToast` key to `app_en.arb`: `"Exam saved. It will be submitted automatically when you're back online."`
- [x] 3.2 Add translated string to `app_ta.arb`
- [x] 3.3 Add translated string to `app_ml.arb`
- [x] 3.4 Add translated string to `app_ar.arb`
- [x] 3.5 Run `flutter gen-l10n` (or equivalent) to regenerate localisation classes

## 4. Offline Submission Toast

- [x] 4.1 In `_TestDetailContent` (test_detail_screen.dart), locate the `endExam()` call in the pause/submit confirmation handler
- [x] 4.2 After `endExam()` resolves, check `widget.isOfflineMode` is true
- [x] 4.3 Call `Connectivity().checkConnectivity()` — if result does not contain `mobile`, `wifi`, or `ethernet`, show `AppToast.show(context, message: l10n.offlineExamSavedToast)`
- [x] 4.4 Ensure the toast appears before (or alongside) the `TestResultView` / `QuizResultView` — do not block the result view

## 5. Reactive Status Badge in Downloads List

- [x] 5.1 In `_ExamCardHeader` (`offline_exams_list_screen.dart`), replace the hardcoded green "Downloaded" badge with a status-aware widget
- [x] 5.2 `DOWNLOADED` → existing green badge with `LucideIcons.checkCircle2` (no change)
- [x] 5.3 `IN_PROGRESS` → blue/accent badge with `LucideIcons.pencil` and label `l10n.inProgressStatus` (add l10n key if missing)
- [x] 5.4 `PENDING_SYNC` → amber/warning badge with a `SizedBox`-wrapped `CircularProgressIndicator` (16dp) and label `l10n.syncingStatus` (add l10n key if missing)
- [x] 5.5 `SYNCED` → green badge with `LucideIcons.checkCircle2` and label `l10n.submittedStatus` (add l10n key if missing)
- [x] 5.6 Add any missing l10n keys (`inProgressStatus`, `syncingStatus`, `submittedStatus`) to all four ARB files and regenerate

## 6. Attend Button — Hide for SYNCED exams

- [x] 6.1 In `_ExamCardActions`, disable or hide the "Attend Exam" button when `exam.status == 'SYNCED'` (the exam has already been submitted; retaking offline is not applicable)
- [x] 6.2 Optionally show a read-only info label instead of the button for `SYNCED` exams
