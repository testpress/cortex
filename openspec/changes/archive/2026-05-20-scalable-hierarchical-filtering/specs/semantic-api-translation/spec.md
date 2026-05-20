## ADDED Requirements

### Requirement: Repository-Level API Type Translation
The `CourseRepository` SHALL be the single point of responsibility for translating internal domain terminology to backend-specific API parameter values. No UI or infrastructure layer SHALL be aware of this mapping.

A dedicated private helper (`_getApiCompatibleType`) SHALL perform this translation to keep the logic encapsulated and testable.

#### Scenario: Fetching filtered test content
- **WHEN** the filter type `"test"` is passed from the UI layer
- **THEN** the `CourseRepository._getApiCompatibleType` SHALL translate it to `"exams"` before passing to the data source
- **AND** the resulting API request SHALL use `?type=exams`

#### Scenario: Fetching filtered assessment content
- **WHEN** the filter type `"assessment"` is passed from the UI layer
- **THEN** the `CourseRepository._getApiCompatibleType` SHALL translate it to `"quiz"` before passing to the data source
- **AND** the resulting API request SHALL use `?type=quiz`

#### Scenario: Fetching other content types (video, etc.)
- **WHEN** the filter type `"video"` (or any non-exam type) is passed from the UI layer
- **THEN** the type value SHALL be passed through unchanged
- **AND** the resulting API request SHALL use `?type=video`

### Requirement: Transparent Data Source
The `HttpDataSource` SHALL act as a transparent HTTP adapter. It SHALL pass the `type` parameter value directly to the backend without inspecting, transforming, or making decisions based on its content. All query parameter construction is the sole responsibility of the `CourseRepository`.

#### Scenario: Network layer parameter passthrough
- **WHEN** the `CourseRepository` provides a translated parameter (e.g. `"exams"`)
- **THEN** the `HttpDataSource` SHALL append `?type=exams` to the request untouched
- **AND** it SHALL NOT perform any internal domain logic or translation
