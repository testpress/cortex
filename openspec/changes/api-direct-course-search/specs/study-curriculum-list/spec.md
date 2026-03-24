## MODIFIED Requirements

### Requirement: Searchable Curriculum
The system SHALL provide a search field in the Study tab that filters the displayed list of courses and chapters based on title matches. **When a search query is active, the system SHALL switch to API-direct search mode to ensure complete results across the entire catalog.**

#### Scenario: Search filters courses via API
- **WHEN** the user types "Physics" in the search bar
- **THEN** only courses matching "Physics" from the API remain visible, regardless of local cache status

### Requirement: Side-Effect-Free Data Seeding
The system SHALL move all data synchronization and seeding logic (refreshing courses/progress) into a dedicated application-launch routine. Data providers SHALL remain side-effect-free, acting only as reactive streams of the underlying database state. **When in search mode, the provider SHALL transition from a database stream to an ephemeral search result set to avoid polluting the persistent local data state.**

#### Scenario: Search results bypass DB reactive stream
- **WHEN** an active search query is detected
- **THEN** the curriculum provider stops watching the local database and instead emits the API-fetched results directly
