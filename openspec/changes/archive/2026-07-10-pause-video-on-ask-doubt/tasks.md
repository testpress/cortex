## 1. Add `finalizePlayback()` + `restorePlayback()` to `CustomVideoPlayerState`

- [x] 1.1 `finalizePlayback()`: finalizes interval, captures `_lastPosition` into `_pendingSeekPosition`, force-syncs, then sets `_isPlayerDestroyed = true` → `build()` returns `SizedBox.shrink()` → `TestpressPlayer` unmounted.
- [x] 1.2 `restorePlayback()`: resets `_isPlayerDestroyed = false`, `_controller = null`, `_hasSeekedToInitial = false`, `_isPlayingTracker = false` → `build()` renders fresh `TestpressPlayer`.
- [x] 1.3 `_onPlayerCreated` uses `_pendingSeekPosition ?? widget.initialPosition` for initial seek (resumes from where user left off).
- [x] 1.4 `_pendingSeekPosition` cleared to null after seek to avoid interfering with normal page loads.

## 2. Wire destroy/restore into `VideoLessonViewer` → `DoubtTab`

- [x] 2.1 Add `VoidCallback? onBeforeNavigate` and `VoidCallback? onResumeVideo` to `DoubtTab`.
- [x] 2.2 Call `onBeforeNavigate?.call()` before `context.push()`, `onResumeVideo?.call()` after `await context.push()`.
- [x] 2.3 `VideoLessonViewer` passes both callbacks wired to `_videoPlayerKey`.

## 3. Wire into `VideoLessonDetailScreen` → `DoubtTab`

- [x] 3.1 Pass both callbacks to `DoubtTab`.

## 4. Verify

- [x] 4.1 Player destroyed (unmounted) on Ask Doubt tap — same as back button.
- [x] 4.2 Player recreated on return — seeks to correct position.
- [x] 4.3 Progress synced before navigation.
- [x] 4.4 Full manual QA: play → Ask Doubt → return → resumes from where left off.
