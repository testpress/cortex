## MODIFIED Requirements

### Requirement: Local database as single source of truth
The system SHALL persist all LMS domain data (courses, chapters, lessons, live classes, forum threads, user progress) in a local Drift SQLite database. All UI components SHALL read exclusively from the local database, never directly from the network or mock source.

#### Scenario: App displays courses from local DB on launch
- **WHEN** the app launches with a populated local database
- **THEN** the course list screen displays cached courses immediately with no network call

#### Scenario: UI updates automatically when DB changes
- **WHEN** a network sync writes new course data to the local database
- **THEN** any widget watching the course stream updates without explicit navigation or refresh

#### Scenario: App works offline after initial load
- **WHEN** the device has no network connectivity
- **AND** the local database contains previously synced data
- **THEN** the user SHALL be able to browse courses, chapters, and lessons using the locally cached data

#### Scenario: Lesson payload persists clean media URLs
- **WHEN** a lesson is synced from the DataSource
- **THEN** the system SHALL store the `contentUrl` directly in the database, replacing the complex `contentJson` list format

## REMOVED Requirements

### Requirement: Rich-text atoms in Lesson Payload
**Reason**: Replaced by single `contentUrl` for media-based lessons (PDF/Video). The backend will not provide raw text atoms for lessons.
**Migration**: Use the new `contentUrl` field in `LessonDto` and `LessonsTable` to provide a direct link to the lesson media.
