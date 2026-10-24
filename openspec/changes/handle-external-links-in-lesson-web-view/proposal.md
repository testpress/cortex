## Why

When viewing HTML notes (such as schedules) containing hyperlinks or data tables, tapping an external link triggers an in-place WebView navigation that causes Chromium SSL handshake failures (`net_error -200`, `ERR_CERT_COMMON_NAME_INVALID`) and breaks the lesson view. Additionally, unconstrained HTML tables overflow the viewport width and get clipped because horizontal scrolling is disabled without responsive table styles.

## What Changes

- Intercept HTTP and HTTPS navigation requests in `LessonWebView` to prevent in-place WebView navigation and delegate them to `url_launcher` (`LaunchMode.externalApplication`).
- Preserve direct `widget.url` initial loading for lessons configured with an explicit URL.
- Inject responsive CSS for HTML `table` elements (`max-width: 100%`, `display: block`, `overflow-x: auto`) to allow smooth horizontal scrolling within screen padding and prevent content clipping.

## Capabilities

### Modified Capabilities
- `webview-lesson-viewer`: Add external hyperlink delegation via `url_launcher` and responsive table styling for HTML lesson notes.

## Impact

- Affected files: `packages/courses/lib/widgets/lesson_detail/lesson_web_view.dart`.
- Dependencies: Relies on `url_launcher` (already exported via `core`).
- No breaking API changes.
