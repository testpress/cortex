## MODIFIED Requirements
### Requirement: TpStreams Behaviour Unchanged
The system SHALL preserve the existing inline video-player experience for all TpStreams live sessions. The TPStreams asset identifier SHALL be sourced from the root-level content `uuid`, while `contentUrl` SHALL remain a real URL (e.g. the Fermion embed URL).

#### Scenario: TpStreams live stream plays inline
- **WHEN** a user opens a lesson with `liveStreamProvider == "TpStreams"` or `liveStreamProvider == null`
- **THEN** the system SHALL render the existing `CustomVideoPlayer` inline experience
- **AND** the TPStreams player SHALL be initialized with `lesson.uuid` as its asset id

## ADDED Requirements
### Requirement: Live Stream Root UUID Persistence
The system SHALL capture the root-level content `uuid` for live stream lessons and persist it in the local database.

#### Scenario: Live stream with root uuid
- **WHEN** a live stream lesson payload is fetched with a root-level `uuid`
- **THEN** `LessonDto` SHALL capture it in the dedicated `uuid` field and persist it in `LessonsTable`
