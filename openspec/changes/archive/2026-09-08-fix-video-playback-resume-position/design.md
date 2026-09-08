## Context
See `proposal.md` for motivation. Video playback progress tracking currently relies on user pause/seek gestures to flush watched ranges to `VideoAttemptNotifier`. Without periodic flushing during continuous playback, progress is lost when the app is abruptly closed. Additionally, `VideoLessonViewer` uses `double.tryParse` on stored duration strings, returning `0.0` when timestamps are formatted in `HH:MM:SS`.

## Goals / Non-Goals

**Goals:**
- Implement a 10-second periodic interval timer in `CustomVideoPlayer` to flush watched ranges into `VideoAttemptNotifier`.
- Bind `AppLifecycleListener` / `WidgetsBindingObserver` to trigger `forceSync()` when the app enters `paused` / `inactive` state.
- Update `VideoLessonViewer` initial position calculation using `TimeFormatter.parseDuration`.

**Non-Goals:**
- Modifying backend endpoint structure or rate limiting headers.
- Altering exam/test attempt resume mechanisms.

## Decisions

### Decision 1: Periodic 10s Timer in `CustomVideoPlayer`
- **Rationale**: Flushes buffered watched ranges into `VideoAttemptNotifier` every 10 seconds during playback without pausing or seeking.
- **Alternatives considered**: Syncing on every position change tick (100ms-500ms) would degrade UI performance and flood state updates.

### Decision 2: 60-Second Server Sync Throttle in `VideoAttemptNotifier`
- **Rationale**: The backend API `/api/v2.5/chapter_content_attempts/videos/update/` enforces a 60-second minimum interval between sync requests. Keeping local updates frequent (10s) while throttling network POST calls to 60s avoids HTTP 429 rate limit errors while ensuring local DB and memory remain updated.
- **Alternatives considered**: Sending network requests on every 10s buffer flush (would result in 5 out of 6 requests failing with 429).

### Decision 3: App Lifecycle Integration
- **Rationale**: `WidgetsBindingObserver` captures `AppLifecycleState.paused` and `AppLifecycleState.inactive`, executing `forceSync()` before OS process suspension.

### Decision 4: Use `TimeFormatter.parseDuration` for Initial Position
- **Rationale**: Converts `"00:02:05"` into `Duration(minutes: 2, seconds: 5)` and converts to total seconds (`125.0`), correctly setting `initialPosition`.

## Risks / Trade-offs

- **[Risk]**: App force-killed during absolute OS crash before lifecycle callbacks.
  - **Mitigation**: Periodic 10s local buffer + 60s server sync ensures at most 60 seconds of progress is lost even under sudden OS kill.
