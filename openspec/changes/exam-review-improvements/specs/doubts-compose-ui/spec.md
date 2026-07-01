## MODIFIED Requirements

### Requirement: Doubt Context Banner
The system SHALL display a context banner indicating the origin of the doubt when the user navigates from a specific lesson or question.

#### Scenario: Navigating from Exam Review
- **WHEN** the user navigates to the Ask a Doubt screen from an exam review question
- **THEN** the system SHALL display the stripped question text in the context banner instead of the question ID
- **AND** the breadcrumb above the banner SHALL display the Exam Title
