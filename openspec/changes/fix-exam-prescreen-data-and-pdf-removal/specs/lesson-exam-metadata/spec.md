## MODIFIED Requirements

### Requirement: Lesson Data Transfer Objects
The `LessonDto` class SHALL contain nullable string fields for `attemptsUrl` and `slug`, with support for JSON parsing and model copying/merging.

#### Scenario: JSON parsing from API
- **WHEN** an exam lesson JSON is parsed via `LessonDto.fromJson`
- **THEN** it correctly extracts `attemptsUrl` and `slug` from the `exam` map or top-level keys
- **THEN** the `copyWith` and `merge` methods preserve these fields

#### Scenario: Fallback type identification
- **WHEN** explicit type identifiers (e.g. content_type) are missing from JSON root
- **WHEN** the `exam` specific nested map key is present
- **THEN** the system MUST identify the lesson as an Exam and parse accordingly
