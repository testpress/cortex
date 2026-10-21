## 1. Core Iframe Embed Viewer Widget

- [x] 1.1 Implement `AppIframeView` in `packages/core/lib/widgets/app_iframe_view.dart` with `webview_flutter`, 16:9 aspect ratio, and HTTPS baseUrl origin.
- [x] 1.2 Configure `NavigationDelegate.onNavigationRequest` to block unsupported schemes (`intent://`) and prevent navigating away from the embed video.
- [x] 1.3 Remove artificial loading spinner/overlay so video mounts immediately.
- [x] 1.4 Export `AppIframeView` in `packages/core/lib/core.dart`.

## 2. AppHtmlV2 Integration

- [x] 2.1 Update `AppHtmlV2` in `packages/core/lib/widgets/app_html_v2.dart` to use `customWidgetBuilder` to intercept `<iframe>` tags and render `AppIframeView`.
- [x] 2.2 Ensure HTML sanitization and preprocessing in `AppHtmlV2` preserve `<iframe>` tags and valid embed `src` attributes.

## 3. Verification & Testing

- [x] 3.1 Update widget tests in `packages/core/test/widgets/app_iframe_view_test.dart` and `packages/core/test/widgets/app_html_v2_test.dart` verifying navigation guardrails and immediate widget mounting.
- [x] 3.2 Run test suite and static analysis (`flutter test`, `flutter analyze`) to verify zero regressions.

