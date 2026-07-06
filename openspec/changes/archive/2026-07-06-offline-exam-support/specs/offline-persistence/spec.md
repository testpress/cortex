## ADDED Requirements

### Requirement: Persist offline exam structure
The system SHALL persist the complete exam hierarchy (instructions, sections, questions, and choices) in the local database.

#### Scenario: Downloading an exam
- **WHEN** the user initiates an exam download
- **THEN** all structural data is saved to the local Drift database as `OfflineCourseAttempt` and related entities.

### Requirement: Local state tracking
The system SHALL record every user action (e.g. selecting an answer, marking for review) locally.

#### Scenario: Offline choice selection
- **WHEN** the user is in an offline exam and selects a choice
- **THEN** the selection is instantly saved to the local database as an `OfflineAttemptItem`.
