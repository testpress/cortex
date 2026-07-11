# forum-sorting Specification

## Purpose
TBD - created by archiving change add-forum-filters. Update Purpose after archive.
## Requirements
### Requirement: Thread Sorting
The system SHALL support sorting the global forum feed threads.

#### Scenario: User selects a sort option
- **WHEN** a user selects a sort option (e.g., "Most Liked") from the segmented control
- **THEN** the system SHALL fetch and display the threads ordered by the selected sort criteria
- **AND** the system SHALL maintain the active sort order state within the feed provider

