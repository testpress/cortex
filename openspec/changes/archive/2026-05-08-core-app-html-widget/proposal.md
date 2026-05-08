## Why

Standard text widgets cannot properly render MathJax equations, complex tables, and Testpress CMS HTML styles inside exams and curriculum resources. We need a premium, WebView-backed HTML rendering component inside the platform SDK to guarantee visual and functional accuracy.

## What Changes

- Add `webview_flutter: ^4.10.0` dependency to `packages/core/pubspec.yaml`.
- Create a brand new `AppHtml` StatefulWidget backed by `WebViewController` inside `packages/core/lib/widgets/app_html.dart`.
- Export `AppHtml` in `packages/core/lib/core.dart` to make it accessible to other packages like `exams`.

## Capabilities

### New Capabilities
- `core-app-html-widget`: Renders perfect HTML with support for MathJax script injection, table styling, and dynamic height resizing.

### Modified Capabilities

## Impact

- `packages/core` depends on `webview_flutter`.
- Exporting `AppHtml` as part of Core's public API surface.
