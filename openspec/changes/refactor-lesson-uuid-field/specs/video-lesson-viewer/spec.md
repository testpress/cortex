## ADDED Requirements
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
