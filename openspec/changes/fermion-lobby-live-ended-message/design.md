# Design — Fermion Lobby Live Ended Message

## Proposed Changes

### packages/core

#### [MODIFY] `app_en.arb`
- Add new localized strings:
  - `"liveStreamNoRecordingTitle": "Recording Not Available"`
  - `"liveStreamNoRecordingMessage": "No recording is available for this class."`

### packages/courses

#### [MODIFY] `fermion_lobby_view.dart`
- Replace internal `_LobbyAction` enum with `_LobbyViewState` to explicitly support distinct UI states: `running`, `completedWithRecording`, and `completedNoRecording`.
- Extract common metadata row layout into a unified `_buildInfoRow` helper method.
- In `_buildMetadataCard`, render the warning notice row using `_buildInfoRow` when `state == _LobbyViewState.completedNoRecording`:
  - Icon `LucideIcons.alertCircle` with color `design.colors.warning`.
  - Title text `"Recording Not Available"` and message text `"No recording is available for this class."` using `L10n.of(context)`.
- Delete redundant helper methods (`_buildDurationRow` and `_buildStartTimeRow`).
