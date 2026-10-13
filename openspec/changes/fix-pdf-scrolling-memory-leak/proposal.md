## Why

Continuous scrolling through high-resolution slide PDFs on Android causes unbounded native heap growth (exceeding 2.1 GB RSS), triggering Android's low memory killer (lmkd) to terminate the app process with SIGKILL. This is caused by unlimited rendering caches (`limitRenderingCache: false`), massive image cache allowances (256 MB), high single-pass texture dimensions (3500px), zero-delay decoding on flings, and an eager background progressive page loader running upon document ready.

## What Changes

- Enable PDFium native image cache bounding (`limitRenderingCache: true`) in `PdfViewerParams` so native raster buffers are released as pages scroll out of view.
- Reduce `verticalCacheExtent` and `horizontalCacheExtent` to `0.5` viewport heights to pre-render only immediately adjacent content.
- Lower `onePassRenderingSizeThreshold` from 3500 to 1500 to tile high-res slides rather than allocating giant monolithic textures.
- Set `maxImageBytesCachedOnMemory` to 48 MB.
- Introduce debounce delays in `behaviorControlParams` (`trailingPageLoadingDelay: 250ms`, `pageImageCachingDelay: 200ms`, `partialImageLoadingDelay: 150ms`) to skip intermediate decodes during rapid flinging.
- Remove eager background `document.loadPagesProgressively()` invocation from `_onViewerReady`.

## Capabilities

### Modified Capabilities
- `lesson-pdf-playback`: Add requirement for memory-bounded PDF rendering, tiled high-res presentation rendering, and scroll throttling.

## Impact

- Affects `packages/courses/lib/widgets/lesson_detail/pdf_viewer.dart`.
- Preserves smooth scrolling and zoom performance while capping resident memory to ~350–450 MB RSS during continuous reading and rapid bidirectional flinging across slide decks.
