## ADDED Requirements

### Requirement: Popular tests fetched via core DataSource
The system SHALL provide popular tests data for the Explore page through the shared `DataSource` abstraction in `core`, without any dependency on `package:exams`.

#### Scenario: Mock data source returns popular tests
- **WHEN** `dataSourceProvider.getPopularTests()` is called in mock mode
- **THEN** a list of `PopularTestDto` items is returned with id, title, time, duration, type, and thumbnail

#### Scenario: Explore providers use dataSource for popular tests
- **WHEN** `filteredPopularTestsProvider` is evaluated
- **THEN** it reads from `dataSourceProvider` and NOT from `examRepositoryProvider`

#### Scenario: explore package has no exams dependency
- **WHEN** `packages/explore/pubspec.yaml` is inspected
- **THEN** there is no `exams:` entry under dependencies
