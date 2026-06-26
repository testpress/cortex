## ADDED Requirements

### Requirement: Embedded Exam Metadata
The `LessonDto` class SHALL contain an optional `exam` field of type `ExamDto?` that captures the fully populated exam object returned within a content payload.

#### Scenario: Parsing a content payload with an exam
- **WHEN** the API returns a chapter content payload where `content_type` is Exam
- **THEN** `LessonDto.fromJson` correctly passes the nested `"exam": { ... }` block to `ExamDto.fromJson`
- **THEN** it assigns the resulting `ExamDto` to the `exam` property of the lesson

## MODIFIED Requirements

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
