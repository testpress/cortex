## Why

Users need the ability to join MS Teams video conference lessons directly from the application. We want to enable joining Teams lessons using an in-app WebView, while providing a seamless, auto-join experience that skips Microsoft's "Download App" gate pages.

## What Changes

- Create a dedicated `TeamsVideoConferenceScreen` with a custom WebView to handle the complex auto-join flow.
- Inject Javascript via a `TeamsAutoJoinHandler` to seamlessly bypass the Microsoft Teams "Download App" interstitial gate.
- Update `VideoConferenceViewer` to route Teams meetings to this new dedicated screen.

## Capabilities

### New Capabilities
- `ms-teams-webview-join`: Seamless auto-join of MS Teams meetings via an in-app WebView without native SDK dependencies.

### Modified Capabilities
- (None)

## Impact

*   **`packages/courses`**: Modifies `_joinMeeting` flow in `video_conference_viewer.dart` to push a new `TeamsVideoConferenceScreen` (`teams_web_view.dart`) instead of a generic browser.
