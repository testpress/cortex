# exam-prescreen-ui Specification

## Purpose
TBD - created by archiving change refactor-exam-prescreen-layout. Update Purpose after archive.
## Requirements
### Requirement: Exam Prescreen Full-Screen Immersive Routing
The system SHALL launch the Exam Prescreen view as a completely full-screen immersive route, dismissing or drawing over the app's bottom navigation shell.

#### Scenario: Launching exam from dashboard
- **WHEN** user taps on an exam content card from the dashboard
- **THEN** system pushes the exam prescreen without the bottom navigation bar visible

### Requirement: Realistic Skeleton Placeholders
The system SHALL display realistic bounding box text strings during metadata loading to guarantee properly scaled skeleton bones.

#### Scenario: Loading exam metadata
- **WHEN** the exam metadata is still fetching from the network
- **THEN** system injects `'120'`, `'+1.0 Marks'`, and placeholder dates into the metadata cards to maintain visual scale
- **THEN** system neutralizes all accent colors to `textSecondary` until loading completes

### Requirement: v2.4 and V3 Exam API Conformance
The HTTP data source and repositories SHALL utilize `v2.4` and `v2.3` endpoints for Exam, Review, and Attempts data, while safely handling newer V3 exam structures (e.g. section-level exams).

#### Scenario: Fetching historical attempts
- **WHEN** the system queries historical attempts
- **THEN** it correctly parses the new schema response using the centralized debouncer, preventing duplicate concurrent calls

### Requirement: V3 Heartbeat Synchronization Independence
The system SHALL correctly handle V3 exam attempts by ensuring legacy heartbeat responses do not artificially terminate the exam.

#### Scenario: Running a V3 exam attempt
- **WHEN** the system sends a periodic heartbeat during a V3 exam attempt
- **THEN** it ignores the `0:00:00` fallback remaining time returned by the legacy endpoint
- **THEN** it relies strictly on the local timer rather than aggressively syncing timer states from heartbeat polling

### Requirement: Answer Review State Persistence
The exam repository SHALL strictly preserve local review and result states across answer submissions to prevent UI regressions during navigation.

#### Scenario: Marking a question for review
- **WHEN** the user marks a question for review and proceeds to the next question
- **THEN** the system seamlessly copies the `review` and `result` flags into the updated `AnswerDto` during the asynchronous submission cycle
- **THEN** the question correctly retains its "marked for review" status in the UI

