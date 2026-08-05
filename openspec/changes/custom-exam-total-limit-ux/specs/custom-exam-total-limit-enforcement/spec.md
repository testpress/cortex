## ADDED Requirements

### Requirement: Exam Builder Dynamic Quota Enforcement
The system SHALL dynamically calculate and enforce the remaining question quota on the builder screen based on the total exam budget (`max_questions_per_test`) minus the sum of questions allocated to already configured blocks.

#### Scenario: User views builder screen with ample quota
- **WHEN** the remaining question quota is greater than or equal to the minimum block size (1)
- **THEN** the "+ Add Questionnaire" button is enabled
- **AND** the button text indicates the used quota against the total limit

#### Scenario: User views builder screen with exhausted quota
- **WHEN** the remaining question quota drops below the minimum block size (1)
- **THEN** the "+ Add Questionnaire" button is disabled
- **AND** the button text indicates that the limit has been reached

#### Scenario: User saves a block without interacting with the slider
- **WHEN** the user opens the subject bottom sheet and the remaining quota is lower than the previous default slider value (15)
- **AND** the user clicks Save without interacting with the slider
- **THEN** the system SHALL clamp the internal question count to the remaining quota before saving the block
