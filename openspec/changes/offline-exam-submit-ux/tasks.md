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

## 6. Open Button — Always show in offline list

- [x] 6.1 Replace the "Attend Exam" button label with "Open" (using `openExamAction`)
- [x] 6.2 Ensure the "Open" button is always visible regardless of exam status (including `SYNCED`) so users can access pre-screen details

## 7. Pre-Screen Navigation and Button Height Alignment

- [x] 7.1 Pushed `/exams/test/:id` with `?isOffline=true` parameter in `offline_exams_list_screen.dart`
- [x] 7.2 Updated routes in `exams_routes.dart` and `study_routes.dart` to read `isOffline` and pass `isOfflineOnly` to `ExamPrescreen`
- [x] 7.3 Implemented `isOfflineOnly` conditional rendering in `ExamPrescreen` to hide online attempts, retakes, and mode sheet
- [x] 7.4 Refactored `ExamPrescreenActionButton` to use core `AppButton` primitives for consistent design and height alignment

## 8. AppBadge Core Primitive Refactoring

- [x] 8.1 Extended `AppBadge` in `app_badge.dart` to accept an optional `Widget? leading` widget
- [x] 8.2 Refactored custom badges in `_ExamCardHeader` to use standard `AppBadge` core widgets
- [x] 8.3 Handled active `SYNCING` state inside `AppBadge` by passing `AppLoadingIndicator` via `leading` parameter

## 9. Unified Connectivity Helper

- [x] 9.1 Extracted `hasInternetConnection()` and `hasConnection()` in `network_utils.dart` and exported them in `core.dart`
- [x] 9.2 Reused `hasConnection()` in `SyncManager` to avoid duplicated list evaluation logic
- [x] 9.3 Extracted `_showOfflineToastIfNeeded()` in `test_detail_screen.dart` to reuse connectivity logic and removed direct package dependency on `connectivity_plus`

