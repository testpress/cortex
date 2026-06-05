## Context

When a user closes a lesson video, their playback progress is currently lost. The `attempts_url` available in the Lesson Detail API provides historical progress via `last_position` and an array of `time_ranges`. We need to initialize video playback to the `last_position` and track new video segments the user watches. To prevent data loss, the new tracking data needs to be saved back to the server using the `/api/v2.5/chapter_content_attempts/videos/update/` POST API.

## Goals / Non-Goals

**Goals:**
- Seek the video player to the user's last watched position on initialization.
- Track new time intervals as the user watches the video (`watched_time_ranges`).
- Sync the new/delta time ranges to the backend every 5 minutes and on significant player events (pause, seek, navigating back).

**Non-Goals:**
- We are not modifying the backend APIs.
- We are not tracking or persisting ranges of past sessions beyond what the server handles—the backend expects only delta (new) ranges in the POST request.

## Decisions

- **Sync Frequency & Debouncing:** Syncing will occur on a 5-minute periodic timer, as well as on key events (pause, seek, back navigation). To avoid spamming the backend during rapid seeking or toggling of playback, a debounce mechanism (e.g., 2-3 seconds) will be implemented so only the final user interaction triggers the POST API.
- **Delta Tracking for Time Ranges:** Rather than maintaining an ever-growing list of past ranges from the GET API, the app will track a *current session delta*. As the user plays, we track the start and end of continuous playback. On pausing or seeking, that chunk is committed to the delta list. Upon a successful API sync, this delta list is cleared to ensure we only send newly watched chunks on the next sync.
- **State Management:** A dedicated Riverpod controller/provider will manage the tracking state separately from the UI layer to maintain clean architecture, listening to the `TPStreamsPlayerController` events.

## Risks / Trade-offs

- **Risk:** Rapid seeking causes multiple POST requests. → **Mitigation:** Implemented debouncing for event-driven API syncs.
- **Risk:** App crash or forced closure before 5-minute sync. → **Mitigation:** We sync on pause and back navigation, which covers most deliberate exit scenarios. Unexpected crashes might lose a few minutes of progress.
