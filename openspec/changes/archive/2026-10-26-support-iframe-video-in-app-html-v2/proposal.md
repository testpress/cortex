## Why

HTML content across Testpress (such as product descriptions, announcements, notes, and discussion content) frequently includes embedded media like YouTube video iframes. Currently, `AppHtmlV2` is powered by `flutter_widget_from_html_core`, which is designed to be lightweight and focus on native widget rendering without bundling WebView dependencies. Consequently, `<iframe>` elements are not rendered out of the box, causing embedded videos visible on the web to be missing in the mobile application.

Enabling isolated inline `<iframe>` rendering within `AppHtmlV2` brings full media parity with the web while retaining Flutter's native layout speed and crisp typography for the surrounding text.

## What Changes

- Add isolated inline iframe embedding support to `AppHtmlV2` via `customWidgetBuilder` or a dedicated iframe factory.
- Implement an `AppIframeView` widget in `packages/core` that safely encapsulates a `WebViewController` constrained to a 16:9 aspect ratio with rounded corners.
- Configure WebView security and origin settings (using the tenant's base origin) to prevent origin blocking (e.g., YouTube Error 153).
- Ensure smooth scrolling and touch gesture pass-through inside parent scroll views (such as `ProductDetailScreen`).

## Capabilities

### New Capabilities
- `html-iframe-embed`: Inline iframe video embedding support for `AppHtmlV2`, rendering responsive video iframes (such as YouTube) within native HTML layouts.

### Modified Capabilities
<!-- None -->

## Impact

- `packages/core`: `AppHtmlV2` and new `AppIframeView` widget in `packages/core/lib/widgets/`.
- `packages/courses`: `ProductDetailScreen` description tab now renders embedded videos seamlessly without code change to the screen itself.
- All other screens utilizing `AppHtmlV2` automatically gain support for iframe embeds without WebView overhead for pure text content.
