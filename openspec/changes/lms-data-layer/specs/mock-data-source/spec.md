## ADDED Requirements

### Requirement: MockDataSource provides complete LMS domain data
The `MockDataSource` class SHALL implement the `DataSource` interface and provide realistic, self-consistent data for all LMS domain types without any external dependencies. Data SHALL reflect the JEE/NEET coaching institute domain (Physics, Chemistry, Mathematics, Biology, English subjects).

#### Scenario: Course list returned with complete metadata
- **WHEN** `MockDataSource.getCourses()` is called
- **THEN** it returns at least 3 courses, each with `id`, `title`, `subjectColor`, `chapterCount`, `totalDuration`, `progress`, `completedLessons`, and `totalLessons`

#### Scenario: Chapter list is consistent with course data
- **WHEN** `MockDataSource.getChapters(courseId)` is called with a valid course ID
- **THEN** it returns at least 5 chapters for that course, each with `id`, `title`, `lessonCount`, and `assessmentCount`

#### Scenario: Lesson list reflects real content types
- **WHEN** `MockDataSource.getLessons(chapterId)` is called
- **THEN** it returns lessons with at least one of each type: `video`, `pdf`, `assessment`, `test`

#### Scenario: Live class snapshot data is available
- **WHEN** `MockDataSource.getLiveClasses()` is called
- **THEN** it returns at least 3 live class entries with statuses: `completed`, `live`, and `upcoming`

#### Scenario: Forum threads with replies are available
- **WHEN** `MockDataSource.getForumThreads(courseId)` is called
- **THEN** it returns at least 5 forum threads; at least 2 SHALL have `status: answered` with at least 1 reply

---

### Requirement: MockDataSource is activated via AppConfig flag
The system SHALL activate `MockDataSource` when `AppConfig.useMockData` is `true`. The `DataSource` implementation SHALL be resolved once at app startup and injected into all repositories.

#### Scenario: Mock activated by default
- **WHEN** the app is built without setting `USE_MOCK=false` via `--dart-define`
- **THEN** all repositories use `MockDataSource`

#### Scenario: HTTP source activated via dart-define
- **WHEN** the app is built with `--dart-define=USE_MOCK=false`
- **THEN** all repositories use `HttpDataSource` with `AppConfig.apiBaseUrl` as the base URL

---

### Requirement: MockDataSource data matches React reference design
Data IDs, titles, and structure in `MockDataSource` SHALL be derived from the React reference design in `/Users/bharath/Downloads/project/src/app/App.tsx` to ensure visual screen parity during development.

#### Scenario: Course IDs are stable and predictable
- **WHEN** `MockDataSource.getCourses()` returns courses
- **THEN** each course ID SHALL match the format `jee-main-2026`, `neet-2026`, `jee-advanced-2026` etc. used in the React reference
