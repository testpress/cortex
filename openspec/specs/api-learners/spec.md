# api-learners Specification

## Purpose
TBD - created by archiving change integrate-top-learners. Update Purpose after archive.
## Requirements
### Requirement: Fetch and Cache Learners
The system SHALL retrieve learners data from the reputation system and persist it locally for offline-first access based on the timeline.

#### Scenario: Network Fetch and DB Caching
- **WHEN** the `LeaderboardRepository.refreshLeaderboard(LeaderboardTimeline timeline)` method is called
- **THEN** the system MUST fetch data from `/api/v2.3/leaderboard/` with the corresponding timeline query parameter
- **AND** store the results in the corresponding Drift table (`WeeklyLeaderboardTable`, `MonthlyLeaderboardTable`, or `AllTimeLeaderboardTable`)
- **AND** the table MUST maintain the rank order returned by the server

### Requirement: Unified Learners Provider
The system SHALL expose a stream of learners data for each timeline for the UI to consume.

#### Scenario: Provider Data Resolution
- **WHEN** the UI watches `learnersProvider(timeline)`
- **THEN** it MUST yield a `List<LearnerDto>` sourced directly from `LeaderboardRepository.watchLeaderboard(timeline)`
- **AND** the list MUST be ordered by rank/points

