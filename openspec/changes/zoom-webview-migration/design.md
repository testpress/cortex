## Context

The Cortex mobile app currently integrates Zoom using a locally maintained native SDK package (`packages/zoom`), forked from `flutter_zoom_meeting_sdk`. This integration has caused persistent instability:
- **ExoPlayer vs. Media3 Collision**: Zoom SDK embeds legacy ExoPlayer UI resources (`exo_player_view.xml`). On Android, resource merging causes this layout to override TPStreams Player SDK's AndroidX Media3 layout, crashing recorded class video playback with `ClassCastException: androidx.media3.ui.AspectRatioFrameLayout cannot be cast to com.google.android.exoplayer2.ui.AspectRatioFrameLayout`.
- **R8 / ProGuard Minification**: Release builds strip WebRTC and JNI symbols without extensive, fragile keep rules.
- **Binary Footprint**: Over 500 MB of `.aar` and `.framework` binaries require Git LFS and lengthen build/download times.

Cortex already successfully integrates Microsoft Teams through an in-app WebView ([`TeamsVideoConferenceScreen`](file:///Users/pugal/cortex/packages/courses/lib/widgets/lesson_detail/teams_web_view.dart)). Adopting the same WebView architecture for Zoom completely decouples video conferencing from native player and media libraries.

## Goals / Non-Goals

**Goals:**
- Provide a smooth, in-app Zoom live class joining experience via Flutter `webview_flutter`.
- Automatically handle camera/microphone permissions and gate auto-joining.
- Eliminate native binary dependencies in `packages/zoom`, resolving the Media3 collision with `tpstreams_player_sdk`.
- Remove temporary workarounds: `app/android/app/src/main/res/layout/exo_player_view.xml` and ProGuard keep rules for Zoom.
- Ensure identical student UX across iOS and Android without external browser redirection.

**Non-Goals:**
- Meeting host administrative controls (scheduling, breakout room assignments). The mobile app is student-facing.
- Custom native video canvas rendering. The standard Zoom Web Client interface will render inside the WebView.

## Decisions

### 1. Zoom Web Client URL Construction
Zoom standard join URLs (`https://zoom.us/j/{id}?pwd={pwd}`) display an intermediate landing page prompting users to open or download the Zoom app.
- **Decision**: Construct the Zoom Web Client URL directly when `conferenceId` is available:
  ```text
  https://app.zoom.us/wc/{meetingId}/join?pwd={password}&uname={displayName}
  ```
  If `conferenceId` is absent, fall back to `lesson.contentUrl`.
- **Alternatives Considered**:
  - *Loading raw `join_url`*: Relies on JavaScript redirects and clicking "Join from your browser". Constructing `/wc/...` directly bypasses the gate screen faster and more reliably.

### 2. User-Agent Emulation and Deep-Link Trapping
Zoom actively checks the browser user agent and blocks standard mobile browsers with a download wall.
- **Decision**: Set a desktop Chrome user agent (`TeamsWebViewConfig.desktopUserAgent`) on `WebViewController`. In `NavigationDelegate.onNavigationRequest`, block any navigation scheme that is not `http` or `https` (e.g. `zoomus://`, `intent://`) to ensure the user stays inside the app.
- **Alternatives Considered**:
  - *Launching external browser*: Ejects the user from the app, breaking LMS navigation, session state, and immersion.

### 3. Screen Structure and Permission Flow
- **Decision**: Create `ZoomVideoConferenceScreen` in `packages/courses/lib/widgets/lesson_detail/zoom_web_view.dart`, structured like `TeamsVideoConferenceScreen`:
  - Request `Permission.camera` and `Permission.microphone` prior to loading.
  - Automatically grant `WebViewPermissionRequest` via `onPermissionRequest: (request) => request.grant()`.
  - Wrap in `LessonDetailShell` to provide standard back button navigation and header.
  - Inject a lightweight `ZoomAutoJoinHandler` to detect and dismiss post-load prompts (e.g., audio connection popups).

### 4. Retirement of Native Zoom Dependencies
- **Decision**:
  - Remove app-level layout workaround `app/android/app/src/main/res/layout/exo_player_view.xml`.
  - Remove Zoom keep rules from `app/android/app/proguard-rules.pro`.
  - Update `client_utils.dart` and `prepare_release.dart` to no longer inject `zoom` into `pubspec.yaml`.
  - Deprecate or retire `packages/zoom`.

## Risks / Trade-offs

- **[Risk] Stale DOM selectors, English text heuristics, and User-Agent obsolescence**
  → *Risk details*: The automated join script relies on hardcoded DOM element selectors, English string matching (`"join from your browser"`, `"zoom workplace app"`), and a desktop Chrome 114 user-agent string. Over time, Zoom may alter their Web Client markup, localize button copy, or deprecate older Chrome versions.
  → *Mitigation*: Auto-join operates with non-fatal fallbacks. If button heuristics fail, time out (via the 8-second fallback timer), or encounter script errors, the loading overlay is dismissed automatically so the student can interact with the meeting and tap "Join" manually. Sentry reports errors to alert of any DOM breakage. Periodic maintenance of the desktop UA string should be part of release audits.
- **[Trade-off] Disabling WebView pinch-to-zoom (WCAG 1.4.4)**
  → *Rationale*: Pinch-to-zoom is intentionally disabled (`enableZoom(false)` and viewport `user-scalable=no`) to avoid accidental viewport panning, zoom lockups, and broken desktop meeting layouts during live video, consistent with `TeamsVideoConferenceScreen`.
- **[Trade-off] Desktop tooltip suppression in mobile WebView**
  → *Rationale*: Desktop hover tooltips are suppressed via CSS in the mobile WebView to eliminate mobile tap delays and hover traps. Zoom toolbar buttons natively define explicit `aria-label` attributes on `<button>` elements, ensuring TalkBack and VoiceOver screen-reader accessibility remains intact.
- **[Risk] Audio permission / device routing in WebView**
  → *Mitigation*: Both Android WebView and iOS `WKWebView` support WebRTC audio/video when camera and microphone permissions are granted. We handle both OS-level permission requests and WebView runtime grants.
- **[Risk] Landscape orientation while viewing screen shares**
  → *Mitigation*: Ensure the container and `LessonDetailShell` permit screen rotation while the Zoom WebView is active.
