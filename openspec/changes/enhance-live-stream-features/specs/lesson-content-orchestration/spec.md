## ADDED Requirements

### Requirement: Live Stream Metadata Enrichment
The system MUST correctly parse and expose live-stream specific metadata including stream URLs and current status from the content API.

#### Scenario: Parsing Live Stream Content
- **WHEN** the content API returns a "Live Stream" content type with a `live_stream` object
- **THEN** the system SHALL extract `stream_url` for media playback.
- **AND** it SHALL map the `status` to appropriate `isRunning` and `isUpcoming` flags.
- **AND** it SHALL parse `show_recorded_video` to determine if recorded content should be displayed after the stream ends.
