## MODIFIED Requirements

### Requirement: Custom Exam Parameter Selection
The system SHALL allow the user to build a custom exam by adding one or more subject blocks, configuring the number of questions, difficulty levels, and question types for each block based on the retrieved course configuration.

#### Scenario: User configures a single subject block
- **WHEN** user selects a subject (root or nested) and configures its parameters
- **THEN** system saves this configuration as a discrete block in the exam payload

#### Scenario: User configures multiple subject blocks
- **WHEN** user repeats the subject selection process
- **THEN** system appends the new configuration to the list of blocks

#### Scenario: User leaves parameters unselected
- **WHEN** user leaves difficulty or question types blank for a block
- **THEN** system interprets this as no restriction and sends empty arrays `[]` in the block payload

### Requirement: Custom Exam Generation
The system SHALL submit the user's configured blocks as an array of `questionnaires` to generate the custom exam and handle the backend response appropriately.

#### Scenario: User submits generation request
- **WHEN** user presses the Start button with at least one configured block
- **THEN** system sends the `questionnaires` array payload to the backend and navigates to the resulting exam state based on the response

#### Scenario: Rate limit exceeded
- **WHEN** the backend returns a 403 Forbidden due to daily or monthly limits
- **THEN** system SHALL catch the error and display the detailed error message to the user
