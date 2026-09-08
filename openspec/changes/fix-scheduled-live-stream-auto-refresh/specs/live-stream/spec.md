## Purpose

Enables automatic background status polling, accurate local cache synchronization, and clear stream lifecycle status notices (scheduled, live, and concluded/recording processing) for live stream sessions.

## ADDED Requirements

### Requirement: Scheduled Live Stream Active State Cache Synchronization
The system SHALL ensure that when fresh lesson detail metadata is fetched from the server with `isScheduled == false`, the local storage cache is updated with `isScheduled = false`, overwriting any previously cached `isScheduled = true` state.

#### Scenario: Live stream becomes active on backend
- **WHEN** a scheduled live stream starts on the backend and fresh lesson details are fetched
- **THEN** `isScheduled` in local storage SHALL be updated to `false`
- **AND** any existing scheduled status message SHALL be cleared

### Requirement: Scheduled Live Stream Periodic Refresh
The system SHALL run a periodic 5-second refresh timer while a live stream is in the scheduled state (`isScheduled == true`) and active in the detail viewer.

#### Scenario: Periodic background status check during scheduled state
- **WHEN** a user views a scheduled live stream
- **THEN** the system SHALL poll the lesson detail endpoint every 5 seconds
- **AND** when the API returns an active status (`isScheduled == false`), the UI SHALL automatically rebuild and render the video player or session lobby
- **AND** the periodic refresh timer SHALL be cancelled

### Requirement: Live Stream Concluded Notice
The system SHALL display an informative notice when a live stream has ended by the host and the recording is not yet ready (`showRecordedVideo == false`).

#### Scenario: Live stream ended without recording ready
- **WHEN** a live stream has status `completed` or `ended` and `showRecordedVideo` is `false`
- **THEN** the system SHALL display a message stating "This live stream has been ended by host" and "The recording of the same will be available here once it is ready"
