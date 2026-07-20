## Context

The app uses `syncfusion_flutter_pdfviewer` to display PDF documents in the `packages/courses` module. Currently, these PDFs are displayed without any user-identifying overlays. To trace document leakage, we need a watermark over the PDF viewer that displays the logged-in user's username.

## Goals / Non-Goals

**Goals:**
- Provide a semi-transparent, centered watermark over the PDF viewer.
- Display the authenticated user's username as the text.
- Ensure the overlay does not consume or intercept pointer events (users must still be able to interact with the PDF viewer below it).

**Non-Goals:**
- Complex animation or dynamic styling based on the PDF content type.

## Decisions

- **Watermark Presentation (In-App)**: Use an `Align` widget with `Transform.rotate` and a `Text` widget to draw a single, slightly offset, rotated text watermark in the viewport. This avoids any `CustomPainter` or `RepaintBoundary` texture allocation crashes.

- **Pointer Event Handling**: Include an `IgnorePointer` widget inside the `WatermarkOverlay` so that all touch events safely pass through to the `SfPdfViewer` below it.
- **State Management**: Utilize the existing `userProvider` within the core package (`user_provider.dart`) that streams the authenticated user's state. This adheres to the strict separation of concerns by reading directly from the `UserRepository` instead of polluting the `auth` layer with domain logic.
- **Feature Flag**: Expose the `enable_course_pdf_watermarking` flag from the `InstituteSettings` (via `/api/v2.3/settings/`) to conditionally render the `WatermarkOverlay`. The watermark will only be shown if the backend explicitly enables it.
## Risks / Trade-offs

- **Risk**: Performance impact of overlaying widgets on a complex PDF viewer.
  - **Mitigation**: By using standard Flutter widgets (`Text`, `Center`) without a `RepaintBoundary`, we avoid expensive texture allocation crashes that can occur during deep zooming.
- **Risk**: Text obscuring the underlying document.
  - **Mitigation**: Use low opacity (e.g., 0.1) and a neutral color (grey/black depending on theme) so the text remains legible without significantly reducing contrast of the PDF.
- **Risk**: A single, non-tiled watermark is relatively easy to bypass (e.g., by cropping a screenshot or scrolling past it).
  - **Mitigation**: This was an intentional trade-off to prioritize a non-obstructive reading experience. If screenshot resistance becomes a higher priority in the future, we can transition to a tiled watermark approach.
