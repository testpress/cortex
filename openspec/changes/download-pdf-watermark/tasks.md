## 1. Dependency Management

- [x] 1.1 Add `syncfusion_flutter_pdf` to `packages/courses/pubspec.yaml` to enable PDF manipulation (ensure the version matches `syncfusion_flutter_pdfviewer`, e.g., `^33.1.45`).

## 2. Domain Model Updates

- [x] 2.1 Update `LessonDto` in `packages/core` to properly parse the `allow_download` JSON field from the backend.
- [x] 2.2 Update the `Lesson` model in `packages/courses/lib/models/course_content.dart` to include a `final bool allowDownload` field (defaulting to false).
- [x] 2.3 Update the `toDto()` mapping method within the `Lesson` model to map the new `allowDownload` field.
- [x] 2.4 Update `lessonsTable` in `lessons_table.dart` to include `allowDownload` and add a migration in `app_database.dart` (bump `schemaVersion` to 2).

## 3. UI Updates

- [x] 3.1 Modify `AppPdfViewer` in `packages/courses/lib/widgets/lesson_detail/pdf_viewer.dart` to remove the `InstituteSettings.current?.enableCoursePdfWatermarking` check from the `WatermarkOverlay`, ensuring the in-app watermark is always visible.
- [x] 3.2 Update `LessonDetailOrchestrator` to correctly read the `allowDownload` flag from `widget.lesson` and conditionally show the download button in `LessonDetailHeader`.

## 4. Download and Watermark Pipeline

- [x] 4.1 Create a PDF download utility/service that fetches the PDF and uses `syncfusion_flutter_pdf` to permanently draw the watermark onto the document pages.
- [x] 4.2 Ensure the utility saves the final PDF to the user's public device storage (e.g., Downloads folder).
- [x] 4.3 Connect the `onDownload` callback in `LessonDetailOrchestrator` to trigger this new pipeline.
