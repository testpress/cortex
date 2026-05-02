## ADDED Requirements

### Requirement: Fetch and Cache Learners
The system SHALL retrieve learners data from the reputation system and persist it locally for offline-first access.

#### Scenario: Network Fetch and DB Caching
- **WHEN** the `DashboardRepository.refreshLearners()` method is called
- **THEN** the system MUST fetch data from `/api/v2.3/leaderboard/`
- **AND** store the results in the Drift `LearnersTable`
- **AND** the table MUST maintain the rank order returned by the server

### Requirement: Unified Learners Provider
The system SHALL expose a single stream of learners data for the UI to consume.

#### Scenario: Provider Data Resolution
- **WHEN** the UI watches `learnersProvider`
- **THEN** it MUST yield a `List<LearnerDto>` sourced directly from `DashboardRepository.watchLearners()`
- **AND** the list MUST be ordered by rank/points
