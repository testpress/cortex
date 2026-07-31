## MODIFIED Requirements

### Requirement: Transcript Rendering States
The system SHALL display the transcription status in the Transcript tab.

#### Scenario: Transcription in progress
- **WHEN** `enable_transcript` is true but `job_status` in `video_subtitle` is NOT "COMPLETED" (e.g. "IN_PROGRESS" or null)
- **THEN** the system MUST display a localized message "Transcription in progress" in the Transcript tab

#### Scenario: Transcription completed
- **WHEN** `enable_transcript` is true and `job_status` in `video_subtitle` is "COMPLETED"
- **THEN** the system MUST fetch the VTT file from `url` in `video_subtitle` and display the parsed subtitles
- **AND** the transcript UI MUST display the timestamp and transcript text in a compact, inline layout with no large gap between them
- **AND** the currently speaking cue matching the video playback time MUST be highlighted with bold font weight

## ADDED Requirements

### Requirement: Transcript Video Synchronization and Auto-Scrolling
The system SHALL synchronize the transcript's scroll position with the video playback position, unless overridden by manual user scrolling.

#### Scenario: Auto-scrolling transcript with playback
- **WHEN** the video is playing and the active transcript cue changes
- **AND** auto-scroll is enabled
- **THEN** the system MUST automatically scroll the transcript container to bring the active cue into view

#### Scenario: Manual scroll disables auto-scroll
- **WHEN** the user manually scrolls the transcript container
- **THEN** the system MUST disable auto-scrolling
- **AND** the system MUST display a "Sync to Video" overlay button

#### Scenario: Re-enabling auto-scroll
- **WHEN** the user clicks the "Sync to Video" overlay button
- **THEN** the system MUST re-enable auto-scrolling
- **AND** immediately scroll the active cue back into view
