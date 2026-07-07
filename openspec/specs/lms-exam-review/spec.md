# Capability: LMS Exam Review

## Purpose
The LMS Exam Review capability defines the post-test review experience, allowing students to navigate through test questions, identify mistakes, study explanations, and interact with the content.
## Requirements
### Requirement: Paged Question Review
The system SHALL display a paged view of all questions from a completed test.

#### Scenario: Paged navigation
- **WHEN** the user opens the "Exam Review" screen
- **THEN** the system SHALL display the first question fetched from the real server review items.
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
  * Full Question Text HTML rendered correctly
  * User's Selected Answer (highlighted in red if wrong, green if right)
  * Correct Answer (highlighted in green)
  * Detailed Explanation (using the standard blue explanation block)
  * Percentage of users who answered correctly

### Requirement: Result Filtering Options
The system SHALL provide filter options (e.g. chips) at the top or in a filter bar to filter questions by their correctness status.

#### Scenario: Applying filters
- **WHEN** the user selects the "Wrong" filter
- **THEN** only questions that were answered incorrectly SHALL be part of the paged review available for navigation.
- **AND** the count badge on the filter option SHALL match the number of filtered items.
- **AND** the "All" filter SHALL reset the view to include every question in the test.

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

### Requirement: Package Boundary
The exam review and answer detail components MUST be implemented within the `exams` package to ensure proper code modularity.

#### Scenario: Implementation location
- **WHEN** the application is compiled
- **THEN** the exam review screen and related components are sourced from `package:exams` instead of `package:courses`

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

