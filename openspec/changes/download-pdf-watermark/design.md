## Context

Currently, the `AppPdfViewer` allows users to view PDFs, but there is no mechanism for users to download them. We need to introduce a conditional download flow dependent on an `allow_download` property in the backend response.

## Goals / Non-Goals

**Goals:**
- Implement a download flow that saves the PDF to the device.
- Update `Lesson` and `LessonDto` models to parse and store the `allowDownload` property.
- Conditionally render a download button in the `LessonDetailHeader` based on `allowDownload`. 
- *Cleanup*: Remove the `enableCoursePdfWatermarking` check from the in-app `AppPdfViewer` overlay so the overlay always renders.

**Non-Goals:**
- Changing the watermarking style (font, opacity) or text in-app.
- Modifying how other attachments (non-PDF) are downloaded.

## Decisions

- **Domain Model Changes**: Add `final bool allowDownload` to `LessonDto` and `Lesson` with a default of `false` to prevent unwanted downloads. Also add this to `lessons_table.dart` for offline-first architecture support.
- **UI Logic**: `LessonDetailOrchestrator` will pass `allowDownload` to `LessonDetailHeader`. The header will hide the download action entirely if false.
- **PDF Watermarking Engine**: We will utilize PDF manipulation capabilities to draw text onto the pages of the downloaded document. Adding the `syncfusion_flutter_pdf` package is the most cohesive approach, given `syncfusion_flutter_pdfviewer` is already in use.
- **Cleanup - In-App Watermark**: As a minor cleanup task, the existing `WatermarkOverlay` usage inside `AppPdfViewer` will be updated to drop the `InstituteSettings.current?.enableCoursePdfWatermarking` condition, making the overlay always visible in-app.

## Risks / Trade-offs

- **Risk: Memory limits when watermarking large PDFs on-device.**
  - *Mitigation*: We will perform the watermarking operation in a background isolate (if needed) and ensure efficient read/write operations to prevent UI thread blocking or Out-Of-Memory (OOM) crashes.
- **Risk: Package version conflicts.**
  - *Mitigation*: Ensure the version of `syncfusion_flutter_pdf` added exactly matches the existing `syncfusion_flutter_pdfviewer` version (`^33.1.45`).

## Migration Plan
- Bump `schemaVersion` to 2 and add `allowDownload` column to `lessonsTable` via Drift migration.
- Existing cached PDFs without watermarks will continue to work normally for in-app viewing. Any new downloads will go through the watermarking pipeline.

## Open Questions
- Is `syncfusion_flutter_pdf` the approved package to add for PDF manipulation, or is there an existing internal service for stamping watermarks on downloads?
