## MODIFIED Requirements

### Requirement: Doubt Thread Header and Metadata
The system SHALL display the doubt's title and metadata (category, student name, and timestamp) in the detail screen header.
- **Lesson Context**: If the doubt is associated with a `lessonId`, the system SHALL fetch and display the corresponding lesson title to provide contextual information about where the doubt originated.

#### Scenario: Displaying doubt metadata
- **WHEN** the student opens a doubt from the list
- **THEN** the system shows the title, "Physics" category (or relevant), and "Asked 2h ago" metadata.

#### Scenario: Displaying lesson context
- **GIVEN** a doubt has an associated `lessonId`
- **WHEN** the student views the doubt details
- **THEN** the system SHALL display the lesson title in the header section
