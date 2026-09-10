## Purpose

Enables users to pause and resume attachment and PDF file downloads, persisting progress across app restarts so large downloads are never lost on interruption.

## ADDED Requirements

### Requirement: User can pause an in-progress attachment download
The system SHALL allow the user to pause an attachment or PDF download that is currently in progress.

#### Scenario: Pause while downloading
- **WHEN** an attachment download is in progress and the user taps the pause action
- **THEN** the download is suspended and the item's status changes to `paused`

#### Scenario: Progress preserved on pause
- **WHEN** an attachment download is paused
- **THEN** the bytes already received are retained locally and the progress percentage is persisted

### Requirement: User can resume a paused attachment download
The system SHALL allow the user to resume a paused attachment or PDF download from where it left off.

#### Scenario: Resume from paused state
- **WHEN** an attachment download has status `paused` and the user taps the resume action
- **THEN** the download restarts from the previously saved byte offset and status changes to `downloading`

#### Scenario: Resume survives app restart
- **WHEN** the app is closed or killed while an attachment download is paused
- **THEN** on next app launch the download item is still visible with status `paused` and can be resumed by the user

### Requirement: Attachment download runs in the background
The system SHALL continue an active attachment download when the user navigates away from the download-initiating screen.

#### Scenario: Download persists while navigating
- **WHEN** an attachment download is in progress and the user navigates to another screen
- **THEN** the download continues and progress updates remain visible on the Downloads screen

#### Scenario: Download survives foreground/background transitions
- **WHEN** the user backgrounds the app during an active attachment download
- **THEN** the download SHALL continue and complete without user intervention (subject to OS background execution limits)

### Requirement: Pause/resume controls are visible for attachment downloads
The system SHALL display pause and resume action controls for attachment items in both the Downloads screen and the Attachment Viewer, consistent with the behaviour already present for video downloads.

#### Scenario: Pause icon shown while downloading
- **WHEN** an attachment download has status `downloading`
- **THEN** a pause action control is displayed on the download card and attachment viewer

#### Scenario: Resume icon shown while paused
- **WHEN** an attachment download has status `paused`
- **THEN** a resume action control is displayed on the download card and attachment viewer

### Requirement: Server must support byte-range requests for resumability
The system SHALL only attempt to resume a download if the download source supports HTTP Range requests.

#### Scenario: Server supports range requests
- **WHEN** the download URL responds with `Accept-Ranges: bytes`
- **THEN** the system resumes from the saved byte offset on resume

#### Scenario: Server does not support range requests
- **WHEN** the download URL does not support byte-range requests
- **THEN** the system restarts the download from zero on resume, discarding the partial file
