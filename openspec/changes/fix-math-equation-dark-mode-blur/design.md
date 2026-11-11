## Context

In LMS assessments and course material, math questions frequently contain raster equation images (e.g. Wiris formula PNGs, CodeCogs images, legacy GIF formulas). In light mode, these black-ink images render cleanly against white/light backgrounds. In dark mode, without intervention, black text is barely readable against dark backgrounds. Applying CSS-style blur or downsampling filters causes thin math glyphs, fraction bars, and exponents to become blurry and unreadable.

## Goals / Non-Goals

**Goals:**
- Invert black formula text to crisp white in dark mode using `ColorFilter.matrix` while preserving alpha transparency.
- Provide reactive theme responsiveness so toggling between Light and Dark mode updates formulas immediately without rebuilding or re-parsing the HTML AST.
- Accurately identify formula images using class attributes, `role="math"`, data attributes, formula engine URLs, and legacy inline alignment/dimensions.
- Keep diagrams, general illustrations, and photos unmodified.

**Non-Goals:**
- Inverting SVG vector graphics or diagrams (SVGs do not suffer from raster blur and often contain colored illustrations).
- Parsing or modifying external raster image bytes at the network level.

## Decisions

### Decision 1: Matrix Color Filter (`ColorFilter.matrix`) over Image Processing or CSS Filters
- **Rationale**: An affine color matrix `[-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0]` inverts RGB channels independently while leaving the alpha channel unchanged. It executes on the GPU via Skia/Impeller, guaranteeing subpixel sharpness with zero blur.
- **Alternatives considered**:
  - Image shader/blur: Causes thin strokes and sub/superscripts to blur.
  - Re-fetching inverted assets from server: Increases network traffic and requires server-side rendering support.

### Decision 2: Reactive Wrapper Widget (`_DarkModeEquationFilter`)
- **Rationale**: Wrapping equation blocks in a `StatelessWidget` that reads `Design.of(context).isDark` dynamically hooks into `DesignProvider`. When dark mode is toggled, only the filter rebuilds without triggering an expensive HTML re-parse.
- **Alternatives considered**: Passing `isDark` into `WidgetFactory` constructor at parse time, which requires re-parsing the entire HTML tree when theme changes.

### Decision 3: Multi-tiered Heuristics with Clean Code Separation
- **Rationale**: Formulas in legacy content arrive under various schemas (`class="Wirisformula"`, `role="math"`, `src="...codecogs..."`, or `<img align="middle" ...>`). Breaking detection into small single-responsibility functions (`_hasMathAttributes`, `_hasMathEngineUrl`, `_isLegacyInlineFormula`) keeps code readable, maintainable, and easy to test.

## Risks / Trade-offs

- **[Risk] High-resolution math diagrams with `formula` in URL might be inverted** → Mitigation: Only images with height `<= 50` or explicit math tags/engine keywords are targeted. Diagrams and photos without math markers are ignored.
- **[Risk] Colored formula text inversion** → Mitigation: Math equations in assessments are almost exclusively monochrome black ink. Inverting monochrome ink yields high-contrast white glyphs.

