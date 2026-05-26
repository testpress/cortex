## ADDED Requirements

### Requirement: Resume Paused Exam Attempt
The system SHALL check for a paused attempt using the `paused_attempts_count` field from the Exam API. If an attempt is paused, the CTA SHALL be updated to allow resuming, and the system SHALL fetch the running attempt and start the exam from where it left off instead of creating a new attempt.

#### Scenario: Existing paused attempt
- **WHEN** an exam has `paused_attempts_count > 0`
- **THEN** the Prescreen CTA displays "Resume Exam Online"
- **THEN** tapping the CTA triggers the attempt's start URL and restores the session

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
