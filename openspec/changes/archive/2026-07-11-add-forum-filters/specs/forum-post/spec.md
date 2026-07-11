## ADDED Requirements

### Requirement: Thread Sorting and Filtering UI
The system SHALL provide horizontal tabs for sorting and a Bottom Sheet for advanced filtering.

#### Scenario: User navigates sorting tabs
- **WHEN** the user views the forum feed
- **THEN** the system SHALL display sorting tabs (Recent, Most Liked, Most Viewed) above the category chips
- **AND** tapping a tab SHALL update the feed order accordingly

#### Scenario: User opens filter bottom sheet
- **WHEN** user taps the filter icon on the thread list
- **THEN** the system SHALL open a Bottom Sheet containing Activity filters
