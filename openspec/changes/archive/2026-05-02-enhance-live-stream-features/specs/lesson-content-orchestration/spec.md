## ADDED Requirements

### Requirement: Live Stream Metadata Enrichment
The system MUST correctly parse and expose live-stream specific metadata including stream URLs and current status from the content API.

#### Scenario: Parsing Live Stream Content
- **WHEN** the content API returns a "Live Stream" content type with a `live_stream` object
- **THEN** the system SHALL extract `stream_url` for media playback.
- **AND** it SHALL map the `status` to appropriate `isRunning` and `isUpcoming` flags.
- **AND** it SHALL parse `show_recorded_video` to determine if recorded content should be displayed after the stream ends.

### Requirement: Scheduled Content Handling
The system SHALL gracefully handle content that is not yet released by parsing the scheduled message from 403 Forbidden API responses.

#### Scenario: Displaying scheduled message
- **WHEN** the content API returns a 403 Forbidden with error code "scheduled"
- **THEN** the system SHALL parse the provided message into the lesson domain model.
- **AND** it SHALL display a placeholder UI with the scheduled message instead of the standard viewer.
