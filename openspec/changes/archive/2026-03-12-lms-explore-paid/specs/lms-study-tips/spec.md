## ADDED Requirements

### Requirement: Study Tips Feed
The system SHALL provide a "Study Tips" section on the Explore dashboard featuring informational articles, motivational content, and app updates. These items are designed for discovery and SHALL be presented as informational only (non-interactive) in this phase.

#### Scenario: Viewing study tips
- **WHEN** the user views the "Study Tips & Updates" section
- **THEN** the study tip cards MUST be displayed as static informational content
- **AND** the "View All" label SHALL be displayed as a static header element to maintain visual hierarchy without providing navigation.

### Requirement: Categorized Tips
The system SHALL support categorization for study tips (e.g., "Tips", "Update", "Exam") with color-coded tags for quick identification.

#### Scenario: Identifying tip type
- **WHEN** the user views the study tips section
- **THEN** each card MUST display its category tag with the corresponding theme color defined in the design system
