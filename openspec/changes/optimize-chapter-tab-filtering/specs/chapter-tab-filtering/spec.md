# Spec: Chapter Tab Filtering

## Requirements

### Requirement: Instant Tab Filtering on Available Curriculum
The system SHALL filter chapter lessons immediately in memory when switching between `All`, `Running`, `Upcoming`, and `History` tabs.

#### Scenario: Switching tab when chapter lessons exist
- **GIVEN** a chapter with loaded lessons
- **WHEN** the user switches between status filter tabs while background synchronization is in progress
- **THEN** the system SHALL NOT display skeleton shimmer loaders
- **AND** the system SHALL display the filtered lessons matching the active tab or the empty state immediately.

### Requirement: Filter State Scope
The system SHALL reset the chapter status filter to `All` when leaving or entering a chapter detail screen.
