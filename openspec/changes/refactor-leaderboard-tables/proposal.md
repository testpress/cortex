## Why

The current leaderboard local database design (`LearnersTable`) only supports a single leaderboard dataset (weekly top learners). When expanding the application to support multiple leaderboard tabs/scopes (Weekly, Monthly, All-Time) and pagination, caching multiple scopes in a single table using the user `id` as the primary key causes collisions, query complexity, and pagination/invalidation issues. Leaderboards are cached API datasets that must coexist independently without race conditions or data mixing.

## What Changes

- **Database Separation & Dedicated File**: Create a dedicated database schema file `packages/core/lib/data/db/tables/leaderboard_tables.dart`. Define the shared Drift mixin and three distinct, explicitly named tables (`weekly_leaderboard`, `monthly_leaderboard`, and `all_time_leaderboard`) with custom table name overrides.
- **Type-Safe Persistence**: Remove all `dynamic` stream and query return types. Define explicit, type-safe database queries (`watchWeeklyLeaderboard`, etc.) and map database records directly to the `LearnerDto` domain DTO model.
- **Pagination Support**: Add a `page` column to the Drift table schema mixin and include `page` in the composite primary key `{id, page}` to allow infinite scrolling and page appending without data loss.
- **Dynamic Limit & Pagination in HTTP calls**: Support pagination on the network layer via `limit` and `page` parameters in the leaderboard API endpoint.
- **Correct Query Parameters**: Correct the timeline query parameter mapping to return `null` for `allTime` timeline, matching the backend's default behavior.
- **Database Indexes**: Add database indexes on `rank` and `points` columns inside all three tables for high-performance sorting and query optimization.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `api-learners`: Refactor the persistence and network structure to fetch and cache leaderboard datasets independently for weekly, monthly, and all-time scopes, with type safety, custom table naming, indexes, and full pagination support.

## Impact

- `packages/core/lib/data/db/tables/dashboard_tables.dart`: Delete the old `LearnersTable`.
- `packages/core/lib/data/db/tables/leaderboard_tables.dart` [NEW]: Define the reusable Drift `LeaderboardColumns` mixin (with `page` column), three database tables (`WeeklyLeaderboardTable`, `MonthlyLeaderboardTable`, `AllTimeLeaderboardTable`) with composite primary keys, custom table names, and indexes on `rank` and `points`.
- `packages/core/lib/data/db/app_database.dart`: Register the three tables, bump `schemaVersion` to `22`, implement type-safe watch and paginated upsert queries, and add non-destructive migration code.
- `packages/core/lib/data/models/dashboard_dto.dart`: Implement `LeaderboardTimeline` enum with dynamic query parameter mapper (returning `null` for `allTime`).
- `packages/core/lib/data/sources/`: Refactor `DataSource`, `HttpDataSource`, and `MockDataSource` to support `fetchLeaderboard` with parameter-driven pagination.
- `packages/core/lib/data/repositories/dashboard_repository.dart`: Refactor repository to remove leaderboard methods (`watchLearners`, `refreshLearners`), keeping only banner, feed, and bootstrap-related methods.
- `packages/core/lib/data/repositories/leaderboard_repository.dart` [NEW]: Create a new repository to manage paginated network fetches, database caching, filters, and watch streams (`watchLeaderboard`, `refreshLeaderboard`) for weekly, monthly, and all-time leaderboards.
- `packages/core/lib/data/data.dart`: Export the new `LeaderboardRepository` from the core data barrel file.

