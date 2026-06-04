## Why

Users who are binge-watching video lessons need a seamless experience without manually clicking to navigate to the next session. Implementing an "AutoPlay next session" feature reduces friction and improves user engagement.

## What Changes

- When a video lesson reaches the end, the app will check if the "autoPlayNext" user setting is enabled.
- If enabled, the app will automatically navigate to the next lesson in the curriculum, regardless of what the next lesson type is.
- For non-video lessons, there is no auto-play behavior.

## Capabilities

### New Capabilities
None

### Modified Capabilities
- `unified-lesson-shell`: Update the lesson shell / video player to observe video completion and trigger navigation based on the auto-play setting.

## Impact

- Video player components (e.g., `custom_video_player.dart`, `offline_video_player_screen.dart`) will need to handle completion events.
- Lesson detail controllers/providers will need to check `autoPlayNext` setting before navigating.
