## Why

The native Zoom Meeting SDK integration in `packages/zoom` has repeatedly caused critical build and runtime collisions:
1. **ExoPlayer vs. Media3 Collision**: Zoom SDK dependencies bundle legacy ExoPlayer UI resources (`exo_player_view.xml`), overriding `tpstreams_player_sdk`'s AndroidX Media3 layouts during Android resource merging and causing fatal `ClassCastException`s when playing recorded live classes.
2. **Release Build & ProGuard Instability**: The native Zoom SDK relies heavily on reflection, native JNI bindings, and WebRTC classes that require brittle keep rules in R8/ProGuard.
3. **Binary Bloat & SQLite Conflicts**: The native Zoom SDK adds over 500 MB of native `.aar` and `.framework` binaries (requiring Git LFS) and previously caused native binary symbol collisions with Drift's SQLite bindings.

Migrating to an in-app WebView solution (following the proven pattern used by `TeamsVideoConferenceScreen` for Microsoft Teams) eliminates all native dependencies, resolves the Media3 conflict with `tpstreams_player_sdk`, and delivers a uniform, reliable joining experience across all clients.

## What Changes

- **In-App Zoom WebView**: Introduce `ZoomVideoConferenceScreen` and `ZoomAutoJoinHandler` in `packages/courses` using `webview_flutter` to load Zoom meetings via Zoom Web Client (`https://app.zoom.us/wc/{meetingId}/join?...`).
- **Camera & Microphone Permissions**: Request camera and microphone permissions before opening the WebView and automatically grant them via `onPermissionRequest`.
- **User-Agent & Deep Link Interception**: Configure a desktop/compatible browser user agent to prevent "Download Zoom" app-store prompts, while preventing external navigation to `zoomus://` schemes.
- **Orchestration Update**: Update `VideoConferenceViewer` in `packages/courses` to route Zoom meetings to `ZoomVideoConferenceScreen` instead of dispatching through `meetingServiceProvider`.
- **Deprecate Native Zoom SDK & Clean Up Workarounds**:
  - Remove app-level layout workaround `app/android/app/src/main/res/layout/exo_player_view.xml`.
  - Remove Zoom keep rules from `app/android/app/proguard-rules.pro`.
  - Deprecate dynamic native Zoom SDK dependency injection in `app/scripts/client_utils.dart` and `app/scripts/prepare_release.dart`.
  - Retire `packages/zoom` package dependency.

## Capabilities

### New Capabilities
- `zoom-webview-join`: In-app web view video conference viewer for Zoom live classes with permission handling, gate auto-join, and desktop browser emulation.

### Modified Capabilities
- `zoom-sdk-proguard-rules`: Retire ProGuard preservation requirements for native Zoom SDK binaries as the native SDK is replaced by WebView.

## Impact

- **Affected Packages**: `packages/courses` (new Zoom WebView screen & orchestration), `packages/core` (clean up or deprecate native `MeetingServiceRegistry` usage), `app` (remove layout override & proguard rules, update build scripts).
- **APIs**: No backend API changes; existing `LessonDto` fields (`conferenceId`, `password`, `contentUrl`, `accessToken`) provide all required meeting connection parameters.
- **Dependencies**: No new external dependencies needed (`webview_flutter` and `permission_handler` are already available in `packages/courses`).
