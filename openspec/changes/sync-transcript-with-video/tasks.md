## 1. Video Player & Position Communication

- [x] 1.1 Add `onPositionChanged` callback parameter to `CustomVideoPlayer`
- [x] 1.2 Update the controller's listener inside `CustomVideoPlayerState` to trigger `onPositionChanged` callback
- [x] 1.3 Instantiate `ValueNotifier<Duration> _videoPositionNotifier` in `_VideoLessonViewerState` and link it to the video player's `onPositionChanged`

## 2. Transcripts Tab UI & Interaction

- [x] 2.1 Update `TranscriptsTab` to accept `videoPositionNotifier`
- [x] 2.2 Re-architect the layout of individual transcript items to be compact, with no large gap between timestamp and text
- [x] 2.3 Implement time parsing helper to parse WebVTT timestamp strings into `Duration` objects
- [x] 2.4 Add logic to identify the current active cue index based on the video position notifier
- [x] 2.5 Style the active cue with bold font weight and primary text color
- [x] 2.6 Integrate `ScrollController` and use `Scrollable.ensureVisible` with a map of `GlobalKey`s to auto-scroll to the active cue when auto-scroll is enabled
- [x] 2.7 Wrap transcripts list in `NotificationListener<UserScrollNotification>` to detect manual scrolls and set `_isAutoScrollEnabled = false`
- [x] 2.8 Implement the floating "Sync to Video" button overlay that appears when auto-scroll is disabled, and clicking it scrolls the active cue and restores auto-scroll
