# Video Player Finalize on Ask Doubt

## Interface

### `CustomVideoPlayerState`

Add public methods:

```dart
Future<void> finalizePlayback() async {
  _finalizeCurrentInterval();
  _pendingSeekPosition = _lastPosition;
  if (_contentId != null && _videoAttemptNotifier != null) {
    _videoAttemptNotifier!.forceSync();
  }
  if (mounted) {
    setState(() => _isPlayerDestroyed = true);
    // build() returns SizedBox.shrink() → TestpressPlayer unmounted → native player destroyed
  }
}

void restorePlayback() {
  _isPlayerDestroyed = false;
  _controller = null;
  _hasSeekedToInitial = false;
  _isPlayingTracker = false;
  setState(() {});
  // build() renders fresh TestpressPlayer → _onPlayerCreated fires
}
```

`build()` returns `SizedBox.shrink()` when `_isPlayerDestroyed` is true.

`_onPlayerCreated` uses `_pendingSeekPosition ?? widget.initialPosition` for the initial seek, so the video resumes from where the user left off. `_pendingSeekPosition` is set to null after the seek.

### `DoubtTab`

Accept optional callbacks:
- `VoidCallback? onBeforeNavigate` — called before `context.push()`
- `VoidCallback? onResumeVideo` — called after `await context.push()` completes

```dart
onTap: () async {
  onBeforeNavigate?.call();
  await context.push(uri.toString());
  onResumeVideo?.call();
},
```

### Callers

- `VideoLessonViewer` passes `onBeforeNavigate: () => _videoPlayerKey.currentState?.finalizePlayback()` and `onResumeVideo: () => _videoPlayerKey.currentState?.restorePlayback()`.
- `VideoLessonDetailScreen` passes the same callbacks.

## Behavior

- User taps "Ask Doubt": interval finalized, position captured, progress force-synced, native player destroyed.
- User returns from Ask Doubt: fresh player created, seeks to captured position (resumes from where left off).
- Normal back button behavior is unchanged.
