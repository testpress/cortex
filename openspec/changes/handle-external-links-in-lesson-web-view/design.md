## Context

`LessonWebView` in `packages/courses/lib/widgets/lesson_detail/lesson_web_view.dart` provides an embedded WebView viewer for HTML notes and embedded lesson contents. When users click links inside note content (such as video call links for classes or schedules), the navigation delegate previously allowed in-place WebView navigation. In Android WebView, this leads to SSL handshake failures (`net_error -200`, `ERR_CERT_COMMON_NAME_INVALID`) and replaces the lesson note without camera/mic permissions. Additionally, wide HTML tables overflow the screen horizontally and get clipped because `body` has `overflow-x: hidden`.

## Goals / Non-Goals

**Goals:**
- Intercept external link clicks in `LessonWebView` and hand them off using `url_launcher` (`LaunchMode.inAppBrowserView`).
- Prevent the embedded WebView from navigating away from the lesson document (`NavigationDecision.prevent`).
- Preserve loading the initial URL when `widget.url` is supplied.
- Make HTML tables responsive via injected CSS (`max-width: 100%`, `display: block`, `overflow-x: auto`) so content does not get clipped.

**Non-Goals:**
- Turning `LessonWebView` into a dedicated video conferencing client (Teams/Zoom lessons already use dedicated viewers like `TeamsVideoConferenceScreen`).
- In-place multi-page browsing within lesson notes.

## Decisions

### Decision 1: External URL Delegation in NavigationDelegate
- **Choice**: In `onNavigationRequest`, check if the scheme is `http` or `https`. If it is the initial `widget.url`, return `NavigationDecision.navigate`. Otherwise, invoke `unawaited(launchUrl(uri, mode: LaunchMode.inAppBrowserView))` and return `NavigationDecision.prevent`.
- **Rationale**: Keeps the student in the app via an in-app browser tab (Chrome Custom Tabs on Android / SFSafariViewController on iOS) with a top "Done" button, avoids WebView SSL handshake issues, and provides full WebRTC camera/mic and Google authentication support.
- **Alternatives considered**:
  - `LaunchMode.externalApplication`: Kicks the user out to standalone browser/external app. Exits learning app context, which hurts retention and reading continuity.

### Decision 2: Injected CSS for HTML Tables
- **Choice**: Inject `table { max-width: 100% !important; display: block; overflow-x: auto; -webkit-overflow-scrolling: touch; }` into the HTML `<style>` wrapper.
- **Rationale**: Ensures tables conform to viewport width while allowing users to scroll horizontally to read wide multi-column schedules without breaking the 16px padding on either side.

## Risks / Trade-offs

- **[Risk]** Invalid URL schemes or malformed URIs.
  - **Mitigation**: Parse with `Uri.tryParse(request.url)` and ensure scheme is either `http` or `https` before calling `launchUrl`.
