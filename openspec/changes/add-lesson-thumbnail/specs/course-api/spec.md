## ADDED Requirements

### Requirement: Lesson Data Model Extensions
The system SHALL update data models to support extracting richer visual properties returned by the curriculum APIs without adding new fields.

#### Scenario: Upgrading LessonDto Mapping
- **WHEN** mapping API responses to `LessonDto`
- **THEN** prioritize `cover_image` over `icon` for the `image` property mapping.
