## ADDED Requirements

### Requirement: Local database as single source of truth
The system SHALL persist all LMS domain data (courses, chapters, lessons, live classes, forum threads, user progress) in a local Drift SQLite database. All UI components SHALL read exclusively from the local database, never directly from the network or mock source.

#### Scenario: App displays courses from local DB on launch
- **WHEN** the app launches with a populated local database
- **THEN** the course list screen displays cached courses immediately with no network call

#### Scenario: UI updates automatically when DB changes
- **WHEN** a network sync writes new course data to the local database
- **THEN** any widget watching the course stream updates without explicit navigation or refresh

#### Scenario: App works offline after initial load
- **WHEN** the device has no network connectivity
- **AND** the local database contains previously synced data
- **THEN** the user SHALL be able to browse courses, chapters, and lessons using the locally cached data

---

### Requirement: Repository isolates UI from data source
The system SHALL provide concrete Repository classes (`CourseRepository`, `UserRepository`, `ForumRepository`, `ExamRepository`) that encapsulate all read/write logic. Screen widgets SHALL depend only on repositories, never on `DataSource` or database classes directly.

#### Scenario: Repository fetches and caches course list
- **WHEN** `CourseRepository.refreshCourses()` is called
- **THEN** it fetches from the active `DataSource` and writes results to the local Drift database
- **AND** the Drift stream emits updated data automatically

#### Scenario: Repository exposes watch stream
- **WHEN** a widget subscribes to `CourseRepository.watchCourses()`
- **THEN** it receives a `Stream<List<Course>>` sourced from Drift, not from the `DataSource`

---

### Requirement: DataSource interface enables swappable backends
The system SHALL define an abstract `DataSource` interface. The active implementation SHALL be injectable via `AppConfig.useMockData`. Switching from `MockDataSource` to `HttpDataSource` SHALL require no changes to repositories or UI.

#### Scenario: Mock data source provides all domain data
- **WHEN** `AppConfig.useMockData` is `true`
- **THEN** `MockDataSource` SHALL return complete, realistic data for all domain types: courses (min 3), chapters (min 5 per course), lessons (min 4 per chapter), live classes (min 2), forum threads (min 5), and user progress records

#### Scenario: HTTP data source is injectable for future use
- **WHEN** `AppConfig.useMockData` is `false`
- **THEN** the `HttpDataSource` implementation is used and SHALL use `AppConfig.apiBaseUrl` as the base URL for all requests

---

### Requirement: Riverpod provides reactive state management
The system SHALL wire all repositories through Riverpod providers. UI widgets MUST use `ConsumerWidget` or `Consumer` to access data. All providers exposing async data SHALL return `AsyncValue<T>` types to represent loading, error, and success states.

#### Scenario: Loading state shown while data is fetching
- **WHEN** a repository provider has no data yet (first launch post-install)
- **THEN** the widget receives `AsyncValue.loading()` and SHALL display a loading indicator

#### Scenario: Error state shown gracefully on failure
- **WHEN** a DataSource fetch throws an exception
- **AND** the local database is empty
- **THEN** the widget receives `AsyncValue.error(...)` and SHALL display an error message with a retry option

#### Scenario: Data state renders content
- **WHEN** the stream emits a non-empty list
- **THEN** the widget receives `AsyncValue.data(courses)` and renders the course list

---

### Requirement: Existing course list screen uses repository pattern
The `CourseListScreen` in `packages/courses` SHALL be refactored to be a `ConsumerWidget` that reads from `courseListProvider`. Hardcoded `MockCourse` data SHALL be removed from widgets.

#### Scenario: Course list populated from provider
- **WHEN** `CourseListScreen` builds
- **THEN** it calls `ref.watch(courseListProvider)` and renders based on the returned `AsyncValue`

#### Scenario: App launches and shows courses end-to-end
- **WHEN** the app is launched in mock mode
- **THEN** the course list screen shows at least 3 courses sourced from `MockDataSource` via the repository and Drift layer
