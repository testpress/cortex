# assessment-detail-live-data Specification

## Purpose
TBD - created by archiving change integrate-study-assessment. Update Purpose after archive.
## Requirements
### Requirement: Assessment Prescreen and Player Launch
The system MUST provide a structured prescreen entry point for assessment lessons and launch into a dedicated quiz-mode player.

#### Scenario: Open assessment from study list
- **WHEN** a learner opens an assessment lesson from the study chapter list
- **THEN** the system SHALL display `ExamPrescreen` with assessment metadata and attempt history
- **AND** the system SHALL NOT display offline download actions or mode selection sheets

#### Scenario: Start or resume assessment attempt
- **WHEN** the learner taps start or resume on the assessment prescreen
- **THEN** the system SHALL navigate to `/study/assessment/:id/player` in quiz mode (`isQuizMode: true`)

### Requirement: Answer and Progress Hydration on Resume
The system MUST restore previous answers and question position when resuming an assessment attempt.

#### Scenario: Resume in-progress attempt
- **WHEN** an assessment attempt is resumed
- **THEN** the system SHALL hydrate previously selected options, checked statuses, and last-viewed question position from the attempt state

### Requirement: Pause and Exit Confirmation
The system MUST protect in-progress assessment attempts from accidental dismissal.

#### Scenario: Exit during active attempt
- **WHEN** the learner navigates back or taps exit during an active attempt
- **THEN** the system SHALL display `PauseConfirmationDialog` allowing the learner to pause, submit, or cancel
- **AND** pausing SHALL save progress, reset local state, and invalidate cached lesson and attempt providers

### Requirement: Assessment Review Navigation
The system MUST provide navigation to post-attempt analytics and answer review screens.

#### Scenario: Review completed assessment
- **WHEN** the learner selects review on a completed attempt
- **THEN** the router SHALL navigate to `/study/assessment/:id/review-analytics` and support sub-routes for subject performance and answer key details

