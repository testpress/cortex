## 1. Dedicated Teams WebView

- [x] 1.1 Create `TeamsVideoConferenceScreen` in `teams_web_view.dart` to handle the specific requirements of MS Teams (desktop user agent, custom navigation delegates).
- [x] 1.2 Implement `TeamsAutoJoinHandler` to inject JavaScript into the Teams gate page to automatically click "Continue on this browser".
- [x] 1.3 Add `TeamsPermissionHandler` to request camera/microphone permissions before launching the WebView.
- [x] 1.4 Add loading overlay logic that naturally drops on `onPageFinished` after successful bypass.

## 2. Integration

- [x] 2.1 Update `_joinMeeting` in `VideoConferenceViewer` (`packages/courses/lib/widgets/lesson_detail/video_conference_viewer.dart`) to intercept Teams lessons and push the new `TeamsVideoConferenceScreen`.

## 3. Verification

- [x] 3.1 Run `flutter analyze` and confirm no compile or lint issues exist.
