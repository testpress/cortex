## 1. Refactor AppPdfViewer for Direct Network Streaming
 
 - [x] 1.1 Refactor `AppPdfViewer` in `packages/courses/lib/widgets/lesson_detail/pdf_viewer.dart` to support both `url` (via `SfPdfViewer.network`) and `file` (via `SfPdfViewer.file`).
 - [x] 1.2 Update `didUpdateWidget` and `_isSameResource` to compare URI scheme, host, and path to prevent double-loading on pre-signed query token refreshes.
 - [x] 1.3 Update `_PdfLessonViewer` / `LessonDetailOrchestrator` in `packages/courses/lib/screens/lesson_detail_orchestrator.dart` to key widgets by `lesson.id` and pass `lesson.contentUrl` directly.

## 2. Download Button Placement & Lifecycle

 - [x] 2.1 Display the top header download button only for `LessonType.pdf` when `allowDownload == true && !isDownloaded`.
 - [x] 2.2 Suppress the top header download button for `LessonType.attachment`, rendering the download action exclusively inside `AttachmentViewer`.
 - [x] 2.3 Ensure the download button reappears when a downloaded file is deleted.

## 3. Remove Redundant Disk Cache Layer

 - [x] 3.1 Delete `packages/courses/lib/utils/pdf_cache_service.dart`.
 - [x] 3.2 Clean up any remaining references to `pdfCacheServiceProvider` or `pdfFileProvider`.

## 4. Thumbnail Download and Display in Downloads List

 - [x] 4.1 Download and persist lesson/attachment thumbnail along with download item in `DownloadsRepository` / `DownloadsService`.
 - [x] 4.2 Update `_AttachmentThumbnail` and `_VideoThumbnail` in `downloads_screen.dart` to display local/network thumbnail image when present with fallback to clean file icon and `PDF` extension label.
 - [x] 4.3 Ensure `LessonDto.image` / lesson details image is passed to `DownloadItem.thumbnailUrl` in `startPdfLessonDownload` and `AttachmentViewer`.

## 5. Verification & Testing

 - [x] 5.1 Verify online PDF viewing renders via `SfPdfViewer.network` without writing files to local disk.
 - [x] 5.2 Verify that offline viewing of un-downloaded PDFs correctly displays connection error without falling back to cached files.
 - [x] 5.3 Verify downloaded items (attachments/PDFs/videos) show their thumbnail image in the Downloads screen (online and offline), falling back gracefully when no thumbnail exists.
 - [x] 5.4 Run `flutter analyze` and `flutter test` across `packages/courses` and `packages/core`.
