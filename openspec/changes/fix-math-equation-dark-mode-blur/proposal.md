## Why

In dark mode, black-ink raster math formula images (e.g., Wiris, CodeCogs, and legacy equations in question content) rendered by `AppHtmlV2` appear dark on dark backgrounds or look blurry when filtered with downsampling/blur approaches. They must be inverted to crisp white text using a hardware-accelerated color matrix while preserving alpha transparency and reactively adapting to theme toggles.

## What Changes

- Apply reactive color inversion (`ColorFilter.matrix`) to math equation images when dark mode is enabled.
- Add structured heuristics in `AppHtmlV2` to identify math equation images via class attributes (`wiris`, `math`, `formula`, `equation`), `role="math"`, LaTeX/MathML data attributes, known math engine URLs, and legacy inline alignment/dimensions.
- Ensure theme toggling between light and dark modes reactively updates formula inversion without re-parsing the HTML document.
- Retain normal rendering for diagrams, general images, and light mode.

## Capabilities

### New Capabilities
- `math-equation-dark-mode-inversion`: Automatic reactive color inversion for raster math equation images in dark mode to ensure high-contrast readability without blur.

### Modified Capabilities
<!-- None -->

## Impact

- Affected code: `packages/core/lib/widgets/app_html_v2.dart` and its test suite `packages/core/test/widgets/app_html_v2_test.dart`.
- No breaking API changes or external dependency updates.

