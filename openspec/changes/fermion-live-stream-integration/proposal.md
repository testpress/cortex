## Why

The live stream feature currently assumes all live content is served by TpStreams (an HLS `.m3u8` stream rendered in a native video player). Fermion is a new live session provider whose content is an embed URL that must be loaded in a WebView — requiring a distinct UI flow: a detail page with a "Join Now" button that launches the WebView, rather than an inline video player. Without provider-awareness, the app would attempt to render a Fermion session URL as a video stream, producing a broken experience.

## What Changes

- **Provider field parsed from API**: The `live_stream.provider` field (`"Fermion"` | `"TpStreams"`) is read from the API response and stored on the lesson model.
- **`LessonDto` and `Lesson` gain a `liveStreamProvider` field** (nullable `String`) to carry the provider name through the data layer to the UI.
- **`_parseLiveStreamLesson` updated** in `LessonDto.fromJson` to capture the `provider` field.
- **`LiveStreamViewer` diverges on provider**: When `provider == "Fermion"`, the viewer renders a detail/lobby page (session title, scheduled time, "Join Now" button) instead of the video player. When `provider == "TpStreams"` (or null), existing behaviour is preserved.
- **"Join Now" navigates to a full-screen WebView**: Tapping "Join Now" pushes `AppWebView` loaded with `lesson.contentUrl` (the Fermion embed URL), giving Fermion's JavaScript-heavy session the full screen.
- **`isComplete` logic updated**: A Fermion live stream with a valid `contentUrl` is considered complete so the skeleton is not shown.

## Capabilities

### New Capabilities

- `live-stream/fermion-provider`: Provider-aware live stream viewing — identifies Fermion sessions from the API `provider` field, renders a lobby/detail screen with a "Join Now" button, and opens the session in a full-screen WebView.

### Modified Capabilities

- `chapter-detail`: The live stream content row in chapter detail must not attempt to open a video player for Fermion streams; lesson taps for Fermion live streams navigate to the same lesson detail screen which now handles the branching internally (no change to navigation routing, only viewer rendering behaviour).

## Impact

- **`packages/core/lib/data/models/lesson_dto.dart`**: Add `liveStreamProvider` field; parse from `live_stream.provider`.
- **`packages/courses/lib/models/course_content.dart`**: Add `liveStreamProvider` field to `Lesson` domain model and `toDto()`.
- **`packages/courses/lib/widgets/lesson_detail/live_stream_viewer.dart`**: Branch on `lesson.liveStreamProvider` — Fermion shows lobby + WebView navigation; TpStreams shows existing video player.
- **`packages/courses/lib/screens/lesson_detail_orchestrator.dart`**: `isComplete` check for `liveStream` type may need to accommodate Fermion (contentUrl is a URL, not a UUID — still non-empty so existing check holds).
- No new routes, no new packages, no breaking API changes.
