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
The `LessonDto` class SHALL contain nullable string fields for `attemptsUrl` and `slug`, and an optional `ExamDto` field for `exam`, with support for JSON parsing and model copying/merging.

#### Scenario: JSON parsing from API
- **WHEN** an exam lesson JSON is parsed via `LessonDto.fromJson`
- **THEN** it correctly extracts `attemptsUrl` and `slug` from the `exam` map or top-level keys
- **THEN** it maps the full nested `exam` object into the `exam` property
- **THEN** the `copyWith` and `merge` methods preserve these fields

#### Scenario: Fallback type identification
- **WHEN** explicit type identifiers (e.g. content_type) are missing from JSON root
- **WHEN** the `exam` specific nested map key is present
- **THEN** the system MUST identify the lesson as an Exam and parse accordingly

### Requirement: Lesson Domain Model Mapping
The domain `Lesson` model in the courses package SHALL include `attemptsUrl` and `slug` fields, and SHALL provide a `toDto()` helper method to map it back to `LessonDto`.

#### Scenario: Domain model conversion
- **WHEN** a `Lesson` domain model is instantiated with `attemptsUrl` and `slug`
- **WHEN** `toDto()` is called on it
- **THEN** the returned `LessonDto` contains matching values for both fields

### Requirement: Embedded Exam Metadata
The `LessonDto` class SHALL contain an optional `exam` field of type `ExamDto?` that captures the fully populated exam object returned within a content payload.

#### Scenario: Parsing a content payload with an exam
- **WHEN** the API returns a chapter content payload where `content_type` is Exam
- **THEN** `LessonDto.fromJson` correctly passes the nested `"exam": { ... }` block to `ExamDto.fromJson`
- **THEN** it assigns the resulting `ExamDto` to the `exam` property of the lesson

