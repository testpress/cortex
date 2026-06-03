## Context

The current `_RadioIndicator` widget suffers from pixelation, uneven borders, and a noticeable gap or seam in the outer circle. 
Additionally, nesting concentric circular containers (`BoxShape.circle`) with independent fills leads to moiré/rasterization artifacts where the outer boundary and inner background fight for anti-aliasing pixels, resulting in an "uneven" outline or a lumpy shape at small/fractional resolutions. Similarly, drawing outlines with stroked paint (`PaintingStyle.stroke`) results in joint gaps and asymmetric subpixel thickness.

## Goals / Non-Goals

**Goals:**
- Render perfectly smooth, round radio buttons without joint gaps, lumpiness, or pixelation.
- Support standard (20px / `design.iconSize.md`) and small (16px / `design.iconSize.sm`) sizes cleanly, matching Figma specifications.
- Maintain smooth, accessibility-aware micro-animations for selection transitions.

**Non-Goals:**
- Altering the global design system or colors.
- Changing the layout/structure of other components.

## Decisions

### Decision 1: Use CustomPainter with Concentric Filled Circles and Pixel Snapping
- **Option A (Baseline)**: Use `Border.all` on a `BoxShape.circle` container.
  - *Pros*: Simple, native Flutter decoration.
  - *Cons*: Suffers from Skia stroke rendering joint gaps.
- **Option B (Nested Containers)**: Use nested filled containers in the widget tree.
  - *Pros*: Eliminates path stroke joint gaps.
  - *Cons*: Concentric anti-aliased fills fight for pixels, creating a lumpy, uneven ring.
- **Option C (Custom Painter with Stroke)**: Draw outer ring with `PaintingStyle.stroke`.
  - *Pros*: Simple drawing logic.
  - *Cons*: Reintroduces Skia's outline joint gap and subpixel thickness lumpiness.
- **Option D (Custom Painter with Concentric Fills & Snapping)**: Draw the outer ring as a filled circle of the border color, masked by a smaller filled circle of the card background color. Add a `1px` margin inside the canvas to prevent anti-aliasing edge clipping. Call `roundToDouble()` on layout width/height to snap drawing center and radius to physical pixel boundaries.
  - *Pros*: Completely eliminates all strokes, joint gaps, and subpixel alignment errors. Outlines are perfectly round, symmetric, and smooth.
  - *Cons*: Requires reading parent card color (`design.colors.card`) to mask the center.
- **Decision**: Option D is chosen to achieve professional, premium, high-fidelity graphics.

## Risks / Trade-offs

- **[Risk] Custom Rendering Overhead** → Custom painters bypass standard widget tree caching if not implemented correctly.
- **[Mitigation]** The `shouldRepaint` method is strictly implemented to only repaint when color, selection, or animation values change.
