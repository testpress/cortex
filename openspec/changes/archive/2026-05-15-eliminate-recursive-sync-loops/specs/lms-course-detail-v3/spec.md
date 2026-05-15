## MODIFIED Requirements

### Requirement: Local Cache Streaming (SWR)
The system SHALL prioritize displaying curriculum data from the local database immediately upon page load, while triggering a non-blocking network refresh in the background.

#### Scenario: Stale-While-Revalidate loading
- **WHEN** a user opens a course or chapter folder they have previously visited
- **THEN** the system SHALL immediately display the cached data from the local database
- **AND** the system SHALL initiate a background API fetch to update the cache without showing a blocking loading indicator
