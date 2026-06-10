## ADDED Requirements

### Requirement: Subject Row Interactions
The system SHALL provide interactive navigation for subject rows across all tabs in the analytics UI.

#### Scenario: Tapping a non-leaf subject row
- **WHEN** the user taps a subject row that is NOT a leaf node
- **THEN** the system SHALL navigate deeper into that subject's children analytics view

#### Scenario: Tapping a leaf subject row
- **WHEN** the user taps a subject row that is a leaf node
- **THEN** the system SHALL navigate to the dedicated topic analytics screen to display its specific breakdown
