## Why

When viewing PDF lessons online, the system currently forces a full file download to disk via `PdfCacheService` before mounting the viewer, leaving lingering files on disk. When the device goes offline, non-downloaded PDF lessons that were previously viewed can still be opened via these lingering disk files, while other non-downloaded content throws unexpected network errors.

We need to make online PDF lesson viewing direct and network-streamed via `SfPdfViewer.network`, eliminating intermediate disk caching for online views while ensuring persistent offline access is strictly reserved for explicitly downloaded content.

## What Changes

- **Direct Network PDF Rendering**: Update `AppPdfViewer` to render remote PDF URLs directly using `SfPdfViewer.network(url)` without writing any files to local disk.
- **Remove Intermediate Disk Caching**: Delete `PdfCacheService` and remove `pdfFileProvider` and `_prefetchPdfLesson` calls from `lessonDetailProvider`.
- **Support Local Files for Explicit Downloads**: Update `AppPdfViewer` to accept either a remote `url` (using `SfPdfViewer.network`) or a local `file` (using `SfPdfViewer.file`) for explicitly downloaded content.
- **Consistent Offline Behavior**: Un-downloaded PDFs will have no files on disk, naturally failing network requests and presenting connection/offline error messaging when offline.
- **Differentiated Download Button Placement**: PDF lessons display the download button in the top header (when `allowDownload == true` and not yet downloaded), while attachment lessons display the download action in the center inside `AttachmentViewer` (avoiding duplicate buttons in the top header).
- **Stable PDF Rendering across Signed URL Refreshes**: `AppPdfViewer` identifies resources by scheme, host, and path in `didUpdateWidget`, preventing disruptive re-renders and double-loading when pre-signed CloudFront query parameters (timestamps and signatures) refresh.
- **Thumbnail Persistence & Clean Fallbacks**: Download and persist thumbnails alongside items, displaying thumbnails in the downloads list and falling back to a clean file icon with extension label (e.g., `PDF`) when no thumbnail exists.

## Capabilities

### New Capabilities
*(None)*

### Modified Capabilities
- `lesson-background-caching`: Remove silent background prefetching and disk caching of PDF files for un-downloaded lessons.
- `lesson-pdf-playback`: Render online PDF lessons directly from network URL via `SfPdfViewer.network`, reserving local file rendering exclusively for explicit downloads.

## Impact

- `packages/courses/lib/widgets/lesson_detail/pdf_viewer.dart`: Refactor `AppPdfViewer` to support `url` and `file` directly with stable URL path comparison.
- `packages/courses/lib/screens/lesson_detail_orchestrator.dart`: Directly pass `lesson.contentUrl` to `AppPdfViewer`, manage top download button exclusively for PDF lessons.
- `packages/courses/lib/widgets/lesson_detail/attachment_viewer.dart`: Manage download action with thumbnail metadata.
- `packages/courses/lib/providers/downloads_provider.dart`: Manage watermarked PDF downloads with thumbnail metadata and clean file types.
- `packages/courses/lib/screens/downloads_screen.dart`: Render thumbnails and file type fallbacks.
- `packages/courses/lib/utils/pdf_cache_service.dart`: Remove unused file.
- `packages/core/lib/data/repositories/downloads_repository.dart`: Manage watermarked PDF downloads and thumbnail caching.
