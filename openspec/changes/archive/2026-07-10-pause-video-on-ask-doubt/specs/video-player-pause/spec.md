# Video Player Finalize on Ask Doubt

## ADDED Requirements

### Requirement: Video Player Lifecycle on Ask Doubt

The player MUST properly finalize and restore video state when navigating to Ask Doubt.

#### Scenario: Navigating to Ask Doubt
- When the user taps "Ask Doubt"
- Then the `onBeforeNavigate` callback MUST be invoked
- And `CustomVideoPlayerState.finalizePlayback()` MUST finalize the interval, save the current position, and force sync the video attempt
- And the player widget MUST be unmounted (`_isPlayerDestroyed = true` returning `SizedBox.shrink()`)

#### Scenario: Returning from Ask Doubt
- When the user returns from Ask Doubt
- Then the `onResumeVideo` callback MUST be invoked
- And `CustomVideoPlayerState.restorePlayback()` MUST clear the destroyed state
- And the player MUST be recreated and seek to the saved position

## Implementation Details

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
