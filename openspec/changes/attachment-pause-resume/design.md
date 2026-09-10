## Context

The codebase has a clean two-layer download architecture:

```
DownloadsProvider  (courses package — UI actions)
    └── DownloadsRepository  (core — DB + lifecycle orchestration)
          └── DownloadsService  (core — worker, SDK calls)
                ├── TPStreamsDownloadManager  → video (pause/resume already works)
                └── FileDownloader (Dio)      → attachments (no pause/resume)
```

`DownloadsRepository.pauseDownload()` and `resumeDownload()` exist but delegate exclusively to `_service.pauseVideoDownload()` / `resumeVideoDownload()`. The UI in `DownloadsScreen` and `downloads_provider.dart` explicitly gates pause/resume behind `item.type == DownloadType.video`.

The `DownloadsTable` stores `statusIndex`, `progress`, `filePath`, and `contentUrl` — enough to reconstruct a download record — but has no `taskId` column, which is needed for the download manager to reattach to a paused/backgrounded task after an app restart.

See `proposal.md` for motivation.

---

## Goals / Non-Goals

**Goals:**
- Pause and resume work for `DownloadType.attachment` (regular files and PDFs) through the same repository interface that already serves video.
- A `taskId` column in `DownloadsTable` ties each attachment record to its `background_downloader` task, surviving process death.
- `DownloadsScreen` and `AttachmentViewer` show pause/resume controls for attachments with no fork in the UI logic.
- `FileDownloader` (Dio) continues to serve thumbnail and internal-cache downloads — it is not removed.

**Non-Goals:**
- Video download engine is untouched.
- PDF watermarking logic (Syncfusion, in-memory) is unchanged; only the initial fetch step is rerouted.
- Push / system tray download progress notifications are out of scope.
- Retry-on-failure automation is out of scope (user-initiated resume covers this).

---

## Decisions

### Decision 1 — Use `background_downloader` instead of rolling HTTP Range support on top of Dio

`background_downloader` wraps Android WorkManager and iOS URLSession background tasks — the same OS primitives used by browsers and system download managers. It handles byte-range resumption, background execution budget, and partial-file management internally.

Rolling this on top of Dio would require: storing byte offsets per task, appending to partial files, managing open/close on pause, handling OS background termination signals, and testing across SDK versions. `background_downloader` ships this already.

**Alternatives considered:**
- `flutter_downloader` — wraps Android `DownloadManager`, which does not support custom auth headers or query-string-signed CDN URLs reliably. Ruled out.
- Manual Dio Range requests — full control but significant complexity with no background execution. Ruled out.

### Decision 2 — Add a nullable `taskId` column to `DownloadsTable`

`background_downloader` assigns a stable string task ID to each download. Without persisting this, a cold-start app cannot reconnect the in-memory manager to an in-flight transfer. The column is nullable so existing rows and video rows are unaffected.

This requires a Drift schema migration (version bump + `addColumn`). The migration is non-destructive — existing rows simply get `NULL` for `taskId`.

**Alternatives considered:**
- Store task ID only in memory — breaks resume after process death. Ruled out.
- Store task ID in `SharedPreferences` keyed by content URL — works but creates a second source of truth outside the DB. Ruled out.

### Decision 3 — Route attachment pause/resume through the existing `DownloadsRepository` interface

`DownloadsRepository.pauseDownload(id)` and `resumeDownload(id)` already exist. We extend them to be type-aware:

```
pauseDownload(id):
  if item.type == video → _service.pauseVideoDownload(id)
  if item.type == attachment → _service.pauseAttachmentDownload(id)
```

`DownloadsProvider.pause()` and `resume()` need no signature change — only the "video only" doc comment is removed. The UI switch in `DownloadsScreen._handleAction()` loses the `DownloadType.video` guard.

### Decision 4 — PDF initial fetch goes through `background_downloader`; watermark step stays in-process

The PDF download pipeline is: fetch raw bytes → apply watermark in `compute()` → save to public storage. Only the fetch step benefits from resumability. The watermark step (Syncfusion, in memory) is instantaneous relative to download time and cannot be checkpointed, so it stays as-is.

Concretely: `PdfDownloader.downloadAndWatermark()` replaces `_fileDownloader.downloadToPath()` with a `background_downloader` task that saves to a temp path, then the existing watermark logic reads from that path.

### Decision 5 — `DownloadItem` gains an optional `taskId` field

Adding `taskId` to the model keeps it the single source of truth for a download's full state. It is nullable and defaults to `null` for video items, which have no need for it.

---

## Risks / Trade-offs

- **Server must support HTTP Range** — If the CDN does not send `Accept-Ranges: bytes`, `background_downloader` will restart from zero on resume. The fallback is a fresh download, which is no worse than current behaviour. Risk: low (S3/CloudFront default to range support).

- **Drift migration** — Adding a nullable column is safe, but requires a schema version bump and a migration block. Risk: low if migration is written correctly; test on a device with existing data.

- **PDF partial download on pause** — Pausing mid-PDF before the watermark step leaves a partial temp file. On resume the partial file is cleaned up by `background_downloader` and re-fetched from the saved offset. The watermark step only runs after a complete fetch. No data corruption risk.

- **Background execution limits (iOS)** — iOS URLSession background tasks can be throttled by the OS. The download will complete eventually but the progress update to the UI may lag until the app returns to foreground. This matches the behaviour of iOS video downloads via AVAssetDownloadTask.

- **Concurrent downloads** — `background_downloader` supports a task queue. We do not impose a per-user concurrency limit in this change; this can be added later via `DownloadsService`.

---

## Migration Plan

No migration required — the app has not been deployed to production. `schemaVersion` stays at `1` and `onCreate` calls `createAll()`, which picks up the new `taskId` column automatically on fresh installs.

If/when the app ships to production before this change lands, bump `schemaVersion` to `2` and add `m.addColumn(downloadsTable, downloadsTable.taskId)` in the `onUpgrade` block.

---

## Open Questions

- **Signed URL expiry on resume**: If attachment URLs are short-lived signed CDN URLs (e.g. AWS presigned URLs), they may expire before the user resumes a paused download. In that case, `DownloadsRepository.resumeDownload()` may need to re-fetch a fresh URL from the API before handing it to the download manager. This is not scoped here — if URLs expire, a follow-up change should add URL refresh logic.
