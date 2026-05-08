# lesson-exam-metadata Specification

## Purpose
TBD - created by archiving change lesson-exam-fields. Update Purpose after archive.
## Requirements
### Requirement: Lesson Database Fields
The `LessonsTable` database table SHALL include nullable text columns for `attemptsUrl` and `slug`.

#### Scenario: Database schema persistence
- **WHEN** the application starts and initializes the local database
- **WHEN** an exam lesson is fetched and persisted locally
- **THEN** the database stores both the `attemptsUrl` and `slug` values offline

### Requirement: Lesson Data Transfer Objects
The `LessonDto` class SHALL contain nullable string fields for `attemptsUrl` and `slug`, with support for JSON parsing and model copying/merging.

#### Scenario: JSON parsing from API
- **WHEN** an exam lesson JSON is parsed via `LessonDto.fromJson`
- **THEN** it correctly extracts `attemptsUrl` and `slug` from the `exam` map or top-level keys
- **THEN** the `copyWith` and `merge` methods preserve these fields

### Requirement: Lesson Domain Model Mapping
The domain `Lesson` model in the courses package SHALL include `attemptsUrl` and `slug` fields, and SHALL provide a `toDto()` helper method to map it back to `LessonDto`.

#### Scenario: Domain model conversion
- **WHEN** a `Lesson` domain model is instantiated with `attemptsUrl` and `slug`
- **WHEN** `toDto()` is called on it
- **THEN** the returned `LessonDto` contains matching values for both fields

