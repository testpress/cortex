## MODIFIED Requirements

### Requirement: MockDataSource provides complete LMS domain data
The `MockDataSource` class SHALL implement the `DataSource` interface and provide realistic, self-consistent data for all LMS domain types without any external dependencies. Data SHALL reflect the JEE/NEET coaching institute domain (Physics, Chemistry, Mathematics, Biology, English subjects).

#### Scenario: Lesson list reflects real content types
- **WHEN** `MockDataSource.getLessons(chapterId)` is called
- **THEN** it returns lessons with at least one of each type: `video`, `pdf`, `assessment`, `test`
- **AND** `video` and `pdf` lessons MUST contain a valid `contentUrl` to source media from.
