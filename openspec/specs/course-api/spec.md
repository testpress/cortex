# Capability: Course API

## Purpose
The Course API integrates the remote course catalog with the local Drift database, handling synchronization, pagination, and structural metadata fetching for all curriculum types.
## Requirements

### Real Course API Integration
The system SHALL fetch real course data from the course API and persist it into the local Drift database, including metadata for categorization and device compatibility.

#### Scenario: Fetching courses on Study tab entry
- **WHEN** the user is authenticated and opens the Study tab
- **THEN** the system makes a GET request to `/api/v3/courses/`
- **AND** the response is mapped to `CourseDto`, including `tags`, `tag_ids`, `exams_count`, and `allowed_devices`
- **AND** the data is upserted into the Drift `CoursesTable`
- **AND** the UI observes the Drift stream and reflects the updated data

---

### Paginated Fetching
The system SHALL support incremental loading of courses.

#### Scenario: First page load
- **WHEN** the user opens the Study tab for the first time in a session
- **THEN** the system fetches page 1 (`page=1&page_size=10`)

#### Scenario: Loading subsequent pages
- **WHEN** the user scrolls to within 500px of the bottom of the course list
- **AND** there are more pages available (API `next` field is not null)
- **THEN** the system fetches the next page and appends results to the Drift DB

---

### Loading Experience
The system SHALL surface loading state appropriately without blocking the UI unnecessarily.

#### Scenario: First visit with empty cache
- **WHEN** the user opens the Study tab AND no courses are in the local DB
- **AND** the initial sync is in progress
- **THEN** the UI shows structured skeleton course cards that preserve the list layout while data is fetched

#### Scenario: Revisiting with cached data
- **WHEN** the user navigates back to the Study tab
- **AND** courses already exist in the Drift DB
- **THEN** the UI immediately shows cached courses with no blocking loader

#### Scenario: Pagination in progress
- **WHEN** a next-page fetch is in progress
- **THEN** a small loader appears at the bottom of the course list

---

### Auth Gate
The system SHALL NOT fetch courses before the user is authenticated.

#### Scenario: Unauthenticated access
- **WHEN** the user is not logged in
- **THEN** no request is made to `/api/v3/courses/`

---

### Authorization Header
All API requests SHALL include the `Authorization` header.

#### Scenario: Making an authenticated API call
- **WHEN** `NetworkProvider` makes any HTTP request
- **THEN** the `Authorization` header is present on the request

### Requirement: Tab-Specific Stream Filtering
The repository SHALL provide dedicated streams for Study, Exam, and Info courses based on their tags and metadata to ensure correct content separation in the UI.

#### Scenario: Filtering the Info stream
- **WHEN** the `watchInfoCourses` stream is requested
- **THEN** the system MUST filter the local database for courses whose `tags` field contains the string `info`.
- **AND** only include entries whose `allowedDevices` explicitly permit mobile access.

#### Scenario: Correcting Study tab leakage
- **WHEN** the `watchStudyCourses` stream is requested
- **THEN** the system MUST exclude courses with the `info` tag when the Info tab is enabled.
- **AND** exclude courses identified as Exam content when the Exam tab is enabled.

### Requirement: Tagged Course Synchronization
The system SHALL support fetching and upserting courses filtered by tags.

#### Scenario: Syncing Info courses
- **WHEN** `refreshCourses(tags: 'info')` is called
- **THEN** the system MUST fetch page 1 of the tagged API results
- **AND** upsert them into the local database with their associated tags preserved.
