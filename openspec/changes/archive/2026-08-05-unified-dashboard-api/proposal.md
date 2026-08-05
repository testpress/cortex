## Why

The dashboard currently makes **5 separate HTTP calls** on every load (banner ads, resume learning, what's new, recently completed, and leaderboard). A new server-side unified endpoint now returns all 5 sections in a single response, reducing network overhead and startup latency. We also need to clean up the existing per-section fetch infrastructure that is now redundant.

## What Changes

- **Replace 5 separate API calls** with a single `GET /api/v3/dashboard/` request that returns `banner_ads`, `resume_learning`, `whats_new`, `completed_learning`, and `leaderboard` in one payload.
- **Add new `DashboardResponseDto`** that parses the unified JSON shape.
- **Note: key rename** — the server uses `completed_learning` instead of the old `recently_completed` key.
- **Note: structure change** — `resume_learning` is now a rich nested object (`content_attempts`, `user_videos`, `courses`, `chapters`) rather than the old flat feed format.
- **Note: `leaderboard`** is now returned inline as an array (no separate `timeline` query param needed for the dashboard default of `this_week`).
- **Remove old individual data source methods**: `getDashboardBanners`, `getWhatsNewFeed`, `getResumeLearningFeed`, `getRecentlyCompletedFeed`, `fetchLeaderboard` (standalone dashboard fetch), `fetchMyRank`, `fetchCompetitorTargets`, `fetchCompetitorThreats` — where these are only used for the dashboard bootstrap.
- **Remove old refresh methods** from `DashboardRepository`: `refreshHeroBanners`, `refreshWhatsNewFeed`, `refreshResumeLearningFeed`, `refreshRecentlyCompletedFeed`.
- **Remove old `LeaderboardRepository.refreshLeaderboard`** call from `dashboardBootstrap`.
- **Update `dashboardBootstrap`** provider to call a single unified fetch.
- **Update `DashboardSectionType`** enum: rename `recentlyCompleted` → `completedLearning` to match the new API key.
- **Remove old API endpoint constants**: `bannerAds`, `resumeLearning`, `whatsNewFeed`, `recentlyCompleted` from `ApiEndpoints` (or deprecate if used elsewhere).

## Capabilities

### New Capabilities

- `unified-dashboard-fetch`: Single network call that fetches all dashboard sections — banners, resume learning, what's new, completed learning, and leaderboard — from one endpoint and persists them to the local DB in a single transaction.

### Modified Capabilities

- `dashboard-content-feed`: The `resume_learning` and `completed_learning` sections now have a richer nested shape with explicit `content_attempts`, `user_videos`, `courses`, and `chapters`. The DTO and DB mapping must be updated to handle this.

## Impact

### packages/core
- `lib/network/api_endpoints.dart` — add new unified endpoint; remove or deprecate old dashboard endpoints
- `lib/data/sources/data_source.dart` — add `getDashboard()` method; remove old per-section methods
- `lib/data/sources/http_data_source.dart` — implement `getDashboard()`; remove old 5 implementations
- `lib/data/sources/mock_data_source.dart` — implement mock `getDashboard()`
- `lib/data/models/dashboard_dto.dart` — add `DashboardResponseDto`, `ResumeLearningDto`, `CompletedLearningDto` with new nested shapes
- `lib/data/db/tables/dashboard_tables.dart` — rename `DashboardSectionType.recentlyCompleted` → `completedLearning`
- `lib/data/db/app_database.dart` — update DB methods to reflect rename
- `lib/data/repositories/dashboard_repository.dart` — replace 4 separate refresh methods with `refreshDashboard()`

### packages/courses
- `lib/providers/dashboard_providers.dart` — update `dashboardBootstrap` to single call; remove old per-section refresh calls
- `lib/providers/dashboard_providers.g.dart` — regenerated

### packages/testpress
- `lib/screens/dashboard/widgets/lesson_cards_section_wrapper.dart` — providers unchanged (watch DB streams, not network)
- `lib/screens/dashboard/widgets/top_learners_section_widget.dart` — unchanged if leaderboard stream is still served from DB
