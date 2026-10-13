## 1. Core PDF Viewer Configuration

- [x] 1.1 Configure `PdfViewerParams` in `packages/courses/lib/widgets/lesson_detail/pdf_viewer.dart`:
  - Set `limitRenderingCache: true`
  - Set `verticalCacheExtent: 0.5` and `horizontalCacheExtent: 0.5`
  - Set `maxImageBytesCachedOnMemory: 48 * 1024 * 1024` (48 MB)
  - Set `onePassRenderingSizeThreshold: 1000`
  - Set `behaviorControlParams` with debouncing (`trailingPageLoadingDelay: 250ms`, `pageImageCachingDelay: 200ms`, `partialImageLoadingDelay: 150ms`)
- [x] 1.2 Remove eager `document.loadPagesProgressively()` call in `_onViewerReady`
- [x] 1.3 Add `WidgetsBindingObserver` to purge image caches on `didHaveMemoryPressure()`
- [x] 1.4 Ensure observer and controller listener removal in `dispose`

## 2. Verification and Testing

- [x] 2.1 Run `flutter analyze` on modified files to verify zero errors or warnings
- [x] 2.2 Run unit and widget tests for PDF viewer
