# lms-course-detail-v3 Specification

## Purpose
TBD - created by archiving change integrate-course-detail-api. Update Purpose after archive.
## Requirements
### Requirement: Course Detail API Integration
The system SHALL provide functionality to fetch comprehensive metadata for a single course via the `/api/v3/courses/{course_id}/` endpoint.

#### Scenario: Successful Metadata Fetch
- **WHEN** a user navigates to a course detail page
- **THEN** the system SHALL call the v3 course detail endpoint
- **AND** the system SHALL map `title`, `description`, `image`, and `contents_count` to the view model

### Requirement: Lazy Hierarchical Curriculum Fetching
The system SHALL provide functionality to lazily fetch the structured curriculum (chapters and their contents) via the `/api/v3/courses/{course_id}/chapters/?parent_id={parentId}` endpoint.

#### Scenario: Loading Selective Chapter Levels
- **WHEN** the user views the "All" tab or enters a folder
- **THEN** the system SHALL check if the current level is already marked as `isChaptersSynced`
- **IF** not synced, the system SHALL call the v3 chapters endpoint with the `parent_id` parameter
- **AND** the system SHALL display the fetched chapters in their correct hierarchy
- **ELSE** the system SHALL display cached data and trigger a background refresh

### Requirement: Independent Leaf-Node Resolution
The system SHALL allow navigation to any chapter ID directly (leaf nodes) using a standalone database watcher to support deep-linking.

#### Scenario: Deep-link to deep chapter
- **WHEN** the app is opened with a deep link to a specific chapter ID
- **THEN** the system SHALL fetch the chapter details from the local database or API without requiring the full course tree to be loaded

### Requirement: Local Cache Streaming (SWR)
The system SHALL prioritize displaying curriculum data from the local database immediately upon page load, while triggering a non-blocking network refresh in the background via the `.ignore()` pattern.

#### Scenario: Stale-While-Revalidate loading
- **WHEN** a user opens a course they have previously visited
- **THEN** the system SHALL immediately display the cached chapter list from the local database
- **AND** the system SHALL initiate a background API fetch to update the cache without showing a blocking loading indicator

### Requirement: API Endpoint Constants
The system SHALL define the new v3 course endpoints in the `ApiEndpoints` class.
- `courseDetail(id)`
- `courseChapters(id, parentId)`
- `courseContents(id)`

#### Scenario: Constant usage in data source
- **WHEN** the `HttpDataSource` needs to build a URL for course details
- **THEN** it SHALL use the `ApiEndpoints.courseDetail(id)` constant to ensure URI consistency

