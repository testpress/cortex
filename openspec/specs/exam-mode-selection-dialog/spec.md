# Capability: Exam Mode Selection Dialog

## Purpose
Provides a pre-start choice for exams that support quiz mode, allowing users to enter the exam in either regular mode or quiz mode while keeping the existing Cortex exam UI and navigation patterns intact.

## Requirements

### Requirement: Quiz Mode Eligibility Detection
The system SHALL detect quiz-capable exams from the exam metadata and only present mode selection inline options when quiz mode is enabled.

#### Scenario: Quiz mode disabled
- **WHEN** the exam metadata does not enable quiz mode
- **THEN** the system SHALL show the exam start bottom sheet without mode selection options
- **AND** the start button SHALL be enabled by default to start in regular mode.

#### Scenario: Quiz mode enabled
- **WHEN** the exam metadata enables quiz mode
- **THEN** the system SHALL show the mode selection options inline inside the exam start bottom sheet.

### Requirement: Quiz Mode Uses the Same Exam APIs
The system SHALL start, resume, load questions for, submit answers for, and end quiz-mode attempts through the same exam backend endpoints used by regular attempts. Quiz mode SHALL be a client-side launch choice and session state, not a separate API contract.

#### Scenario: Quiz mode starts from the same backend contract
- **WHEN** the user selects Quiz Mode
- **THEN** the system SHALL create or resume the attempt using the existing exam attempt flow and URLs already present in the exam metadata
- **AND** it SHALL continue to use the same question loading, answer submission, heartbeat, and end-session APIs as regular mode.

#### Scenario: No quiz-only API fields are required
- **WHEN** the exam metadata includes `enable_quiz_mode`
- **THEN** the system SHALL treat it as the feature gate for presenting the dialog
- **AND** it SHALL NOT require a separate quiz-specific endpoint or a different attempt resource schema to start the exam, though it passes `attempt_type=1` when creating the attempt.

### Requirement: Mode Selection Dialog
The system SHALL present exactly two inline choices for mode selection directly within the exam start bottom sheet: Regular Mode and Quiz Mode.

#### Scenario: No selection disables start
- **WHEN** the exam supports both modes and no option is selected
- **THEN** the start/resume exam button SHALL be disabled.

#### Scenario: Regular mode selection
- **WHEN** the user selects Regular Mode
- **THEN** the system SHALL enable the start/resume exam button to start the exam in regular mode.

#### Scenario: Quiz mode selection
- **WHEN** the user selects Quiz Mode
- **THEN** the system SHALL enable the start/resume exam button to start the exam in quiz mode.

### Requirement: Mode Persistence
The system SHALL preserve the selected mode for the lifetime of the attempt so that paused or resumed sessions continue in the same mode.

#### Scenario: Resume quiz-mode attempt
- **WHEN** a quiz-mode attempt is resumed
- **THEN** the system SHALL restore quiz mode without showing the selection dialog again.

#### Scenario: Resume regular-mode attempt
- **WHEN** a regular-mode attempt is resumed
- **THEN** the system SHALL restore regular mode without showing the selection dialog again.

### Requirement: Quiz Mode Metadata Compatibility
The system SHALL continue to honor the existing exam metadata fields that already drive the regular exam flow, including attempt URLs, start URLs, pause/resume counts, and duration handling, while using `enable_quiz_mode` only to decide whether the choice dialog should appear.

#### Scenario: Existing metadata remains authoritative
- **WHEN** a quiz-capable exam is launched
- **THEN** the system SHALL still respect the current attempt and resume URLs from the exam metadata
- **AND** the system SHALL keep using the existing duration, paused-attempt, and retake fields already used by regular exam mode.

### Requirement: Quiz Question Check Flow
The quiz mode question flow SHALL require an explicit check action before revealing correctness feedback or advancing to the next question.

#### Scenario: Selecting an option does not reveal the answer
- **WHEN** the user taps an answer option in quiz mode
- **THEN** the system SHALL record the selection for the current question
- **AND** it SHALL NOT show the correct answer, explanation, or next-question state yet.

#### Scenario: Checking an answer
- **WHEN** the user taps the quiz mode `Check` action
- **THEN** the system SHALL submit the selected answer state for the current question
- **AND** it SHALL display the review state for that question.

#### Scenario: Continuing after review
- **WHEN** the question has been checked and the review state is visible
- **THEN** the primary action SHALL change to `Continue`
- **AND** tapping `Continue` SHALL advance to the next question or finish the attempt if it was the last question.

### Requirement: Quiz Review Feedback
The quiz mode review state SHALL display the correct answer and explanation after the user checks a question.

#### Scenario: Show correct answer after check
- **WHEN** the quiz review state is shown for a question
- **THEN** the system SHALL highlight the correct option(s)
- **AND** it SHALL display the correct answer block for the question.

#### Scenario: Show explanation after check
- **WHEN** the quiz review state includes explanation content
- **THEN** the system SHALL render the explanation after the correct answer section.

### Requirement: Quiz Answer Evaluation
The system SHALL evaluate quiz answers by comparing the selected option IDs against the correct answer IDs for the current question.

#### Scenario: Correct answer selected
- **WHEN** the selected option IDs exactly match the question's correct answer IDs
- **THEN** the system SHALL mark the checked state as correct
- **AND** it SHALL NOT classify the question as incorrect.

#### Scenario: Incorrect answer selected
- **WHEN** the selected option IDs do not match the question's correct answer IDs
- **THEN** the system SHALL mark the checked state as incorrect
- **AND** it SHALL show the incorrect review state with the explanation.

#### Scenario: API Response Parsing for Evaluation
- **WHEN** the API returns the attempt question response on checking an answer
- **THEN** the system SHALL correctly parse the question ID and the correct options
- **AND** it SHALL support looking up correct options inside `correct_option_ids` (both top-level and nested) or nested `options` where `is_correct` is true
- **AND** the evaluation SHALL prefer direct backend results (`result` or `is_correct`) if present, otherwise deriving it by comparing selections against correct answers, to avoid flashing false incorrect state.

### Requirement: No Retry Action in Quiz Mode
The quiz review state SHALL NOT expose a `Try Again` action for quiz-mode questions.

#### Scenario: Incorrect answer review
- **WHEN** a question is marked incorrect in quiz mode
- **THEN** the system SHALL allow the user to continue to the next question
- **AND** it SHALL NOT require a retry action for the same question.

### Requirement: Quiz Completion Result Card
When a quiz-mode attempt is finished, the system SHALL display a completion result card with the final score and post-completion actions.

#### Scenario: Quiz attempt completed
- **WHEN** the final quiz question is continued past its review state
- **THEN** the system SHALL show a completion card that summarizes the score/result
- **AND** it SHALL provide `Retake Test` and `Back to Chapter` actions.

### Requirement: Offline-First Quiz Questions Fetching
To support instant correctness feedback on checking an answer, the system SHALL load the quiz questions using an API endpoint version that returns correct options and explanations.

#### Scenario: Loading quiz questions in quiz mode
- **WHEN** a quiz-mode attempt is initialized
- **THEN** the system SHALL fetch questions using the `/api/v2.5/attempts/{id}/questions/` endpoint to retrieve correct options and explanation metadata locally
- **AND** it SHALL use this local metadata to display review highlights instantly on check.

#### Scenario: Sorting quiz questions by section and order
- **WHEN** quiz questions are loaded from the `/api/v2.5/attempts/{id}/questions/` endpoint
- **THEN** the system SHALL sort the questions overall by their section order or section ID (ascending) first
- **AND** then sort them by their question order within the section (ascending) to prevent interleaving of questions from different sections.

#### Scenario: Submitting quiz answers to v2.2 endpoint
- **WHEN** constructing the answer check URL for quiz questions fetched from `/api/v2.5/attempts/{id}/questions/`
- **THEN** the system SHALL use the `/api/v2.2/` endpoint version path (e.g. `/api/v2.2/attempts/{attempt_id}/questions/{attempt_item_id}/`) to ensure check PUT requests are accepted without a 404 error.
