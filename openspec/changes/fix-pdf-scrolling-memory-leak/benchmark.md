# Verification & Performance Metrics

This document provides empirical verification and device memory benchmarks for change `fix-pdf-scrolling-memory-leak`.

> **Note:** The telemetry logs below were captured using temporary local debug instrumentation that was removed prior to commit to avoid console noise in production.

---

## 1. Static Analysis & Unit Tests

### Static Analysis
```bash
$ flutter analyze packages/courses/lib/widgets/lesson_detail/pdf_viewer.dart
Analyzing pdf_viewer.dart...
No issues found! (ran in 3.2s)
```

### Unit & Widget Tests
```bash
$ cd packages/courses && flutter test test/widgets/pdf_viewer_test.dart
00:02 +11: All tests passed!
```
- Total tests: 11 passed, 0 failed, 0 skipped.
- Covers URL comparison stability, file resource identity, and scroll thumb pill semantics across diverse page counts.

---

## 2. On-Device Memory Profiling

### Test Environment
- **Primary Device**: Physical Android Tablet (TB310FU, 4 GB RAM, Android 13)
- **Document Under Test**: 45-page high-resolution slide deck (`GRAVITATION LIVE PART - 02 PDF.pdf`, raster-dense presentation export)
- **Interaction Profile**: Continuous scrolling from page 1 to 45, followed by aggressive bidirectional flinging and jumping between pages 45 and 1 multiple times.

---

### Comparative Memory Benchmark

| Metric | Before Fix (Crash Baseline) | After Fix (Current Implementation) | Result |
|---|---|---|---|
| **Peak Process RSS** | **2,196.4 MB** | **456.8 MB** | **-79.2% (-1.74 GB)** |
| **Rapid Reverse Scroll RSS** | Climbed from 709 MB to 2,196 MB | Remained stable between 360–430 MB | **No texture pileup** |
| **Document Exit RSS** | N/A (Process killed by OS) | **374.2 MB** | **Cleanly disposed** |
| **Consecutive Documents** | Terminated on 1st document | Loaded 3 heavy slide decks back-to-back | **Stable baseline (~600–700 MB total app RSS)** |
| **Android LMK Signals** | Repeated `TRIM_MEMORY` warnings | No observed `TRIM_MEMORY` in logcat | **Process never entered critical threshold** |
| **Stability Outcome** | **Fatal SIGKILL by `lmkd`** | **No lmkd kill, smooth rendering** | **PASS** |

---

### Telemetry Logs Comparison

#### Baseline (Before Fix — Fatal OOM via Android `lmkd`)
```text
I/flutter ( 1803): [PDF_DEBUG] [VIEWER_READY] totalPages: 45
I/flutter ( 1803): [PDF_DEBUG] [SCROLL] Page: 45 / 45 (100.0%) | Memory RSS: 709.6 MB
I/flutter ( 1803): [PDF_DEBUG] [SCROLL] Page: 34 / 45 (75.6%)  | Memory RSS: 1469.5 MB
I/flutter ( 1803): [PDF_DEBUG] [SCROLL] Page: 27 / 45 (60.0%)  | Memory RSS: 1761.2 MB
I/flutter ( 1803): [PDF_DEBUG] [SCROLL] Page: 25 / 45 (55.6%)  | Memory RSS: 1827.8 MB
I/flutter ( 1803): [PDF_DEBUG] [CRITICAL_RAM_ALERT] Page: 18 / 45 | RSS: 2088.2 MB (DANGER: OS MAY KILL PROCESS)
I/flutter ( 1803): [PDF_DEBUG] [OS_LOW_MEMORY_PRESSURE] Android OS sent TRIM/LOW_MEMORY signal! Process kill imminent! RSS: 2153.8 MB
I/flutter ( 1803): [PDF_DEBUG] [CRITICAL_RAM_ALERT] Page: 18 / 45 | RSS: 2196.4 MB (DANGER: OS MAY KILL PROCESS)
--> Process 1803 abruptly terminated by Android Low Memory Killer (SIGKILL)
```

#### Verification Run (After Fix — Same Document & Scrolling Actions)
```text
I/flutter ( 5130): [PDF_DEBUG] [VIEWER_READY] totalPages: 45
I/flutter ( 5130): [PDF_DEBUG] [SCROLL] Page: 1 / 45 (2.2%)    | Memory RSS: 351.5 MB
I/flutter ( 5130): [PDF_DEBUG] [SCROLL] Page: 24 / 45 (53.3%)  | Memory RSS: 359.5 MB
I/flutter ( 5130): [PDF_DEBUG] [SCROLL] Page: 45 / 45 (100.0%) | Memory RSS: 359.5 MB
I/flutter ( 5130): [PDF_DEBUG] [SCROLL] Page: 35 / 45 (77.8%)  | Memory RSS: 392.4 MB  <-- rapid fling reverse
I/flutter ( 5130): [PDF_DEBUG] [SCROLL] Page: 18 / 45 (40.0%)  | Memory RSS: 405.3 MB
I/flutter ( 5130): [PDF_DEBUG] [SCROLL] Page: 9 / 45 (20.0%)   | Memory RSS: 456.8 MB  (Peak)
I/flutter ( 5130): [PDF_DEBUG] [SCROLL] Page: 1 / 45 (2.2%)    | Memory RSS: 421.1 MB
I/flutter ( 5130): [PDF_DEBUG] [DISPOSE] AppPdfViewer dispose() called cleanly | Final RSS: 374.2 MB
```

---

## 3. Key Findings

1. **Likely Contributing Factors**: Rapid reverse scrolling triggered native texture pileup: PDFium allocated monolithic uncompressed single-pass textures for each slide export faster than off-screen textures could be collected.
2. **Effectiveness of Tiling (`onePassRenderingSizeThreshold: 1500`)**: Lowering the threshold forces `pdfrx` to slice high-res slides into visible screen tiles rather than holding multiple full-size multi-megapixel bitmaps in RAM, while preserving seamless single-pass rendering for standard portrait text pages.
3. **Effectiveness of Throttling**: Restoring 150–250ms debounce delays in `behaviorControlParams` prevents the engine from decoding intermediate pages skipped during velocity flings.
