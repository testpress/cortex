## ADDED Requirements

### Requirement: Membership-Based Filtering
The system SHALL allow filtering lessons at any chapter level by checking if the target chapter's ID is present in the lesson's `ancestorChapterIds` list.

#### Scenario: Filtering at a mid-level chapter
- **WHEN** a filter is applied at Chapter "B"
- **THEN** the system SHALL return all lessons where "B" is present in `ancestorChapterIds`

### Requirement: Scoped API Fallback for Filtering
If a filter is applied to a chapter that is not yet fully hydrated in the local cache, the system SHALL perform a scoped API request to fetch missing content for that specific chapter.

#### Scenario: Filtering an unvisited chapter
- **WHEN** a filter for "Videos" is applied to a chapter that has not been synced locally
- **THEN** the system SHALL trigger a background request to `/contents?types=video&chapter={id}`
- **AND** returned lessons SHALL be persisted to the local DB with ancestry enrichment before being displayed

### Requirement: Lazy Scroll-Driven Pagination
The system SHALL not eagerly prefetch all pages of a filtered API response. Subsequent pages SHALL only be fetched when the user scrolls near the end of the current result list.

#### Scenario: Multi-page filter result
- **WHEN** a filter returns a first page of results
- **THEN** the stream SHALL be paused immediately after delivering the first page
- **WHEN** the user scrolls within 200px of the bottom of the list
- **THEN** the stream SHALL resume and fetch the next page
- **AND** a loading indicator SHALL be shown at the bottom during the fetch
