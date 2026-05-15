# lazy-curriculum-discovery Specification

## Purpose
TBD - created by archiving change eliminate-recursive-sync-loops. Update Purpose after archive.
## Requirements
### Requirement: Discovery-based Node Fetching
The system SHALL only synchronize curriculum branches (chapters and their contents) that are currently active in the user's view, rather than pre-fetching the entire course structure.

#### Scenario: Navigating into a folder
- **WHEN** the user opens a chapter folder
- **THEN** the system SHALL trigger a background refresh only for that folder's immediate children (chapters) or content (lessons)
- **AND** the system SHALL NOT initiate synchronization for unrelated branches of the hierarchy

### Requirement: Paginated Stream Persistence
The system SHALL process and persist curriculum data page-by-page as it arrives from the network, enabling the UI to populate incrementally.

#### Scenario: Receiving large chapter list
- **WHEN** the API returns a paginated list of contents
- **THEN** the system SHALL persist the first page to the local database immediately
- **AND** the UI SHALL reflect the newly persisted items while the next pages are still being fetched

