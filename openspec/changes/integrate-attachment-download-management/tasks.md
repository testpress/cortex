## 1. Data Models & Utilities

- [x] 1.1 Add `copyWith` extension to `DownloadItem` (`packages/core/lib/data/models/download_item.dart`) to support immutable state updates for progress tracking.
- [x] 1.2 Add `contentUrl` to `DownloadItem` to natively track attachment URLs for DB-free deletion.
- [x] 1.3 Update `DownloadsTable` and `AppDatabase` schema to include `contentUrl` and increment `schemaVersion`.
- [x] 1.4 In `TimeFormatter` (`packages/core/lib/utils/time_formatter.dart`), implement `timeAgo()` to convert ISO-8601 strings into human-readable relative formats (e.g., "Just now", "2 minutes ago").

## 2. Service Layer — Pure Worker

- [x] 2.1 In `DownloadsService` (`packages/core/lib/data/services/downloads_service.dart`), remove `ProviderRef` constructor injection. The service must have no knowledge of `DownloadsRepository`.
- [x] 2.2 Replace `startAttachmentDownload(DownloadItem, url)` with `downloadAttachment(url, {onProgress})` — a pure HTTP worker method that fires progress via a callback. Returns the local file path on success.
- [x] 2.3 Refactor `deleteDownloadItem(DownloadItem item)` to purely use `item.contentUrl` for physical file deletion, eliminating DB lookups inside the service.
- [x] 2.4 Add stub methods for TPStreams SDK operations (`pauseVideoDownload`, `resumeVideoDownload`, `deleteVideoDownload`, `getActiveVideoDownloads`) with `// TODO: Replace with TPStreamsDownloadManager` comments.

## 3. Repository Layer — Orchestrator

- [x] 3.1 In `DownloadsRepository` (`packages/core/lib/data/repositories/downloads_repository.dart`), inject `DownloadsService` via the constructor (already done). Ensure no circular reference — the service must NOT read the repository back.
- [x] 3.2 Implement `startAttachmentDownload(DownloadItem item, String url)` in `DownloadsRepository`. This method owns the full lifecycle:
  - Insert initial `DownloadStatus.downloading` row to DB.
  - Call `_service.downloadAttachment(url, onProgress: ...)` and upsert progress to DB on each callback.
  - On success: upsert `DownloadStatus.completed` with final file size.
  - On error: upsert `DownloadStatus.error`.

## 4. Provider Layer — Downloads Notifier

- [x] 4.1 In `downloads_provider.dart` (`packages/courses/lib/providers/downloads_provider.dart`), convert from scattered functional providers to a single `Downloads` `AsyncNotifier` class, following the same pattern as the `Auth` notifier in `auth_provider.dart`.
- [x] 4.2 The `Downloads` notifier `build()` method should expose a `Stream<List<DownloadItem>>` from `DownloadsRepository.watchAllDownloads()`.
- [x] 4.3 Add action methods to the notifier: `startAttachmentDownload(DownloadItem, url)`, `pause(id)`, `resume(id)`, `delete(DownloadItem)`, `synchronize()` — all delegating to `DownloadsRepository`.

## 5. UI Refactoring

- [x] 5.1 In `AttachmentViewer` (`packages/courses/lib/widgets/lesson_detail/attachment_viewer.dart`), update `_startDownload` to call `ref.read(downloadsProvider.notifier).startAttachmentDownload(item, widget.url)`. Remove direct usage of `downloadsServiceProvider`.
- [x] 5.2 Update `_openFile` in `AttachmentViewer` to keep using `fileDownloaderProvider.getLocalPath` (no change needed here, this is fine).
- [x] 5.3 Update the Downloads Screen (`packages/courses/lib/screens/downloads_screen.dart`) to use `ref.watch(downloadsProvider)` and `ref.read(downloadsProvider.notifier).synchronize()` via the new notifier.
- [x] 5.4 In `DownloadsScreen`, hide pause/resume actions for attachments since `Dio` does not natively support resumable downloads.
- [x] 5.5 In `DownloadsScreen`, make `_DownloadCard` entirely clickable so users can directly open completed attachments.
- [x] 5.6 In `DownloadsScreen`, update date formatting to use `DateFormatter.formatDateTime` for exact time display.
