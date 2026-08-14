## 1. Setup

- [x] 1.1 Add `no_screenshot` dependency to `packages/courses/pubspec.yaml`
- [x] 1.2 Run `flutter pub get` in `packages/courses`

## 2. Implementation

- [x] 2.1 Import `no_screenshot` and `overlay_mode` in `packages/courses/lib/widgets/lesson_detail/pdf_viewer.dart`
- [x] 2.2 Wrap the `SfPdfViewerTheme` in `AppPdfViewer`'s `build` method with `SecureWidget(mode: OverlayMode.secure)`
