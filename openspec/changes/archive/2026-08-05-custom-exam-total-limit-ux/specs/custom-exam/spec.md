## MODIFIED Requirements

### Requirement: Question Count Restriction
The system SHALL restrict the user from requesting a total combined number of questions across all blocks that exceeds the `max_questions_per_test` defined in the configuration.

#### Scenario: User sets question count for the first block
- **WHEN** user adjusts the number of questions slider/input for their first block
- **THEN** the maximum value is strictly capped at `max_questions_per_test`

#### Scenario: User sets question count for subsequent blocks
- **WHEN** user adjusts the number of questions slider/input for a subsequent block
- **THEN** the maximum value is strictly capped at the remaining quota (`max_questions_per_test` minus the sum of questions in all previously added blocks)
