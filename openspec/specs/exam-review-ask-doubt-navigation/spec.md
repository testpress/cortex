# exam-review-ask-doubt-navigation Specification

## Purpose
TBD - created by archiving change exam-review-dialog-fixes. Update Purpose after archive.
## Requirements
### Requirement: Ask Doubt Navigation from Exam Review
When a student taps "Ask Doubt" on a question in the exam review screen, the system SHALL navigate to the full `AskDoubtFormScreen` instead of showing an inline dialog.

#### Scenario: Ask Doubt button tapped on a question
- **WHEN** the user taps the "Ask Doubt" button on a question card in the exam review screen
- **THEN** the system SHALL navigate to the ask doubt form screen
- **AND** the form SHALL pre-populate the doubt context with the current question's ID

#### Scenario: Question ID passed as context
- **WHEN** the navigation to the ask doubt form is triggered
- **THEN** the system SHALL pass the current question's numeric ID as the `question_id` query parameter
- **AND** `AskDoubtFormScreen` SHALL display a context badge identifying the associated question

#### Scenario: Return from ask doubt form
- **WHEN** the user submits or cancels on the ask doubt form
- **THEN** the system SHALL return the user to the exam review screen via standard back navigation

