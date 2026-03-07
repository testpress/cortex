# Capability: LMS Exam Review

## Purpose
The LMS Exam Review capability defines the post-test review experience, allowing students to navigate through test questions, identify mistakes, study explanations, and interact with the content.

## Requirements

### Requirement: Paged Question Review
The system SHALL display a paged view of all questions from a completed test.

#### Scenario: Paged navigation
- **WHEN** the user opens the "Exam Review" screen
- **THEN** the system SHALL display the first question that was part of the test in its original order.
- **AND** the system SHALL provide "Previous" and "Next" buttons to navigate between question cards.

### Requirement: Question Card Display
Each question in the review SHALL be displayed as a comprehensive card containing the question status and content.

#### Scenario: Displaying correctness status
- **WHEN** a question was answered correctly
- **THEN** the card SHALL show a green check icon and a "Correct" badge.
- **WHEN** a question was answered incorrectly
- **THEN** the card SHALL show a red X icon and an "Incorrect" badge (or "Wrong").
- **WHEN** a question was left unanswered
- **THEN** the card SHALL show an orange info/circle icon and an "Unanswered" badge.

### Requirement: On-card Solution Detail
The system SHALL display the detailed solution directly on the question card.

#### Scenario: Reviewing for explanation
- **WHEN** the user views a question card
- **THEN** the card SHALL show:
  * Full Question Text
  * User's Selected Answer (highlighted in red if wrong, green if right)
  * Correct Answer (highlighted in green)
  * Detailed Explanation (using the standard blue explanation block)

### Requirement: Result Filtering Options
The system SHALL provide filter options (e.g. chips) at the top or in a filter bar to filter questions by their correctness status.

#### Scenario: Applying filters
- **WHEN** the user selects the "Wrong" filter
- **THEN** only questions that were answered incorrectly SHALL be part of the paged review available for navigation.
- **AND** the count badge on the filter option SHALL match the number of filtered items.
- **AND** the "All" filter SHALL reset the view to include every question in the test.

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
