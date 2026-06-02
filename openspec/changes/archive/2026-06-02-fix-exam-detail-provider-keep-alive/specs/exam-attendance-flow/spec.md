## MODIFIED Requirements

### Requirement: Exam Detail Pre-Flight Summary
The exams package SHALL provide a `ExamPrescreen` that summarizes exam duration, question count, and marks. The exam metadata fetched for the prescreen SHALL be persisted to the local Drift database and served using a Stale-While-Revalidate (SWR) strategy:
- On every open, the last-cached metadata SHALL be shown instantly without a loading shimmer (if a cache entry exists).
- A background network fetch SHALL always be triggered on open.
- If the server returns metadata different from the cached version, the UI SHALL update automatically.
- The cache SHALL survive app restarts (stored in SQLite).

#### Scenario: Summarizes metadata correctly
- **WHEN** a user visits an exam overview
- **THEN** it displays the duration, question count, and scoring schemes retrieved from the API

#### Scenario: No shimmer on repeat open within session
- **WHEN** a user closes and reopens the prescreen for the same exam within a session
- **THEN** the metadata is served from the in-memory provider cache instantly
- **THEN** no shimmer skeleton is shown

#### Scenario: No shimmer after app restart (warm cache)
- **WHEN** a user kills and relaunches the app and opens the prescreen for a previously visited exam
- **THEN** the cached metadata from the local database is displayed instantly without a shimmer
- **THEN** a background network request is made to check for updates

#### Scenario: Silent update on changed metadata
- **WHEN** the background fetch returns metadata that differs from the cached version
- **THEN** the UI SHALL update to show the new values without any loading shimmer

#### Scenario: First ever open (cold cache)
- **WHEN** a user opens the prescreen for an exam that has never been fetched
- **THEN** a shimmer is shown while the network request completes
- **THEN** on success the metadata is stored in the local database and shown
