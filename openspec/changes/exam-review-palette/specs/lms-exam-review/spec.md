## ADDED Requirements

### Requirement: Question Palette Navigation
The system SHALL provide a question palette on the exam review screen to allow non-sequential navigation and provide an overview of performance.

#### Scenario: Displaying the question palette trigger
- **WHEN** the user views the exam review screen
- **THEN** a "View All Questions" trigger SHALL be visible at the bottom of the screen.

#### Scenario: Opening the question palette
- **WHEN** the user clicks the "View All Questions" trigger
- **THEN** the system SHALL open a bottom sheet displaying a grid of all question numbers in the exam.

#### Scenario: Review context color-coding
- **WHEN** the question palette is opened in review mode
- **THEN** the colors of the question numbers SHALL indicate correctness status (e.g., green for Correct, red for Incorrect, grey for Unattempted).
- **AND** the legend SHALL explain these review-specific statuses rather than exam-progress statuses.

#### Scenario: Non-sequential navigation
- **WHEN** the user clicks a specific question number in the palette
- **THEN** the palette SHALL close
- **AND** the review screen SHALL immediately navigate to and display the selected question.
