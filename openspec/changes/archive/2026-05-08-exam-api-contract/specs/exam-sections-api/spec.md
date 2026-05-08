## ADDED Requirements

### Requirement: Section DTO Structure
The core package SHALL provide a `SectionDto` class representing an exam section with `id`, `name`, `state`, `questionsUrl`, `startUrl`, `endUrl`, `remainingTime`, `duration`, `order`, and `instructions`.

#### Scenario: Parse section JSON
- **WHEN** an exam section JSON is parsed
- **THEN** it correctly populates all fields of `SectionDto` and supports serialization/deserialization

### Requirement: Exam Sections List
The `ExamDto` and `AttemptDto` models SHALL support an optional list of `SectionDto` objects, corresponding to the Testpress v2.2.1 section representation.

#### Scenario: Parse exam with sections
- **WHEN** an exam payload containing a nested `sections` list is deserialized
- **THEN** it maps to the `sections` field in `ExamDto` and `AttemptDto` respectively
