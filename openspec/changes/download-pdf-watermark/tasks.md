## 1. Dependency Management

- [x] 1.1 Add `syncfusion_flutter_pdf` to `packages/core/pubspec.yaml` to enable PDF manipulation in the core data layer.

## 2. Domain Model & DB Updates

- [x] 2.1 Update `LessonDto` to parse `allow_download` and `watermark_before_download` JSON fields.
- [x] 2.2 Update the `Lesson` model to include `allowDownload` and `watermarkBeforeDownload` fields (defaulting to false).
- [x] 2.3 Add `allowDownload` and `watermarkBeforeDownload` columns to `lessonsTable`.
- [x] 2.4 Add `filePath` to `DownloadItem` to track absolute paths for title-based PDF downloads.

## 3. UI Updates

- [x] 3.1 Modify `AppPdfViewer` to remove the legacy `InstituteSettings` check from `WatermarkOverlay`.
- [x] 3.2 Update `LessonDetailOrchestrator` to read the `allowDownload` flag and conditionally show the download button.
- [x] 3.3 Create `DownloadProgressBanner` to provide visual feedback during the isolate processing and download.

## 4. Download and Watermark Pipeline

- [x] 4.1 Create `PdfDownloader` in `packages/core` to handle raw HTTP fetching, background isolate watermarking via `syncfusion_flutter_pdf`, and public storage saving.
- [x] 4.2 Update `DownloadsRepository` to use `PdfDownloader` for PDFs, leveraging a title-based path naming strategy with sequential gap-filling for multiple downloads.
- [x] 4.3 Update `DownloadsService` with `getExistingPdfSize()` to reconcile UI state with actual files on disk to fix "ghost file" bugs.
- [x] 4.4 Fix UI flicker by modifying `PdfCacheRequest` equality to ignore signed URLs so CDN expirations do not reload the viewer.
