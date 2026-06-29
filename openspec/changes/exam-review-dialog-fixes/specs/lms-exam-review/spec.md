## MODIFIED Requirements

### Requirement: Contextual Action Dialogs
The system SHALL provide interactive actions for "Ask Doubt", "Comment", and "Report Issue" to facilitate user interaction during question review. The "Ask Doubt" action SHALL navigate to the full ask doubt form screen; "Comment" and "Report Issue" SHALL continue to use inline dialogs.

#### Scenario: Open Ask Doubt
- **WHEN** the user selects "Ask Doubt" on a question
- **THEN** the system SHALL navigate to the ask doubt form screen (`/home/discussions/doubts/ask`)
- **AND** the current question's ID SHALL be passed as the `question_id` query parameter

#### Scenario: Open Add Comment
- **WHEN** the user selects "Comment"
- **THEN** a dialog SHALL appear allowing the user to share thoughts on the specific question.

#### Scenario: Open Report Issue
- **WHEN** the user selects "Report"
- **THEN** a dialog SHALL appear with the following options:
  * Incorrect answer marked as correct
  * Question is unclear
  * Explanation is wrong
  * Other issue
- **AND** an optional text area SHALL be provided for additional details.

## ADDED Requirements

### Requirement: Dialog Action Button Alignment
The Comment and Report dialogs SHALL display their action buttons right-aligned, with the Cancel button at natural width to the left of the primary action button.

#### Scenario: Comment dialog button layout
- **WHEN** the Comment dialog is open
- **THEN** the Cancel button SHALL appear at its natural width
- **AND** the "Post Comment" button SHALL appear to the right of Cancel, also at natural width
- **AND** both buttons SHALL be aligned to the right edge of the dialog

#### Scenario: Report dialog button layout
- **WHEN** the Report dialog is open
- **THEN** the Cancel button SHALL appear at its natural width
- **AND** the "Report" button SHALL appear to the right of Cancel, also at natural width
- **AND** both buttons SHALL be aligned to the right edge of the dialog

