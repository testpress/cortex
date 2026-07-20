## 1. Data Layer

- [x] 1.1 Move `UserRepository` and `UserProvider` to the `core` package to properly expose `userProvider` to domain packages.
- [x] 1.2 Expose `enableCoursePdfWatermarking` in `InstituteSettings` parser for the `/api/v2.3/settings/` endpoint.

## 2. UI Implementation

- [x] 2.1 Create `WatermarkOverlay` widget in `packages/courses/lib/widgets/lesson_detail/watermark_overlay.dart`.
- [x] 2.2 Implement watermark using standard Flutter `Text` and `Transform.rotate` widgets.
- [x] 2.3 Update `AppPdfViewer` in `pdf_viewer.dart` to read `userProvider.future` on load.
- [x] 2.4 Add `WatermarkOverlay` inside the `AppPdfViewer` Stack (with `IgnorePointer` handled internally by the overlay widget).
- [x] 2.5 Conditionally render the watermark based on the `InstituteSettings.current?.enableCoursePdfWatermarking` flag.


