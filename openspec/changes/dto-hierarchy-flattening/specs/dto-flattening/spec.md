## ADDED Requirements

### Requirement: Flat Course DTO Structure
The `CourseDto` SHALL NOT contain a nested list of chapters. It MUST only contain basic course metadata (id, title, color, chapterCount, totalDuration, progress, completedLessons, totalLessons).

#### Scenario: Simplified Course Creation
- **WHEN** a `CourseDto` is instantiated
- **THEN** it SHALL NOT accept or store a `chapters` collection
- **AND** it SHALL provide exactly the flat fields required for the course list

### Requirement: Flat Chapter DTO Structure
The `ChapterDto` SHALL NOT contain a nested list of lessons. It MUST only contain basic chapter metadata (id, courseId, title, lessonCount, assessmentCount, orderIndex).

#### Scenario: Simplified Chapter Creation
- **WHEN** a `ChapterDto` is instantiated
- **THEN** it SHALL NOT accept or store a `lessons` collection
- **AND** it SHALL provide exactly the flat fields required for the chapter list

### Requirement: JSON Serialization Compatibility
The `CourseDto` and `ChapterDto` SHALL ignore `chapters` and `lessons` keys during JSON parsing to ensure forward compatibility with legacy or nested backend responses.

#### Scenario: Aggressive JSON Cleaning
- **WHEN** a JSON payload containing nested `chapters` or `lessons` is passed to `fromJson`
- **THEN** the parsing SHOULD succeed without trying to map the nested collections
- **AND** the resulting DTO object SHALL be flat
