## ADDED Requirements

### Requirement: Course Content Synchronization (Merging Logic)
The system SHALL synchronize curriculum contents (lessons, assessments) and status-specific lists (Running, Upcoming, History) for a course from multiple remote API endpoints.
- The system MUST **merge** fragmented metadata (such as `chapterId`) together by comparing local cache, master curriculum, and status lists to create a single authoritative record.
- The system MUST use a deduplication strategy to ensure each lesson is unique while retaining enriched metadata from the most complete source.

#### Scenario: Syncing curriculum contents
- **WHEN** the user opens the course curriculum list
- **THEN** the system triggers a background sync with the `/contents/`, `/running_contents/`, `/upcoming_contents/`, and `/content_attempts/` APIs and updates the local database using the unified `_mergeLocalAndRemoteLessons` logic.

### Requirement: Leaf Chapter Content Status Filtering
The system SHALL filter the contents of a leaf chapter based on the selected status ("Running", "Upcoming", or "History").
- Navigating to a leaf chapter MUST trigger a targeted `refreshLessons(chapterId)` which clears old records for that chapter and replaces them with the latest authoritative list to prevent data corruption.

### Requirement: Recursive Content Scoping
The system SHALL ensure that curriculum filters (Videos, Lessons, etc.) in the hierarchical view are strictly scoped to the current chapter context.
- **WHEN** a content filter is applied in a chapter list
- **THEN** the system MUST display only those lessons that belong to the current chapter or any of its sub-chapters (recursive descendants).
