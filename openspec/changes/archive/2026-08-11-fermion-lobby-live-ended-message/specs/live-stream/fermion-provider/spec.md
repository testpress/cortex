# live-stream/fermion-provider Delta Specification

## MODIFIED Requirements

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
