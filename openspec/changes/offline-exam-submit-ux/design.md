## Context

The offline exam feature lets users download an exam, complete it without internet, and have answers sync automatically when connectivity returns. The current state has three gaps:

1. **No immediate feedback on submit**: When the user submits without internet, `endExam()` in `OfflineExamRepository` marks the row `PENDING_SYNC` and emits `ExamAttemptStatus.completed`. The `TestResultView` is shown full-screen — it mentions "saved locally" in body text, but there is no toast-style ephemeral confirmation. Users who quickly close the result modal may miss the message entirely.

2. **List item is static**: `OfflineExamsListScreen` shows every card with a fixed "Downloaded" green badge regardless of status. Once the `SyncManager` detects connectivity and fires `syncPendingExams()`, there is no visible progress in the list — the row is simply deleted on success, causing the card to vanish silently.

3. **Row deleted on sync**: `OfflineExamSyncService` calls `_db.deleteDownload(download.id)` after a successful API response. Users lose the record of having completed the exam; they cannot verify it from the downloads drawer.

## Goals / Non-Goals

**Goals:**
- Show a brief, context-neutral `AppToast` when the user submits an offline exam without internet connectivity.
- Reactively update the exam card badge in `OfflineExamsListScreen` to reflect all statuses: `DOWNLOADED`, `IN_PROGRESS`, `PENDING_SYNC` (syncing indicator), `SYNCED` (tick).
- Retain the download record after sync by marking it `SYNCED` instead of deleting it.
- Add `syncedAt` column to the downloads table to record when sync completed.

**Non-Goals:**
- Real-time progress bar during answer upload.
- Push notifications when sync completes in the background.
- Retry UI controls in the list.
- Any changes to how exam answers are collected or submitted to the API.

## Decisions

### D1: Toast over banner on submit
**Decision:** Show `AppToast` (ephemeral overlay) immediately after `endExam()` emits `completed` in offline mode, rather than relying on the result dialog body text alone.

**Rationale:** The result dialog requires the user to read it before closing; a toast appears over it and auto-dismisses — it is harder to miss and matches the pattern already used for other one-off feedback (e.g., `examDeletedToast`).

**Alternative considered:** Modify `TestResultView` to be more prominent for offline. Rejected — the result view is already correct; the problem is that users can close it before reading it.

### D2: `SYNCED` status rather than deletion
**Decision:** After a successful sync, `OfflineExamSyncService` updates the row status to `SYNCED` and sets `syncedAt` to `DateTime.now()` instead of calling `deleteDownload`.

**Rationale:** Retaining the row gives users a permanent audit trail in the downloads list and prevents confusion when the card disappears unexpectedly. It also allows us to show a "Submitted ✓" badge without any extra state.

**Alternative considered:** Keep deletion but add a separate "synced_log" table. Rejected — unnecessary complexity; the existing row has all needed fields.

### D3: Connectivity check at toast time (not deep)
**Decision:** Use `Connectivity().checkConnectivity()` at the moment the user hits submit (inside `_TestDetailContent`'s `endExam` handler) to decide whether to show the toast. No long-running stream subscription is added to the screen.

**Rationale:** The toast is purely informational. We do not need to watch connectivity changes while on the exam screen. The sync itself is handled by `SyncManager` which already watches connectivity independently.

**Alternative considered:** Check `isOfflineMode` prop only. Rejected — the user could be in offline mode but actually have internet (downloaded earlier). The toast should only appear when internet is actually absent.

### D4: Reactive badge from `watchAllOfflineExams` stream
**Decision:** The existing `offlineExamsProvider` already emits the full list reactively via `watchAllOfflineExams()`. The `_ExamCardHeader` widget will switch badge content based on `exam.status`. No new stream or provider is needed.

**Rationale:** Keeps the change surgical — only the badge rendering in `_ExamCardHeader` changes; the data layer is already reactive.

### D5: DB migration via existing `onUpgrade` pattern
**Decision:** Add `syncedAt` as a nullable `DateTimeColumn` in `OfflineExamDownloadsTable`. The existing `onUpgrade` path in `AppDatabase` iterates `allTables` and creates missing tables; for new columns it uses `ALTER TABLE … ADD COLUMN`. We add an explicit `onUpgrade` step for this column using `m.addColumn(...)`.

**Rationale:** The existing migration strategy only creates missing tables, not missing columns. We need a targeted `addColumn` call for the new `syncedAt` field. Schema version bumps from `1` → `2`.

### D6: `isOfflineOnly` query parameter routing
**Decision:** Pass `?isOffline=true` query parameter when pushing the exam details route from the offline exams list screen. Parse this parameter in the routing configuration and pass it down to `ExamPrescreen`.

**Rationale:** This keeps the pre-screen stateless and allows us to conditionally render the offline-only UI. We hide online attempts tables, retake incorrect options, and standard start buttons.

### D7: Refactor custom button container to `AppButton` core primitive
**Decision:** Replace `ExamPrescreenActionButton`'s custom Container decoration with standard `AppButton` primitives.

**Rationale:** Consolidating on standard core buttons ensures exact design and height alignment across both online and offline pre-screen buttons (conforming to `ai_context.md`).

## Risks / Trade-offs

- **[Risk] Rows accumulate in the SYNCED state** → Mitigation: The "Submitted ✓" badge makes them clearly inert. A future cleanup job (out of scope here) can prune SYNCED rows older than N days. For now the user can still manually delete them.
- **[Risk] `checkConnectivity()` reports stale state** → Mitigation: The toast is purely informational; if connectivity check is wrong, the sync will either succeed (and update the badge) or fail (and badge stays PENDING_SYNC). No data integrity risk.
- **[Risk] Schema migration failure on first launch after update** → Mitigation: `addColumn` with a nullable column is non-destructive and safe for existing rows (they get `null`).

## Migration Plan

1. Bump `schemaVersion` from 1 → 2 in `AppDatabase`.
2. Add explicit `addColumn(offlineExamDownloadsTable, offlineExamDownloadsTable.syncedAt)` in `onUpgrade` when `from < 2`.
3. Existing `PENDING_SYNC` rows already in the DB will continue to sync normally; they will be updated to `SYNCED` on next successful sync instead of deleted.
4. No rollback risk — the column is nullable; reverting the app would simply ignore the column (Drift reads what it knows about).
