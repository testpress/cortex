## MODIFIED Requirements

### Requirement: Reports Tab Toggling
The system SHALL present two tabs — "Overall Reports" and "Individual Reports" — when viewing the root analytics screen (`parentId == null`). When viewing a child subject's analytics (`parentId != null`), the tab row SHALL be hidden and only the Overall Reports view SHALL be displayed.

#### Scenario: Tabs visible at root level
- **WHEN** the screen is opened with no `parentId`
- **THEN** the system SHALL render the "Overall Reports" and "Individual Reports" tab buttons

#### Scenario: Tabs hidden for child subjects
- **WHEN** the screen is opened with a non-null `parentId`
- **THEN** the system SHALL NOT render the tab row
- **AND** the system SHALL display only the `OverallReportsView` scoped to that `parentId`

#### Scenario: Switching between tabs
- **WHEN** the user taps the "Overall Reports" tab
- **THEN** the system SHALL display the stacked horizontal bar charts
- **AND** WHEN the user taps the "Individual Reports" tab
- **THEN** the system SHALL display the subject stats table and donut cards
- **AND** the tab selector SHALL render as filled rounded pill-shaped buttons side-by-side
- **AND** the active tab button SHALL have a background color of design.colors.primary and contrasting text color of design.colors.onPrimary, while the inactive tab button SHALL have a light background and secondary text color
