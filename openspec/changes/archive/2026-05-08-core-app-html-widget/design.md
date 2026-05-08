## Context

To support structured text styling, CMS paragraphs, mathematical equations (MathJax), and complex tables inside test player views, we need to implement a premium HTML rendering component in the `core` package.

## Goals / Non-Goals

**Goals:**
- Implement `AppHtml` StatefulWidget backed by `WebViewController` with Javascript enabled.
- Handle dynamic height resizing through `ResizeObserver` and a custom JavaScript channel.
- Add `webview_flutter: ^4.10.0` back to core's `pubspec.yaml` dependency block.

**Non-Goals:**
- Implement local/native markdown parsers.
- Embed full-page course players.

## Decisions

### Decision: WebView-based HTML rendering
Using `webview_flutter` provides a highly accurate render engine that supports third-party scripts (like MathJax), embedded iframes, complex tables, and customized CMS styles without needing brittle custom Dart parsing.

### Decision: Javascript channel height propagation
A custom `HeightChannel` communication pipeline automatically captures actual document height adjustments (triggered by load actions or resizing), propagating updates immediately to update the Flutter render tree dynamically.

## Risks / Trade-offs

- **Risk**: Flickering when first loading the WebView widget.
- **Mitigation**: Constrained minimal bounds (`BoxConstraints(minHeight: 20)`) to prevent blank layouts.
