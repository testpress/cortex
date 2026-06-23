## MODIFIED Requirements

### Requirement: Chapter Content List
The system SHALL display a vertical list of all learning items (lessons, assessments, tests) belonging to a specific chapter.
- For exam and assessment items (`LessonType.test`, `LessonType.assessment`), the system SHALL render a green circular completion badge on the card's trailing side when the item's `hasAttempts` field is `true`.

#### Scenario: Chapter detail displays items
- **WHEN** the user opens the chapter detail page
- **THEN** the system displays a list of lesson titles, their types, and secondary information (e.g., duration)

#### Scenario: Completed exam shows badge
- **WHEN** the user opens the chapter detail page and an exam item has `hasAttempts == true`
- **THEN** the system renders a green tick badge on that exam card, positioned on the top-right corner of the left-hand thumbnail image, overlapping its boundary
