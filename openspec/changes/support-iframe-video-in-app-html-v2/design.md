## Context

In LMS product descriptions, course overviews, and test explanations, content creators frequently embed video walkthroughs (such as YouTube iframes). On the web, these iframes are rendered natively by the browser.

In the Flutter mobile application, content is rendered via `AppHtmlV2` (`packages/core/lib/widgets/app_html_v2.dart`), which is powered by `flutter_widget_from_html_core`. Because `flutter_widget_from_html_core` does not include WebView dependencies, it silently ignores and drops all `<iframe>` tags, leaving the video completely absent from the mobile UI.

## Goals / Non-Goals

**Goals:**
- Detect `<iframe>` elements in `AppHtmlV2` and render them inline using an isolated `AppIframeView` widget.
- Ensure embedded videos maintain a standard 16:9 aspect ratio with consistent corner radiuses and theme background placeholders.
- Provide a valid HTTPS origin (`https://www.testpress.in`) to prevent YouTube Error 153 and other cross-origin embed rejections.
- Maintain native Flutter text and equation rendering performance for all non-iframe elements in `AppHtmlV2`.

**Non-Goals:**
- Replacing `AppHtmlV2` with full-page `AppHtml` (WebView) which causes layout height recalculations and scroll stutter.
- Implementing custom playback controllers over the third-party iframe (YouTube provides its own native controls).

## Decisions

### 1. Intercept `<iframe>` via `customWidgetBuilder` in `AppHtmlV2`
- **Decision**: In `AppHtmlV2`'s `HtmlWidget`, provide a `customWidgetBuilder` callback that matches elements with `element.localName == 'iframe'`, extracts the `src` URL, and returns an `AppIframeView`.
- **Rationale**: Keeps 99% of content natively rendered by Flutter (text, headings, LaTeX equations, images), isolating WebView overhead strictly to the video player container.
- **Alternatives Considered**:
  - *Hybrid switch to `AppHtml`*: Renders the entire document in WebView, leading to layout jumps in `SingleChildScrollView`, font inconsistencies, and high memory usage.
  - *Adding `fwfh_webview` package*: Adds an unneeded external dependency when `webview_flutter: ^4.10.0` is already an established first-party dependency in `packages/core`.

### 2. Encapsulate inline WebView inside `AppIframeView`
- **Decision**: Implement a dedicated `AppIframeView` widget in `packages/core/lib/widgets/app_iframe_view.dart`.
- **Configuration**:
  - `setJavaScriptMode(JavaScriptMode.unrestricted)`
  - Configurable HTTPS base URL origin (`widget.baseUrl`, `AppConfig.apiBaseUrl`, fallback to `https://www.testpress.in`)
  - Strict navigation guard comparing `uri.host` against the base origin and allowed video embed endpoints
  - Constrained within `AspectRatio(aspectRatio: 16 / 9)` and `ClipRRect` with `design.radius.md`

## Risks / Trade-offs

- **[Risk] Gesture contention inside scroll views**: Dragging across the video might trigger the parent `SingleChildScrollView` or be captured by the WebView.
  - *Mitigation*: Configure gesture recognizers appropriately so vertical scrolling remains fluid while tap-to-play works instantly.
- **[Risk] Malformed or relative iframe URLs**: Some CMS inputs might omit the `https:` scheme (e.g. `//www.youtube.com/...`).
  - *Mitigation*: Normalize `src` URLs in `AppIframeView` to ensure standard `https:` scheme before loading.
