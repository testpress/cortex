# video-lesson-viewer Specification

## Purpose
TBD - created by archiving change video-ai-chat-mcq. Update Purpose after archive.
## Requirements
### Requirement: LearnLens Metadata Parsing & Persistence
The system SHALL parse `is_ai_enabled`, `can_enable_learnlens_ai`, `learnlens_asset_id`, and `learnlens_asset_status` from the video lesson API payload and persist them in the local database.

#### Scenario: Parsing Lesson Payload
- **WHEN** a video lesson payload is fetched
- **THEN** `LessonDto` extracts `is_ai_enabled`, `can_enable_learnlens_ai`, `learnlens_asset_id`, and `learnlens_asset_status` from the `video` JSON object and stores them in `LessonsTable`.

### Requirement: AI Tab Orchestration
The system SHALL orchestrate the visibility of AI-related tabs based on backend flags.

#### Scenario: Enabling AI Tabs
- **WHEN** a lesson has `is_ai_enabled: true`, `can_enable_learnlens_ai: true`, and `learnlens_asset_status: "Completed"`
- **THEN** the system renders the AI Chat and MCQ tabs in the video subtabs view.

#### Scenario: Disabling AI Tabs
- **WHEN** any of the required AI flags (`is_ai_enabled`, `can_enable_learnlens_ai`, or `learnlens_asset_status == "Completed"`) are false/missing
- **THEN** the system hides the AI Chat and MCQ tabs.

### Requirement: TPStreams Asset Identifier
The system SHALL treat the root-level content `uuid` as the TPStreams asset identifier for video lessons, and SHALL NOT use `contentUrl` for that purpose.

#### Scenario: Video lesson with root uuid
- **WHEN** a video lesson payload is fetched with a root-level `uuid`
- **THEN** `LessonDto` SHALL capture it in the dedicated `uuid` field and persist it in `LessonsTable`
- **AND** the TPStreams video player SHALL be initialized with `lesson.uuid` as its asset id
- **AND** the AI Chat and MCQ tabs SHALL use `lesson.uuid` as the TPStreams asset id

#### Scenario: Video lesson without root uuid
- **WHEN** a video lesson payload has no root-level `uuid`
- **THEN** the video player and AI/MCQ tabs SHALL receive a null asset id and handle it gracefully

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

