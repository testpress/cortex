# live-stream/fermion-provider Specification

## Purpose
Enables the app to identify Fermion-provided live sessions and present a dedicated lobby screen with a "Join Now" action that opens the session embed URL in a full-screen WebView, instead of attempting to play a video stream.
## Requirements
### Requirement: Provider Identification
The system SHALL read the `provider` field from the `live_stream` API object and propagate it through the data layer so that the UI can branch on the live stream provider.

#### Scenario: Fermion provider is identified
- **WHEN** a lesson API response contains `live_stream.provider == "Fermion"`
- **THEN** the lesson model SHALL expose `liveStreamProvider` as `"Fermion"`

#### Scenario: TpStreams provider is identified
- **WHEN** a lesson API response contains `live_stream.provider == "TpStreams"`
- **THEN** the lesson model SHALL expose `liveStreamProvider` as `"TpStreams"`

#### Scenario: Missing provider field
- **WHEN** the API response omits the `live_stream.provider` field
- **THEN** the lesson model SHALL expose `liveStreamProvider` as `null` and existing TpStreams behaviour SHALL apply

### Requirement: Fermion Lobby Screen
The system SHALL render a lobby/detail screen for Fermion live sessions instead of an inline video player. The lobby screen SHALL NOT display the session title or a main header icon (since the title is already displayed in the page header). The lobby screen SHALL display a context-appropriate action button based on the session status.
Additionally, the lobby screen SHALL display the session duration (represented in minutes, e.g., "60 minutes") and the session start time (formatted like "dd MMM yyyy, hh.mm a", e.g., "10 Aug 2026, 11.38 AM") if available.

#### Scenario: Running Fermion session shows "Attend Class"
- **WHEN** a user opens a Fermion lesson with `streamStatus == "Running"` and `contentUrl` is non-empty
- **THEN** the system SHALL display a lobby screen containing a prominent "Attend Class" button

#### Scenario: Completed Fermion session with recording shows "Watch Recording"
- **WHEN** a user opens a Fermion lesson with `streamStatus == "Completed"` and `showRecordedVideo == true`
- **THEN** the system SHALL display a lobby screen containing a "Watch Recording" button
- **AND** tapping "Watch Recording" SHALL open the same Fermion embed URL in a full-screen WebView (the embed URL serves the recording)

#### Scenario: Completed Fermion session without recording shows ended notice
- **WHEN** a user opens a Fermion lesson with `streamStatus == "Completed"` and `showRecordedVideo == false`
- **THEN** the system SHALL display a clear ended notice on the lobby card.
- **AND** the ended notice SHALL feature:
  - An alert icon (LucideIcons.alertCircle)
  - A prominent status title ("Recording Not Available")
  - A clear explanation message ("No recording is available for this class.")
  - Styled as a plain metadata row with the icon in warning color to match the card's row layout.

#### Scenario: Scheduled Fermion session shows scheduled state
- **WHEN** a Fermion live session has `isScheduled == true`
- **THEN** the system SHALL display the scheduled message view (calendar icon + message) instead of any action button, consistent with the TpStreams scheduled behaviour

### Requirement: WebView Launch on Join
The system SHALL navigate to a full-screen WebView loaded with the Fermion embed URL when the user taps "Join Now".

#### Scenario: Tapping "Join Now" opens WebView
- **WHEN** the user taps the "Join Now" button on a Fermion lobby screen
- **THEN** the system SHALL push a full-screen WebView screen onto the navigation stack
- **AND** the WebView SHALL load the URL stored in `lesson.contentUrl` (the Fermion embed URL)

#### Scenario: WebView displays Fermion session
- **WHEN** the Fermion WebView is open
- **THEN** the user SHALL be able to interact with the embedded Fermion live session (video, chat, etc.)
- **AND** navigation away from the embed URL SHALL be prevented (blocked by the WebView delegate)

### Requirement: TpStreams Behaviour Unchanged
The system SHALL preserve the existing inline video-player experience for all TpStreams live sessions. The TPStreams asset identifier SHALL be sourced from the root-level content `uuid`, while `contentUrl` SHALL remain a real URL (e.g. the Fermion embed URL).

#### Scenario: TpStreams live stream plays inline
- **WHEN** a user opens a lesson with `liveStreamProvider == "TpStreams"` or `liveStreamProvider == null`
- **THEN** the system SHALL render the existing `CustomVideoPlayer` inline experience
- **AND** the TPStreams player SHALL be initialized with `lesson.uuid` as its asset id

### Requirement: Live Stream Root UUID Persistence
The system SHALL capture the root-level content `uuid` for live stream lessons and persist it in the local database.

#### Scenario: Live stream with root uuid
- **WHEN** a live stream lesson payload is fetched with a root-level `uuid`
- **THEN** `LessonDto` SHALL capture it in the dedicated `uuid` field and persist it in `LessonsTable`

