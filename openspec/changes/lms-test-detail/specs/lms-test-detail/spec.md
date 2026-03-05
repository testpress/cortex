# Spec: lms-test-detail

## ADDED Requirements

### Requirement: Test Timer
The system SHALL display a real-time countdown timer in the screen header.

#### Scenario: Timer updates
- **WHEN** the test is active
- **THEN** the timer SHALL decrement every second.

#### Scenario: Time out
- **WHEN** the timer reaches 00:00
- **THEN** the system SHALL automatically submit the test.

### Requirement: Question Navigation & Marking
The system SHALL provide navigation controls and the ability to mark questions for review.

#### Scenario: Navigation buttons
- **WHEN** the user clicks "Previous" or "Next"
- **THEN** the system SHALL transition to the corresponding question.
- **BUT** "Previous" SHALL be disabled when on the first question.
- **AND** "Next" SHALL change to "Finish" when on the last question.

#### Scenario: Mark for Review
- **WHEN** the user clicks "Mark for Review"
- **THEN** the question status SHALL be updated to 'marked' in the system state.
- **AND** the palette indicator SHALL reflect this status change.

### Requirement: Question Palette Navigation
The system SHALL provide a "Question Palette" for global navigation across all questions.

#### Scenario: Jumping to a question
- **WHEN** the user selects a question from the palette
- **THEN** the system SHALL jump to that question immediately and close the palette.

#### Scenario: Status Indicators
- **WHEN** the user views the palette
- **THEN** the system SHALL distinguish question states using the following shapes:
  - **Not Answered**: Empty Square Border.
  - **Answered**: Solid Green Circle.
  - **Marked for Review**: Solid Orange Diamond.
  - **Answered & Marked**: Solid Green Hexagon.

### Requirement: Answer Selection
The system SHALL allow selecting options without revealing the correct answer during the test.

#### Scenario: Single-select
- **WHEN** the question type is 'mcq'
- **THEN** selecting one option SHALL deselect previous options.

#### Scenario: Multiple-select
- **WHEN** the question type is 'multiple-select'
- **THEN** the user SHALL be able to select multiple options concurrently.

### Requirement: Final Submission & Summary
The system SHALL provide a confirmation step and a successful submission summary.

#### Scenario: Finishing the test
- **WHEN** the user hits "Finish"
- **THEN** the system SHALL show a "Submit Test?" confirmation overlay.
- **AND** it SHALL display the count of answered vs unanswered questions.

#### Scenario: Confirming submission
- **WHEN** the user confirms the submission from the dialog
- **THEN** the system SHALL stop the timer and display a "Test Submitted!" overlay.
- **AND** it SHALL provide options to "Review Answers" and "View Analytics".
- **AND** the background test UI SHALL remain visible but dimmed (overlay behavior).
