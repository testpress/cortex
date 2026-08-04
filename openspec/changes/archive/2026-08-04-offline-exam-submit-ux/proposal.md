## Why

When a user completes an offline exam without internet, the app currently shows a full-screen result dialog (TestResultView) that mentions the exam is saved locally — but there is no feedback at the point of submission itself, and no status indicator in the downloaded exams list during/after sync. Users are left uncertain about whether their submission was queued and when it succeeded.

## What Changes

- **Toast on offline submit**: When the user submits an exam with no internet connection, immediately show a neutral toast (no success/error framing) confirming the exam was saved and will sync when connectivity returns.
- **Sync status in OfflineExamsListScreen**: The `_OfflineExamCard` in `offline_exams_list_screen.dart` shows a static "Downloaded" badge. It should reactively update to show "Syncing…" (with a spinner) when the `SyncManager` is actively submitting that exam, and a "Submitted ✓" badge once successfully synced — **without deleting the download record**.
- **Retain download after sync**: Currently `OfflineExamSyncService.syncPendingExams()` deletes the download row after a successful API call. Change it to mark the row with status `SYNCED` instead of deleting it. The downloaded exam remains visible in the list.
- **Add `SYNCED` status to DB schema**: Extend the status enum comment and downstream UI handling for the new `SYNCED` state. Existing statuses: `DOWNLOADED`, `IN_PROGRESS`, `PENDING_SYNC`. New: `SYNCED`.
- **New DB column `syncedAt`**: Add `syncedAt` nullable DateTime column to `OfflineExamDownloadsTable` to record when sync completed.
- **Offline-Only Pre-Screen Navigation**: Accessing the pre-screen from the offline list hides the "Start Online" actions, retake options, and completed attempts history, presenting only the "Start Offline" action.
- **Height-Aligned Action Buttons**: Use standard `AppButton` primitives in `ExamPrescreenActionButton` so all buttons (online and offline) share a consistent size and design.

## Capabilities

### New Capabilities
- `offline-exam-submit-ux`: Covers the end-to-end UX flow from offline submission toast → list status indicator (syncing / submitted) → retained SYNCED state in the downloads list → offline-only pre-screen navigation and button height alignment.

### Modified Capabilities
<!-- No existing spec-level requirements are changing -->

## Impact

- `packages/core/lib/data/db/tables/offline_exam_tables.dart` — new `syncedAt` column, new `SYNCED` status in comment
- `packages/core/lib/data/db/app_database.dart` — DB migration for new column; new `watchPendingSyncDownloads()` stream for reactive UI
- `packages/core/lib/data/services/offline_exam_sync_service.dart` — mark `SYNCED` + set `syncedAt` instead of deleting row
- `packages/exams/lib/screens/offline_exams_list_screen.dart` — `_ExamCardHeader` badge updates reactively: `DOWNLOADED` → `IN_PROGRESS` → `PENDING_SYNC` (syncing spinner) → `SYNCED` (green tick)
- `packages/exams/lib/screens/test_detail_screen.dart` — detect `isOfflineMode && !hasInternet` on exam completion; show `AppToast` before navigating to result view
- `packages/core/lib/l10n/app_en.arb` (and other locales) — new l10n key `offlineExamSavedToast`
- `packages/exams/lib/screens/exam_prescreen.dart` — support `isOfflineOnly` flag to filter out online elements
- `packages/exams/lib/widgets/exam_prescreen_action_button.dart` — refactor to use standard `AppButton` primitives
- No new dependencies required (`connectivity_plus` already in core)
