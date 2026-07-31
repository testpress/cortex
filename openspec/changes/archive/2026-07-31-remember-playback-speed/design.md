## Context

The video player is `CustomVideoPlayer` in `packages/courses`, backed by `tpstreams_player_sdk` (v2.2.26). The SDK exposes `TestpressPlayerController.setPlaybackSpeed(double)` — the only speed API. There is no SDK-level initial-speed property, no speed getter, and no "user changed speed" callback, so the speed must be applied once the controller exists and user-initiated changes must be inferred.

App-wide persistent settings live in a singleton `AppSettingsTable` (drift) in `packages/core`, modeled via `settings_models.dart` (`PlaybackSettings` currently holds `quality` and `autoPlayNext`).

## Goals / Non-Goals

**Goals:**
- Restore the last-used playback speed globally when a video loads, without dialogs.
- Provide a single **Remember Playback Speed** toggle (On/Off) under playback settings.
- Persist the toggle and the remembered speed across app sessions.
- Show a subtle, non-blocking notification with a **Reset** action when a non-default speed is restored.
- Never delay or interrupt playback while restoring speed.

**Non-Goals:**
- Per-course speed preferences (dropped — course lifecycle/cleanup complexity not justified by value).
- Backend/server-side sync of playback speed preferences (local-only).
- Remembering other player settings (quality, mute, subtitles).
- Changing the SDK player UI; the native speed picker stays as-is.

## Decisions

### 1. Storage: extend the existing `AppSettingsTable` singleton
- **Option A**: Add columns to the singleton `AppSettingsTable`.
- **Option B**: New dedicated table for speed preferences.
- **Decision**: **Option A**. The table already holds playback-related settings (quality, auto-play). Two additive columns: `rememberPlaybackSpeed` (bool, default false) and `globalPlaybackSpeed` (real, nullable). A per-course map is explicitly avoided per non-goals.

### 2. Toggle: `rememberPlaybackSpeed` boolean
- Persisted as a bool column defaulting to `false` (opt-in). Mirrors how `autoPlayNext` is stored. When Off, saved speeds are ignored and speed changes are never persisted.

### 3. Restore flow: apply after controller creation
- The SDK only allows speed changes after the controller exists (`setPlaybackSpeed`). In `_onPlayerCreated`, after watermark setup:
  1. If `rememberPlaybackSpeed` is Off → speed 1x, no restore.
  2. If On and `globalPlaybackSpeed` is set → use it.
  3. Otherwise → 1x.
- Call `controller.setPlaybackSpeed(speed)` once. Fire-and-forget and non-blocking.

### 4. Persist on user change: infer rate from position deltas
- The native SDK speed picker lives inside the player UI; the app owns no selection event, and the SDK exposes no speed getter. In `_onPlayerCreated`'s listener, while playing steadily (no buffering/seek/pause), compute the measured rate as Δposition / Δwall-time over successive position ticks. When a stable measured rate differs from the last persisted speed, write it to `globalPlaybackSpeed`. Guards: ignore samples during buffering, seeks, or paused playback to avoid false writes.

### 5. Non-blocking confirmation with Reset
- When a restored speed > 1x, show a transient snackbar ("Playing at 3x · Reset") that auto-dismisses — no modal dialog.
- Tapping **Reset** sets the current video to 1x immediately (`setPlaybackSpeed(1.0)`) **and** persists 1x as the remembered speed, so subsequent videos also start at 1x.

### 6. Where the toggle lives
- Add the toggle under the existing playback preferences section in App Settings (which already hosts video quality and auto-play controls), reusing the `_buildToggleOption` pattern.

## Risks / Trade-offs

- **Risk**: SDK has no initial-speed property, so speed applies a moment after playback starts (a brief 1x frame may be perceptible).
  - *Mitigation*: apply `setPlaybackSpeed` immediately in `_onPlayerCreated`; the flash is typically imperceptible during buffering.
- **Risk**: No SDK speed event/getter, so persistence relies on inferred rate from position deltas; buffering hiccups could produce a false reading.
  - *Mitigation*: only sample during continuous playback with no seek/pause/buffer; require several consistent samples before persisting; quantize to the standard speeds the player offers (0.5, 0.75, 1, 1.25, 1.5, 2, 3) to reject transient noise.
- **Risk**: Schema migration on the drift table.
  - *Mitigation*: drift handles additive columns; default values keep existing rows valid.
