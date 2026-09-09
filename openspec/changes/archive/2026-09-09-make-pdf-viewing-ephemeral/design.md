## Context

See `proposal.md` for motivation. Currently, `AppPdfViewer` requires a local `File` and relies on `PdfCacheService` to download PDFs to disk before viewing. This creates lingering disk files that inadvertently allow offline access for un-downloaded content.

## Goals / Non-Goals

**Goals:**
- Enable `AppPdfViewer` to render remote PDF URLs directly via `SfPdfViewer.network(url)` with zero disk writes.
- Remove `PdfCacheService` and eliminate all intermediate disk caching for online views.
- Keep `AppPdfViewer.file` support for rendering explicitly downloaded PDFs from `DownloadsProvider`.

**Non-Goals:**
- Change metadata caching in Drift for courses/chapters/lessons.
- Modify the explicit download flow in `DownloadsProvider`.

## Decisions

### Decision 1: Direct `SfPdfViewer.network` Streaming
- **Rationale:** `SfPdfViewer.network` handles remote PDF fetching in memory / native HTTP stream without writing permanent files to the filesystem. When offline, `SfPdfViewer.network` fails naturally, matching expected offline behavior.

### Decision 2: Remove `PdfCacheService`
- **Rationale:** An intermediate disk cache service is redundant and causes offline cache leaks. Removing it simplifies the architecture and eliminates disk pollution.

### Decision 3: Support Both `url` and `file` in `AppPdfViewer`
- **Rationale:** `AppPdfViewer.network(url: ...)` for online streaming and `AppPdfViewer.file(file: ...)` for explicitly downloaded local files.

### Decision 4: Thumbnail Download & Offline Display
- **Rationale:** When downloading content (attachments/PDFs), download the remote thumbnail to internal app storage and save the local path in `DownloadsTable.thumbnailUrl`. In the Downloads screen, render the local image file (or network image if still remote) in `_AttachmentThumbnail` / `_VideoThumbnail`, falling back to the default icon placeholder with clean extension label (e.g. `PDF`) when no thumbnail exists.

### Decision 5: Download Action Placement Separation
- **Rationale:** `LessonType.pdf` displays the download action in the top header (subject to `allowDownload` and offline state). `LessonType.attachment` suppresses the top header button to prevent duplicate UI controls and renders the primary download action within `AttachmentViewer`.

### Decision 6: URL Path Comparison for Stable Network PDF Playback
- **Rationale:** CloudFront pre-signed URLs update query parameters (signatures and expiration timestamps) on lesson detail refreshes. `AppPdfViewer` compares URI scheme, host, and path in `didUpdateWidget` and uses a lesson-keyed widget rather than query string keys, eliminating unnecessary reloads, state disposal, and double-loading flashes.

## Risks / Trade-offs

- **[Risk] Network-dependent rendering for online views:** If network drops during initial load of an un-downloaded PDF, loading fails.
  - **Mitigation:** Expected behavior for un-downloaded online content; displays the standard error state with retry.
