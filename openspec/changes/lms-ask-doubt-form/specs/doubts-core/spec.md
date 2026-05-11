## ADDED Requirements

### Requirement: Local Doubt Creation
The `DoubtRepository` SHALL support creating a new doubt record locally.
- **Persistence**: Newly created doubts SHALL be inserted into the local `doubts` table immediately.
- **Mock Integration**: The system SHALL simulate a successful server response for local testing when real API sync is disabled.

#### Scenario: Creating a doubt locally
- **GIVEN** a student has filled the doubt form
- **WHEN** they submit the doubt
- **THEN** a new record SHALL appear in the local database and the UI SHALL reflect the update reactively
