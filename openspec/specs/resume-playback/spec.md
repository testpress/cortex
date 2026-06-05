# resume-playback Specification

## Purpose
TBD - created by archiving change resume-playback. Update Purpose after archive.
## Requirements
### Requirement: Fetch and Initialize Video Player Progress
The system SHALL retrieve the last watched position for Video lessons and initialize the player at that position to allow seamless resume playback.

#### Scenario: Opening a video lesson with existing progress
- **WHEN** the user opens a Video lesson that has a non-zero `last_position` from the `attempts_url` API
- **THEN** the video player SHALL initialize and seek to that specific position.

#### Scenario: Opening a non-video lesson
- **WHEN** the user opens a lesson that is NOT a Video type
- **THEN** the system SHALL NOT fetch the `attempts_url` API and SHALL load the lesson normally.

### Requirement: Track Watched Time Ranges
The system SHALL track the intervals of time the user watches during the current session, capturing continuous playback as delta ranges.

#### Scenario: Continuous playback tracking
- **WHEN** the user plays the video
- **THEN** the system SHALL track the start and end positions to form a continuous watched time range.

#### Scenario: Pausing or seeking creates a new range
- **WHEN** the user pauses or seeks the video player
- **THEN** the system SHALL commit the current continuous time range to the delta list and prepare for a new range when playback resumes.

### Requirement: Sync Delta Video Progress
The system SHALL synchronize the user's `last_watch_position` and newly tracked `watched_time_ranges` (delta ranges) to the server.

#### Scenario: Periodic background sync
- **WHEN** the user has been watching the video for 5 minutes
- **THEN** the system SHALL POST the delta ranges to the update API and clear the local delta list upon success.

#### Scenario: Event-driven sync on pause or seek
- **WHEN** the user pauses or seeks the video, and the debounce period (2-3 seconds) expires
- **THEN** the system SHALL POST the delta ranges to the update API and clear the local delta list upon success.

#### Scenario: Event-driven sync on back navigation
- **WHEN** the user navigates back from the video player screen
- **THEN** the system SHALL POST the delta ranges to the update API immediately before disposing the player.

