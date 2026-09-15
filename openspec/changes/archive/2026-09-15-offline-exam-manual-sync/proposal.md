## Why

Automatic background synchronization for offline exams happens silently in the background, leaving users unaware of when their completed exam answers are actually uploaded to the server. When an exam is completed and marked with "Pending Sync", the Offline Exams list currently still shows an "Open" button (which has no meaningful action for a completed exam) instead of empowering the user with an explicit "Sync" action.

This change transitions offline exam synchronization from silent automatic background triggers to explicit user-initiated manual sync on the Offline Exams screen.

## What Changes

- **Manual Sync in Offline Exams List**: On `OfflineExamsListScreen`, for exams in `PENDING_SYNC` state, replace the "Open" action button with a primary "Sync" action button.
- **Sync Action Loading & Feedback**: When the user taps "Sync", disable the button, show an inline loading spinner, trigger `OfflineExamSyncService.syncPendingExams()`, and provide immediate user feedback (success toast or error message).
- **Disable Auto-Sync Triggers**: Remove aggressive automatic background foreground/connectivity sync listeners from `SyncManager` so that syncing is driven with clear user awareness.

## Capabilities

### Modified Capabilities
- `offline-exams-list`: When an exam item has `PENDING_SYNC` status, show a "Sync" action button instead of "Open", with inline loading state and status toast notifications.
- `offline-sync`: Disable automatic background sync on connectivity changes in favor of explicit manual synchronization.

## Impact

- `packages/exams/lib/screens/offline_exams_list_screen.dart`: Update `_ExamCardActions` to render "Sync" button when `exam.status == 'PENDING_SYNC'`.
- `packages/core/lib/data/services/sync_manager.dart`: Stop auto-triggering `syncPendingExams` on connectivity transitions.
- Localization strings in `packages/core/lib/l10n/` for sync action and feedback toasts.
