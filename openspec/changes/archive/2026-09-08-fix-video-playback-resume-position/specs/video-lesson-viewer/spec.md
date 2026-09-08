## ADDED Requirements

### Requirement: Continuous Video Playback Progress Buffering
The system SHALL buffer video position and watched time ranges at a regular interval during continuous playback without requiring user interaction (seek/pause).

#### Scenario: Uninterrupted Video Watching Progress Buffering
- **WHEN** a user watches a video continuously for more than 10 seconds without pausing or seeking
- **THEN** the video player SHALL periodically flush watched time ranges and current position to the attempt notifier
- **AND** the attempt notifier SHALL store updated position locally and sync to backend respecting the 60-second minimum request rate limit.

### Requirement: App Backgrounding Force Sync
The system SHALL trigger an immediate force sync of pending video watched time ranges when the app state transitions to backgrounded (`paused` or `inactive`).

#### Scenario: App Force Quit or Backgrounded During Playback
- **WHEN** the app enters backgrounded or inactive lifecycle state while a video is playing or paused
- **THEN** the system SHALL immediately execute a force sync to transmit unsaved video watched position to the backend.

### Requirement: Flexible Stored Duration Parsing
The system SHALL parse stored video position strings in both decimal seconds format (`"125.4"`) and time-formatted strings (`"00:02:05"` or `"02:05"`) when initializing the video player initial position.

#### Scenario: Resuming Playback from Formatted Time String
- **WHEN** a lesson's `lastWatchedDuration` is stored as a formatted timestamp string `"00:02:05"`
- **THEN** the system SHALL parse the timestamp into the equivalent duration (125 seconds) and set `initialPosition` accordingly instead of defaulting to 0.0.
