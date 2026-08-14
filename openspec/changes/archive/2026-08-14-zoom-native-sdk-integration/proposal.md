## Why

The application needs to integrate the Zoom native SDK wrapper into the lesson viewer to replace the slow web-based lobby, enabling native video grid layout and low-latency audio/video inside the courses package.

## What Changes

- **Lobby UI Integration**: Integrate the Zoom launch action inside the `VideoConferenceViewer` widget within the `courses` package.
- **Sentry Error Capturing**: Add error tracking inside the `VideoConferenceViewer` to capture Zoom authentication and joining failures via `sentryServiceProvider`.
- **Gradle SQLite conflict resolution**: Add a conditional check in `app/android/app/build.gradle.kts` to exclude `sqlite3-native-library` when Zoom is enabled, and cap `sqlite3` to `<3.0.0` in `packages/core` to prevent runtime collisions.

## Capabilities

### New Capabilities
- `live-stream/zoom-sdk-integration`: Integrates the native Zoom video conference launch interface into the courses lesson viewer UI.

### Modified Capabilities
<!-- None -->

## Impact

- `packages/courses` (Modified video conference viewer widget)
- `packages/core` (Modified pubspec dependency versions)
- `app` (Modified Android build configurations and pubspec mappings)
