# subject-analytics Specification

## Purpose
TBD - created by archiving change integrate-subject-analytics-api. Update Purpose after archive.
## Requirements
### Requirement: Subject Analytics Data Fetching
The system SHALL fetch subject analytics data from the backend API and cache it locally in the Drift database to support an offline-first experience. The UI MUST always read from the local database stream.

#### Scenario: Initial Load (Empty Cache)
- **WHEN** the user opens the subject analytics screen and the local database is empty
- **THEN** the system displays a skeleton loader, fetches the first page from the API, saves it to the local database, and updates the UI with the real data.

#### Scenario: Subsequent Load (Offline-First)
- **WHEN** the user opens the subject analytics screen and data exists in the local database
- **THEN** the system instantly displays the cached data and triggers a background fetch from the API.
- **AND WHEN** the background fetch completes
- **THEN** the system updates the local database using a delete-and-insert transaction to replace stale data, seamlessly updating the UI without showing a skeleton loader.

### Requirement: Subject Analytics Data Parsing
The system SHALL merge the separated `subjects` metadata and `subject_stats` scores returned by the API into unified `SubjectAnalyticsDto` instances based on matching IDs.

#### Scenario: Valid Matching Data
- **WHEN** the API returns a valid `subject` and a corresponding `subject_stat` with the same ID
- **THEN** the system successfully merges them into a single `SubjectAnalyticsDto`.

### Requirement: Lazy Pagination
The system SHALL support lazy loading for subject analytics lists by tracking pagination state (`currentPage`, `hasMorePages`, `isFetchingNextPage`).

#### Scenario: Reaching the End of the List
- **WHEN** the user scrolls to the bottom of the subject list and `hasMorePages` is true
- **THEN** the system displays skeleton loader items at the bottom of the list and fetches the next page from the API.

### Requirement: Hierarchical Subject Navigation
The system SHALL fetch the next level of child subjects for any node in the hierarchy that is not a leaf node.

#### Scenario: Navigating into a Non-Leaf Subject
- **WHEN** the user taps on a subject that has the property `leaf: false`
- **THEN** the system navigates to the topic analytics screen and fetches the child subjects by passing the clicked subject's ID as the `parent` parameter to the API.

