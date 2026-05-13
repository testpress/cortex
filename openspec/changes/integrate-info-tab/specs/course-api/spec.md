## ADDED Requirements

### Requirement: Tab-Specific Stream Filtering
The repository SHALL provide dedicated streams for Study, Exam, and Info courses based on their tags and metadata to ensure correct content separation in the UI.

#### Scenario: Filtering the Info stream
- **WHEN** the `watchInfoCourses` stream is requested
- **THEN** the system MUST filter the local database for courses whose `tags` field contains the string `info`.
- **AND** only include entries whose `allowedDevices` explicitly permit mobile access.

#### Scenario: Correcting Study tab leakage
- **WHEN** the `watchStudyCourses` stream is requested
- **THEN** the system MUST exclude courses with the `info` tag when the Info tab is enabled.
- **AND** exclude courses identified as Exam content when the Exam tab is enabled.

### Requirement: Tagged Course Synchronization
The system SHALL support fetching and upserting courses filtered by tags.

#### Scenario: Syncing Info courses
- **WHEN** `refreshCourses(tags: 'info')` is called
- **THEN** the system MUST fetch page 1 of the tagged API results
- **AND** upsert them into the local database with their associated tags preserved.
