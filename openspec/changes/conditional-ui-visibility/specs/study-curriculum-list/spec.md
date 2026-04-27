## MODIFIED Requirements

### Requirement: Course Search and Filtering
#### Scenario: Gated category shortcuts
- **GIVEN** the client configuration has `showStudyCategoryButtons` set to `false`
- **WHEN** the study screen search header is rendered
- **THEN** the category shortcut buttons (Videos, Lessons, Assessments, Tests) MUST NOT be displayed
- **AND** the search bar MUST occupy the appropriate layout space without the buttons below it
