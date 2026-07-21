# offline-exams-list Specification

## Purpose
TBD - created by archiving change offline-exams-list. Update Purpose after archive.
## Requirements
### Requirement: View offline exams list
The system SHALL provide a dedicated screen to list all locally downloaded offline exams.

#### Scenario: User navigates to offline exams with no downloads
- **WHEN** the user navigates to the Offline Exams screen and has no downloaded exams
- **THEN** the system MUST display an empty state indicating "No downloaded exam available"

#### Scenario: User navigates to offline exams with downloads
- **WHEN** the user navigates to the Offline Exams screen and has downloaded exams
- **THEN** the system MUST display a list of the downloaded exams

### Requirement: Offline exam list item actions
Each exam in the offline exams list SHALL display options to delete the download and attend the exam.

#### Scenario: User attends an offline exam
- **WHEN** the user taps the "Attend" button or taps on the list item itself
- **THEN** the system MUST navigate the user to the exam detail page for that exam

#### Scenario: User deletes an offline exam
- **WHEN** the user taps the "Delete" button on an offline exam list item
- **THEN** the system MUST remove the exam from local storage and update the list UI

