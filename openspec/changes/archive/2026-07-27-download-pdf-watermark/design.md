## Context

Currently, the `AppPdfViewer` allows users to view PDFs, but there is no mechanism for users to download them. We need to introduce a conditional download flow dependent on an `allow_download` property in the backend response, and a dynamic watermarking flow based on `watermark_before_download`.

## Goals / Non-Goals

**Goals:**
- Implement a download flow that saves the PDF to the device public storage.
- Update `Lesson` and `LessonDto` models to parse and store the `allowDownload` and `watermarkBeforeDownload` properties.
- Conditionally render a download button in the `LessonDetailHeader` based on `allowDownload`.
- Support offline watermarking by processing the PDF through a dedicated `PdfDownloader` utility in `packages/core`.
- *Cleanup*: Remove the legacy `enableCoursePdfWatermarking` check from the in-app `AppPdfViewer` overlay so the overlay always renders.

**Non-Goals:**
- Changing the watermarking style (font, opacity) or text in-app.
- Modifying how other attachments (non-PDF) are downloaded.

## Decisions

- **Domain Model Changes**: Add `final bool allowDownload` and `final bool watermarkBeforeDownload` to `LessonDto` and `Lesson` (defaulting to `false`). Add both to `lessons_table.dart` (Schema v2) for offline support.
- **UI Logic**: `LessonDetailOrchestrator` will conditionally show the download button based on `allowDownload`.
- **Downloads Tab Visibility**: PDF Lessons shall not be displayed in the in-app Downloads screen. This screen is reserved exclusively for Videos and Attachments, while PDF lessons are managed via the course syllabus.
- **PDF Download Engine**: Create a robust `PdfDownloader` in `packages/core` that downloads the raw PDF, optionally processes it via `syncfusion_flutter_pdf` in an isolate to stamp the user's name if `watermarkBeforeDownload` is true, and saves the final file to the public Downloads folder.
- **Repository Integration**: Connect the `PdfDownloader` into `DownloadsRepository` under the `attachment` download type, using a title-based file path naming strategy (`$title.pdf`). Multiple clicks will download duplicates sequentially (e.g. `$title-1.pdf`), filling any numerical gaps if the user deletes intermediate files.
- **Bug Fix**: Modify `PdfCacheRequest` to ignore signed `url` parameters during equality checks to stop flickering in the UI caused by CDN signature expirations.
- **Cleanup**: Drop the `InstituteSettings.current?.enableCoursePdfWatermarking` condition in `AppPdfViewer`.

## Risks / Trade-offs

- **Risk: Memory limits when watermarking large PDFs on-device.**
  - *Mitigation*: The `PdfDownloader` performs the watermarking operation in a background isolate to prevent UI thread blocking or Out-Of-Memory (OOM) crashes.
- **Risk: Package version conflicts.**
  - *Mitigation*: Use `syncfusion_flutter_pdf` matching the existing `syncfusion_flutter_pdfviewer` version.

## Migration Plan
- Add `allowDownload` and `watermarkBeforeDownload` columns to `lessonsTable`.
- Existing cached PDFs without watermarks will continue to work normally for in-app viewing. Any new downloads will go through the watermarking pipeline.

## Open Questions
- None.
