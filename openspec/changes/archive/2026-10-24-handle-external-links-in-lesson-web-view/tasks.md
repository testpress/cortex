## 1. Core Implementation

- [x] 1.1 Intercept external HTTP/HTTPS main-frame navigation in `LessonWebView` and delegate via `launchUrl` with `LaunchMode.inAppBrowserView`
- [x] 1.2 Allow subframe navigation for embedded HTTP/HTTPS iframes without hijacking to external browser
- [x] 1.3 Preserve initial URL navigation when `LessonWebView` is configured with direct `widget.url`
- [x] 1.4 Add responsive CSS for `table` elements (`max-width: 100%`, `display: block`, `overflow-x: auto`) in `LessonWebView`

## 2. Verification & Testing

- [x] 2.1 Add unit tests for `LessonWebView` navigation request handling including subframe iframe embeds
- [x] 2.2 Verify analyzer and courses test suite pass
