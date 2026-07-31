## Context

Currently, the `TranscriptsTab` lists WebVTT cues statically. The video player does not expose its current playback time to the tab, and the tab UI is spaced widely with the timestamp separated from the text in a grid/row layout.

## Goals / Non-Goals

**Goals:**
* Highlighting: Display the currently spoken cue in bold text.
* Auto-scrolling: Keep the active cue centered in the viewport.
* Scroll override: Let the user scroll manually, disabling auto-scroll and showing a "Sync to Video" floating button.
* Compact UI: Modernize the list layout to look like YouTube (timestamp inline or tightly aligned with the cue text).

**Non-Goals:**
* Supporting multiple subtitle languages (out of scope, backend only provides one URL).
* Persisting the scroll override state across screen visits.

## Decisions

### 1. Broadcasting Playback Position
* **Option A**: Use a global Riverpod state provider.
* **Option B**: Pass a `ValueNotifier<Duration>` from the parent `VideoLessonViewer` down to the video player and transcripts tab.
* **Decision**: **Option B**. A `ValueNotifier` keeps the state scoped to the video viewer screen lifecycle and avoids global provider overhead.

### 2. Layout & Scrolling Mechanism
* **Option A**: Using `ScrollController.animateTo(index * estimatedHeight)`.
* **Option B**: Using `Scrollable.ensureVisible(context)`.
* **Decision**: **Option B**. Since cue lengths vary, `Scrollable.ensureVisible` dynamically and accurately scrolls the exact widget into view without hardcoded heights. We will maintain a map of `GlobalKey`s for each cue.

### 3. YouTube-Like Compact UI Layout
* **Decision**: Layout the timestamp and transcript inline using a clean Flow/Row or continuous RichText design where the timestamp is positioned immediately next to or slightly above/before the text, minimizing layout padding.

## Risks / Trade-offs

* **Risk**: Excessive widget rebuilds due to rapid position updates from the video player.
  * *Mitigation*: The `TranscriptsTab` will listen to the position notifier but will only trigger a rebuild or scroll action if the *active cue index* actually changes, minimizing UI thread workload.
