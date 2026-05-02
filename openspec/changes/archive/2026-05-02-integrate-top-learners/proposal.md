## Why
The dashboard currently relies on hardcoded mock data for the Learners section. To provide accurate student rankings and a real gamified experience, we need to integrate the live Testpress API and cache it locally for offline-first performance.

## What Changes
- **Data Consolidation**: Introduce a single `LearnersTable` in the database, a single `learnersProvider` for state, and a single `LearnerDto` for data transfer.
- **Provider Simplification**: Remove the dual provider setup. The single `learnersProvider` will return the list sorted by points. The UI will extract the top 3 for the podium and use the remainder for ranks 4-10.
- **API Integration**: Connect the network layer to the `/api/v2.3/leaderboard/` endpoint.

## Capabilities

### New Capabilities
- `api-learners`: Capability for fetching, parsing, and caching ranked learners data.

### Modified Capabilities
- `lms-home-paid-active`: Requirements updated to transition from mock-driven (dual providers) to repository-driven (single provider) learners display.

## Impact
- **Packages**: `packages/core` (Data, DB, Repository), `packages/courses` (Providers, UI refactoring).
- **Architecture**: Enforces the offline-first pattern using a simplified, single-table/single-provider approach.
