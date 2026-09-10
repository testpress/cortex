## Why

Attachment and PDF downloads are driven by raw Dio HTTP calls, giving them no pause, resume, or background execution support. When a user navigates away mid-download the transfer is silently abandoned with no way to continue. Video downloads already enjoy full pause/resume via ExoPlayer (Android) and `AVAssetDownloadTask` (iOS) through the TPStreams SDK — attachments should offer the same experience.

## What Changes

- Replace `FileDownloader` (Dio-based) with `background_downloader` for all attachment and PDF downloads.
- `DownloadsService.downloadAttachment()` and `downloadWatermarkedPdf()` are rerouted through a `BackgroundDownloader` task queue instead of Dio.
- `DownloadsRepository.pauseDownload()` and `resumeDownload()` are extended to handle `DownloadType.attachment` alongside the existing video path.
- `DownloadsProvider.pause()` and `resume()` comments/guards updated — they are no longer video-only.
- `AttachmentViewer` and `DownloadsScreen` are updated to show pause/resume controls for in-progress attachments (currently hidden for `DownloadType.attachment`).
- `FileDownloader` (Dio) is retained for thumbnail downloads and any non-resumable internal caching use cases, but is no longer on the public attachment download path.
- PDF watermark flow: raw bytes are still processed in memory via Syncfusion; the download-to-temp-file step is replaced with a `background_downloader` task, so it too gains resumability up to the watermark step.

## Capabilities

### New Capabilities

- `attachment-downloads/pause-resume`: Users can pause and resume attachment downloads. The system persists download progress across app restarts and resumes from the last byte boundary.

### Modified Capabilities

- `offline-persistence`: Attachment download state (paused progress, task ID) must survive app restarts; the DB schema or `DownloadItem` model may need an additional field to track the `background_downloader` task ID.

## Impact

- **New dependency**: `background_downloader` (pub.dev) — requires native Android (WorkManager) and iOS (URLSession background) configuration.
- **Affected files**:
  - `packages/core/lib/data/services/downloads_service.dart` — core logic change
  - `packages/core/lib/data/repositories/downloads_repository.dart` — pause/resume routing
  - `packages/core/lib/data/models/download_item.dart` — possible `taskId` field
  - `packages/core/lib/data/db/tables/downloads_table.dart` — possible schema migration
  - `packages/core/lib/network/file_downloader.dart` — kept for thumbnails only
  - `packages/core/lib/data/services/pdf_downloader.dart` — reroute initial fetch
  - `packages/courses/lib/providers/downloads_provider.dart` — remove video-only guards
  - `packages/courses/lib/screens/downloads_screen.dart` — show pause/resume for attachments
  - `packages/courses/lib/widgets/lesson_detail/attachment_viewer.dart` — show pause/resume UI
  - `android/` and `ios/` — WorkManager and URLSession background mode configuration
