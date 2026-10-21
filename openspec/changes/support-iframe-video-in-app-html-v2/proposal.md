## Why

HTML content across Testpress (such as product descriptions, announcements, notes, and discussion content) frequently includes embedded media like YouTube, Vimeo, or LMS video iframes. Currently, `AppHtmlV2` is powered by `flutter_widget_from_html_core` which intentionally omits WebView dependencies and drops all `<iframe>` elements entirely. As a result, product description videos visible on the web are completely missing in the mobile application.

Enabling isolated inline `<iframe>` rendering within `AppHtmlV2` brings full media parity with the web while retaining Flutter's native layout speed and crisp typography for the surrounding text.

## What Changes

- Add isolated inline iframe embedding support to `AppHtmlV2` via `customWidgetBuilder` or a dedicated iframe factory.
- Implement an `AppIframeView` widget in `packages/core` that safely encapsulates a `WebViewController` constrained to a 16:9 aspect ratio with rounded corners.
- Configure WebView security and origin settings (including a valid base URL like `https://www.testpress.in`) to prevent origin blocking (e.g., YouTube Error 153).
- Ensure smooth scrolling and touch gesture pass-through inside parent scroll views (such as `ProductDetailScreen`).

## Capabilities

### New Capabilities
- `html-iframe-embed`: Inline iframe video embedding support for `AppHtmlV2`, rendering responsive video iframes (such as YouTube and Vimeo) within native HTML layouts.

### Modified Capabilities
<!-- None -->

## Impact

- `packages/core`: `AppHtmlV2` and new `AppIframeView` widget in `packages/core/lib/widgets/`.
- `packages/courses`: `ProductDetailScreen` description tab now renders embedded videos seamlessly without code change to the screen itself.
- All other screens utilizing `AppHtmlV2` automatically gain support for iframe embeds without WebView overhead for pure text content.
