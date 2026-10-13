## Context

In `packages/courses/lib/widgets/lesson_detail/pdf_viewer.dart`, the PDF viewer (`pdfrx` / `PdfViewer.uri`) was configured with:
- `limitRenderingCache: false`
- `verticalCacheExtent: 4.0`
- `maxImageBytesCachedOnMemory: 256 * 1024 * 1024`
- `onePassRenderingSizeThreshold: 3500`
- `trailingPageLoadingDelay: Duration.zero`
- `pageImageCachingDelay: Duration.zero`
- `partialImageLoadingDelay: Duration.zero`
- `document.loadPagesProgressively()` called on viewer ready

When reading image-dense slide exports or multi-page course materials on Android, PDFium allocates native raster buffers for each rendered page without an eviction cap. When zero debouncing delays and an aggressive progressive loader are enabled, rapid bidirectional scrolling floods the worker with concurrent decode tasks, pushing RSS up to ~2.2 GB and triggering Android low memory killer (`lmkd`) termination.

## Goals / Non-Goals

**Goals:**
- Eliminate out-of-memory app crashes and unconstrained memory spikes during continuous and rapid scrolling.
- Keep process RSS bounded and stable under ~500 MB while scrolling.
- Prevent thread starvation and frame drops by restoring debounce delays on page caching.
- Cleanly manage controller and widget lifecycles.

**Non-Goals:**
- Replacing `pdfrx` or the underlying native PDFium engine.
- Altering offline downloads, passwords, watermark overlays, or UI controls.
- Clearing Flutter global image cache (as `pdfrx` uses native PDFium raster buffers directly).

## Decisions

1. **Enable PDFium native image cache bounding (`limitRenderingCache: true`)**:
   - *Rationale*: Passing `limitRenderingCache: true` enables `FPDF_RENDER_LIMITEDIMAGECACHE` in PDFium, allowing off-screen decompressed bitmap caches to be collected.

2. **Calibrate Viewport Cache Extent and Tile Threshold**:
   - *Rationale*:
     - `verticalCacheExtent: 0.5` and `horizontalCacheExtent: 0.5`: Pre-buffers half a screen ahead and behind, avoiding hoarding dozens of decoded pages simultaneously.
     - `maxImageBytesCachedOnMemory: 48 * 1024 * 1024` (48 MB): Enforces a sensible cache budget before evicting off-screen bitmaps.
     - `onePassRenderingSizeThreshold: 1500`: Slices heavy slide decks into tiles rather than drawing single monolithic multi-megapixel textures, slashing per-page peak RAM.

3. **Restore Throttling Delays in `PdfViewerBehaviorControlParams`**:
   - *Rationale*: Setting delays to `Duration.zero` launched heavy decode jobs for every page passed during rapid flings. Using debounce delays (`trailingPageLoadingDelay: 250ms`, `pageImageCachingDelay: 200ms`, `partialImageLoadingDelay: 150ms`) ensures intermediate flinging pages are skipped until scroll velocity slows down.

4. **Remove `document.loadPagesProgressively()` Background Call**:
   - *Rationale*: `pdfrx` already resolves and streams page content on-demand through its virtualized viewport. The background eager loop competed with the UI thread for CPU cycles and queued unnecessary decodes.

## Risks / Trade-offs

- **[Cache eviction re-decode overhead]**: Enabling `limitRenderingCache: true` instructs PDFium to aggressively release decompressed bitmap caches for off-screen pages.
  → *Trade-off*: Rapid back-and-forth scrolling may incur occasional CPU re-decode overhead as pages re-enter the viewport, but this is an intentional compromise that prevents fatal native OOM terminations (`lmkd` SIGKILL).
- **[Page rendering on fast fling]**: Debounce delays mean pages during high-speed flings show preview frames until scroll deceleration.
  → *Mitigation*: Standard reading speeds remain seamless and crisp while preventing fatal OS process termination.
