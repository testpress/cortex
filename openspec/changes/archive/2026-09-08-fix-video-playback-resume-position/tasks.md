## 1. Initial Position Parsing Fix

- [x] 1.1 Update `VideoLessonViewer` to parse `lastWatchedDuration` using `TimeFormatter.parseDuration` instead of `double.tryParse`
- [x] 1.2 Add unit tests for `VideoLessonViewer` initial position calculation with formatted timestamp strings (`"00:02:05"`)

## 2. Periodic Buffer Flushing in CustomVideoPlayer

- [x] 2.1 Add a 10-second periodic timer in `CustomVideoPlayer` to flush watched time ranges into `VideoAttemptNotifier` during continuous playback
- [x] 2.2 Add `WidgetsBindingObserver` / lifecycle listener to `CustomVideoPlayer` to force sync pending ranges on app `paused` / `inactive` state
- [x] 2.3 Cancel periodic timers on `CustomVideoPlayer` dispose

## 3. Attempt Notifier Sync & Rate Limiting

- [x] 3.1 Ensure `VideoAttemptNotifier` correctly processes periodic flushes while enforcing the 60-second minimum network sync throttle
- [x] 3.2 Verify local DB `lastWatchedDuration` updates when `updateVideoAttempt` completes

## 4. Verification

- [x] 4.1 Run unit and widget tests across `courses` package
- [x] 4.2 Validate OpenSpec change status and specs compliance
