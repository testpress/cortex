## MODIFIED Requirements

### Requirement: Full-Cell Interactive Targets
The system SHALL ensure that interactive elements like filter chips and course cards utilize the full width and height of their bounding containers as tap targets (`AppFocusable`). Text and icons within these components SHALL prioritize tap accuracy by ensuring dead space also responds to interaction.

#### Scenario: Accessible filter targets
- **WHEN** a user taps anywhere within the container of a filter chip
- **THEN** the filter is toggled as expected

#### Scenario: Accessible course card targets
- **WHEN** a user taps anywhere within the bounding box of a CourseCard
- **THEN** the card triggers the `onTap` callback even when tapping transparent space
