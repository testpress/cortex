## ADDED Requirements

### Requirement: Flat Course-Level Lookup
The system SHALL provide a mechanism to retrieve all lessons for a specific course using a direct `courseId` index on the Lessons table.

#### Scenario: Course Dashboard Filter
- **WHEN** a global filter (e.g., "Tests") is applied on the Study Screen
- **THEN** the system SHALL query for lessons with `courseId = {currentCourse}` and `type = test` without traversing the chapter hierarchy.
