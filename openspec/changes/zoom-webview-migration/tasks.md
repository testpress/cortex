## 1. Zoom WebView & Auto-Join Handler

- [x] 1.1 Implement `ZoomPermissionHandler` in `packages/courses` to check and request camera and microphone permissions
- [x] 1.2 Implement `ZoomWebViewConfig` with desktop user-agent emulation and scrollbar suppression
- [x] 1.3 Implement `ZoomAutoJoinHandler` for URL gate detection, scheme interception (`zoomus://`), and JavaScript callbacks
- [x] 1.4 Implement `ZoomVideoConferenceScreen` in `packages/courses/lib/widgets/lesson_detail/zoom_web_view.dart` wrapped in `LessonDetailShell`
- [x] 1.5 Add unit and widget tests for `ZoomAutoJoinHandler` and `ZoomVideoConferenceScreen`
- [x] 1.6 Intercept post-attendee and leave meeting redirects in Zoom WebView to return to lesson lobby
- [x] 1.7 Inject touch responsiveness, desktop tooltip suppression, and viewport optimizations into Zoom WebView
- [x] 1.8 Refactor Zoom WebView implementation into separated concern files (config, auto-join handler, screen)

## 2. Lesson Orchestration Integration

- [x] 2.1 Update `VideoConferenceViewer._joinMeeting` in `packages/courses` to route Zoom lessons to `ZoomVideoConferenceScreen`
- [x] 2.2 Construct the direct Zoom Web Client URL (`https://app.zoom.us/wc/{id}/join?...`) with participant display name from `userProvider`
- [x] 2.3 Update `video_conference_viewer_test.dart` and related tests to verify Zoom WebView navigation

## 3. Native SDK Deprecation & Cleanup

- [x] 3.1 Remove the app-level layout workaround `app/android/app/src/main/res/layout/exo_player_view.xml`
- [x] 3.2 Remove Zoom and WebRTC keep rules from `app/android/app/proguard-rules.pro`
- [x] 3.3 Update `app/scripts/client_utils.dart` and `app/scripts/prepare_release.dart` to eliminate dynamic Zoom native dependency injection
- [x] 3.4 Verify that recorded video sessions (via `tpstreams_player_sdk`) and Zoom WebView sessions run without layout or binary collisions
