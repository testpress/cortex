## ADDED Requirements

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

### Requirement: Historical Attempts Log
The `ExamPrescreen` SHALL fetch and present previous exam attempts in a structured table.

#### Scenario: Previous attempts rendered
- **WHEN** the previous attempts load successfully
- **THEN** it displays Date, Score, Correct and Incorrect counts with a review CTA

### Requirement: Resume Paused Exam Attempt
The system SHALL check for a paused attempt using the `paused_attempts_count` field from the Exam API. If an attempt is paused, the CTA SHALL be updated to allow resuming, and the system SHALL fetch the running attempt and start the exam from where it left off instead of creating a new attempt. The `AttemptDto` SHALL map the attempt's `state` field correctly to ensure running attempts (state == "Running") are identified.

#### Scenario: Existing paused attempt
- **WHEN** an exam has `paused_attempts_count > 0`
- **THEN** the Prescreen CTA displays "Resume Exam Online"
- **THEN** tapping the CTA triggers the attempt's start URL and restores the session
- **THEN** the fetched attempt object MUST contain a valid non-null `state` string corresponding to its progress state

#### Scenario: Paused attempts count is non-zero but attempts list is empty
- **WHEN** `paused_attempts_count > 0` but fetching attempts returns an empty list
- **THEN** the system SHALL fall back to creating a new attempt instead of throwing a StateError

### Requirement: Pause Confirmation Dialog
The system SHALL intercept exit navigation during an active exam to prevent accidental loss of context. A confirmation dialog MUST be presented before safely exiting and pausing the exam.

#### Scenario: Accidental back navigation
- **WHEN** the user presses the system back button or exit icon during an exam
- **THEN** a dialog appears asking if they want to pause the exam
- **THEN** clicking "Cancel" keeps them in the exam
- **THEN** clicking "Pause" exits the exam screen and pauses the attempt

### Requirement: Option Selection Indicator Rendering
The system SHALL ensure that custom HTML option selection indicators (radio buttons and checkboxes) in the active question card WebView are rendered correctly and not stripped out during HTML post-processing / clean-up.

#### Scenario: Rendering Exam Question Options
- **WHEN** a question card is rendered in the WebView (AppHtml)
- **THEN** the radio buttons and checkboxes MUST be fully visible and functional in the options list.

### Requirement: Subject Mapping Preservation
The system SHALL request attempt questions by substituting `v2.3` with `v2.2.1` in the questions endpoint URL. This ensures correct subject name groupings are returned for all questions, enabling proper subject/section tab bar rendering, matching the legacy Android SDK behavior.

#### Scenario: Fetching Questions in Exam Attempt
- **WHEN** a questions endpoint containing `v2.3` is invoked to load questions for an active attempt
- **THEN** the request SHALL instead be translated to `v2.2.1` before execution
- **THEN** the response questions MUST map correct subject names (e.g. "PHYSICS", "CHEMISTRY", "BIOLOGY") instead of "Uncategorized", unlocking the subject tabs

### Requirement: Exam Settings Preservation
The temporary `ExamDto` instantiated for course-linked attempts MUST preserve settings such as `disableAttemptResume`, `allowRetake`, and `maxRetakes` from the active lesson and cached exam metadata.

### Requirement: Option Selection Indicator Parent Preservation
The system SHALL protect parent wrapper elements (like empty divs or paragraphs) of `.indicator` elements from being stripped out during HTML cleanup by querying if they contain any `.indicator` descendants.

