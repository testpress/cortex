# exam-question-reporting Specification

## Purpose
TBD - created by archiving change question-report-integration. Update Purpose after archive.
## Requirements
### Requirement: Question Reporting Backend Integration
The system SHALL provide an API client method to submit an exam question report to the backend endpoint.

#### Scenario: API Submission
- **WHEN** a report is triggered for a specific question
- **THEN** the system SHALL make a POST request to `/api/v2.5/questions/<question_id>/reportees/`
- **AND** it SHALL include the report type and description in the payload

### Requirement: Session State Tracking for Reported Questions
The system SHALL maintain a local state tracking which questions have been reported during the current review session.

#### Scenario: Tracking reported questions
- **WHEN** a question is successfully reported or the API indicates it was already reported
- **THEN** the system SHALL add the question ID to the set of reported questions in the current session state

#### Scenario: Optimistic error handling
- **WHEN** the backend returns a 400 Bad Request indicating the question is "already reported"
- **THEN** the system SHALL gracefully catch the error and update the local state to mark it as reported without throwing a fatal exception

