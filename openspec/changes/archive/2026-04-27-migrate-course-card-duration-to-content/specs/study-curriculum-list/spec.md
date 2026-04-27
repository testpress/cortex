## ADDED Requirements

### Requirement: Course Content Count Visibility
The system SHALL display the total number of contents (lessons, tests, etc.) for each course in the curriculum list. This metric replaces the total duration string to provide a more granular view of the course volume.

#### Scenario: Displaying content count in CourseCard
- **WHEN** a course has 120 total contents
- **THEN** the course card shows "120 contents" in its metadata section instead of "X hrs"
