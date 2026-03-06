## ADDED Requirements

### Requirement: Scrollable Question Review List
The system SHALL display a scrollable vertical list of all questions from a completed assessment.

#### Scenario: Full list display
- **WHEN** the user opens the "Exam Review" screen
- **THEN** the system SHALL display all questions that were part of the assessment in their original order.

### Requirement: Question High-Density Header
Each question item in the review list SHALL display a header containing the question number, subject, a correctness status icon, and a status badge.

#### Scenario: Displaying correctness status
- **WHEN** a question was answered correctly
- **THEN** the header SHALL show a green check icon and a "Correct" badge.
- **WHEN** a question was answered incorrectly
- **THEN** the header SHALL show a red X icon and an "Incorrect" badge (or "Wrong").
- **WHEN** a question was left unanswered
- **THEN** the header SHALL show an orange info/circle icon and an "Unanswered" badge.

### Requirement: Expandable Solution Detail
The system SHALL allow users to expand a question header to reveal the detailed solution.

#### Scenario: Expanding for explanation
- **WHEN** the user taps a question header
- **THEN** the system SHALL expand the item to show:
  * Full Question Text
  * User's Selected Answer (highlighted in red if wrong, green if right)
  * Correct Answer (highlighted in green)
  * Detailed Explanation (using the standard blue explanation block)

### Requirement: Result Filtering Chips
The system SHALL provide filter chips at the top of the review list to filter questions by their correctness status.

#### Scenario: Applying filters
- **WHEN** the user selects the "Wrong" filter
- **THEN** only questions that were answered incorrectly SHALL be visible in the list.
- **AND** the count badge on the filter chip SHALL match the number of visible items.
- **AND** the "All" filter SHALL reset the view to show every question.
### Requirement: Contextual Action Dialogs
The system SHALL provide interactive dialogs for "Ask Doubt", "Comment", and "Report Issue" to facilitate user interaction during question review.

#### Scenario: Open Ask Doubt
- **WHEN** the user selects "Ask Doubt" on a question
- **THEN** a dialog SHALL appear displaying the question text as context
- **AND** a multi-line text input SHALL be provided for the user to describe their doubt.

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
