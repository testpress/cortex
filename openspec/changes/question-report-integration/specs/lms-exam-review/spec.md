## MODIFIED Requirements

### Requirement: Contextual Action Dialogs
The system SHALL provide interactive actions for "Ask Doubt", "Comment", and "Report Issue" to facilitate user interaction during question review. The "Ask Doubt" action SHALL navigate to the full ask doubt form screen; "Comment" and "Report Issue" SHALL continue to use inline dialogs. The system SHALL prevent multiple reports for the same question in a given session.

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

#### Scenario: Successful Report Submission
- **WHEN** the user submits a report from the "Report Issue" dialog
- **THEN** the dialog SHALL close
- **AND** a success toast SHALL appear
- **AND** the "Report" button for that question SHALL be disabled for the remainder of the session

#### Scenario: Already Reported Error Handling
- **WHEN** the user submits a report but the backend indicates it was already reported
- **THEN** the dialog SHALL close
- **AND** an error toast indicating "already reported" SHALL appear
- **AND** the "Report" button for that question SHALL be disabled for the remainder of the session

#### Scenario: Disabling the Report Button
- **WHEN** a question has been marked as reported in the current session state
- **THEN** the "Report" button on the question card footer SHALL be disabled (unclickable and visually greyed out)
