## Context

Currently, `SyncManager` attempts silent automatic sync on network transitions. In `OfflineExamsListScreen`, `_ExamCardActions` always renders an "Open" button regardless of whether an exam is `DOWNLOADED`, `IN_PROGRESS`, `PENDING_SYNC`, or `SYNCED`. For completed exams in `PENDING_SYNC`, opening the exam is invalid and fails to provide clarity.

## Goals / Non-Goals

**Goals:**
- Replace the "Open" action button with a "Sync" action button when an exam card is in `PENDING_SYNC` status.
- Show an inline loading state on the "Sync" button while synchronization is executing.
- Provide clear visual toast notifications when manual sync succeeds or fails.
- Remove automatic background/connectivity-triggered synchronization in `SyncManager`.

**Non-Goals:**
- Client-side offline grading/evaluation (evaluations remain strictly performed on the backend API upon sync).
- Modifying offline exam download and asset caching workflows.

## Decisions

### 1. Status-Based Action Button Rendering in `_ExamCardActions`
- **Decision:** If `exam.status == 'PENDING_SYNC'`, render an `AppButton.primary` labeled `l10n.syncAction` with `LucideIcons.refreshCw` (or `cloudUpload`).
- **If `exam.status == 'SYNCED'`**: Hide the "Open" and "Sync" action buttons (only keep "Delete").
- **If `exam.status == 'DOWNLOADED'` or `'IN_PROGRESS'`**: Render the standard "Open" button.

### 2. Manual Sync Trigger and State Management
- **Decision:** Add a `syncExam(int downloadId)` method to `OfflineExamSyncService` and expose `syncExam(int downloadId)` via `offlineExamsProvider` notifier.
- **Rationale:** Triggering sync per exam gives precise feedback for the specific card being synced and allows the button's loading state to reflect progress accurately.

### 3. Disabling Auto-Sync in `SyncManager`
- **Decision:** Remove the `_subscription = _connectivity.onConnectivityChanged.listen(...)` auto-trigger inside `SyncManager`.

## Risks / Trade-offs

- **[Risk] User forgets to sync before an exam's server deadline passes** → *Mitigation:* The `OfflineExamActionButton` on the exam details page and the badge on `OfflineExamsListScreen` already show warning banners when deadlines approach or pass.
- **[Risk] Sync initiated without internet connectivity** → *Mitigation:* Catch network errors in `syncExam()`, show an informative error toast ("Please connect to the internet to sync"), and keep status as `PENDING_SYNC`.
