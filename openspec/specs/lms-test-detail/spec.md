# Capability: LMS Test Detail

## Purpose
The LMS Test Detail capability defines the test-taking experience, including timing, question navigation, answer selection, and final submission behavior.
## Requirements
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
  - **Answered**: Solid Green Square.
  - **Marked for Review**: Solid Orange Square.
  - **Answered & Marked**: Solid Purple Square.

### Requirement: Answer Selection
The system SHALL allow selecting options without revealing the correct answer during the test.

#### Scenario: Single-select
- **WHEN** the question type is 'mcq'
- **THEN** selecting one option SHALL deselect previous options.

#### Scenario: Multiple-select
- **WHEN** the question type is 'multiple-select'
- **THEN** the user SHALL be able to select multiple options concurrently.

### Requirement: Test Submission Confirmation
The system SHALL provide a confirmation step before a test is finalized.

#### Scenario: Finish Request
- **WHEN** the user selects "Finish" on the test screen
- **THEN** the system SHALL display the `SubmitConfirmationDialog` as an overlay.
- **AND** it SHALL show the total count of answered and unanswered questions.

#### Scenario: Cancellation
- **WHEN** the user cancels the confirmation dialog
- **THEN** the system SHALL return the user to the active test question without submitting.

### Requirement: Success Overlay
The system SHALL display a submission success message using an overlay pattern.

#### Scenario: Successful Submission
- **WHEN** the user confirms the submission
- **THEN** the system SHALL display the `TestResultView` as an overlay.
- **AND** the background test UI SHALL remain visible but dimmed to preserve context.
- **AND** the system SHALL provide actions for "Review Answers" and "View Analytics".

### Requirement: UI Density & Sizing
The test interface components SHALL adhere to a refined, high-density layout.

#### Scenario: Overlay Scaling
- **WHEN** viewing submission overlays
- **THEN** they SHALL have a maximum width of 400px.
- **AND** they SHALL use scaled-down icons (24px) and headlines (20px) to maximize screen space.

#### Scenario: Content Sizing
- **WHEN** viewing questions and options
- **THEN** `OptionCard` SHALL use a 14px font size for text to improve readability in long lists.
- **AND** vertical padding SHALL be prioritized at `spacing.sm` for action elements.

### Requirement: Final Submission & Summary
The system SHALL calculate the final results ONLY after the test is completed.

#### Scenario: Finishing the test
- **WHEN** the user clicks "Finish"
- **THEN** the system SHALL stop the timer, calculate the percentage score, and display the "Test Completed" view with the correct answer count.
- **AND** the summary view SHALL provide a navigation path to the detailed "Exam Review" list.

### Requirement: Package Boundary
The test detail component MUST be implemented within the `exams` package to ensure proper code modularity.

#### Scenario: Implementation location
- **WHEN** the application is compiled
- **THEN** the test detail screen and related components are sourced from `package:exams` instead of `package:courses`

