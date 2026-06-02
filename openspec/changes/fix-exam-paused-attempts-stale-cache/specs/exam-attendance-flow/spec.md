## MODIFIED Requirements

### Requirement: Exam Detail Pre-Flight Summary
The exams package SHALL provide a `ExamPrescreen` that summarizes exam duration, question count, and marks. The exam metadata fetched for the prescreen SHALL be persisted to the local Drift database and served using a Stale-While-Revalidate (SWR) strategy:
- On every open, the last-cached metadata SHALL be shown instantly without a loading shimmer (if a cache entry exists).
- A background network fetch SHALL always be triggered on open.
- If the server returns metadata different from the cached version, the UI SHALL update automatically, EXCEPT that if the paused attempts count has been updated locally within the last 5 minutes, the local count SHALL take precedence over the server's count to guard against stale CDN/API responses.
- The 5-minute guard timestamp for local updates SHALL persist across app restarts.
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

#### Scenario: Stale server update ignored after app restart
- **WHEN** the user ends or pauses the exam, restarts the app within 5 minutes, and opens the prescreen
- **THEN** the background fetch's stale `paused_attempts_count` from the server SHALL NOT overwrite the local database cache

#### Scenario: Active section is terminated when ending the exam
- **WHEN** the user ends the exam
- **THEN** the active running section SHALL be terminated (PUT request sent to the section's end URL) before the overall exam attempt is ended
