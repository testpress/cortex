## Context

The dashboard currently bootstraps by making **5 separate HTTP calls** in parallel:

1. `GET /api/v2.4/banner-ads/` → `getDashboardBanners()`
2. `GET /api/v2.4/resume/` → `getResumeLearningFeed()`
3. `GET /api/v2.4/whats-new/` → `getWhatsNewFeed()`
4. `GET /api/v2.4/completed/` → `getRecentlyCompletedFeed()`
5. `GET /api/v2.3/leaderboard/?timeline=this_week&limit=10` → `fetchLeaderboard()`

The server now exposes a single unified endpoint that returns all 5 sections in one response. Each section key in the response maps to a known dashboard section, with two structural changes:

- `recently_completed` → renamed to `completed_learning`
- `resume_learning` → now a richer nested object (`content_attempts`, `user_videos`, `courses`, `chapters`) instead of a flat content feed

The existing architecture already uses a DB-first stream pattern: the UI watches database streams, and refresh calls write to the DB. This design keeps that pattern intact — only the network layer and the data mapping change.

## Goals / Non-Goals

**Goals:**
- Replace 5 HTTP calls with 1 for every dashboard load
- Parse the new unified response shape into existing DB tables (no DB schema change needed)
- Remove all dead code (old per-section fetch methods, old endpoints, old refresh methods)
- Keep the UI layer (`lesson_cards_section_wrapper`, `top_learners_section_widget`) unchanged — they watch DB streams

**Non-Goals:**
- Changing the DB schema or adding new Drift tables
- Changing the leaderboard full-page experience (pagination, timeline tabs) — only the dashboard bootstrap is affected
- Migrating `fetchCompetitorTargets` / `fetchCompetitorThreats` — these are used on the leaderboard screen, not the dashboard bootstrap
- Consuming the extra keys in the unified response (`popular_products`, `recently_added_products`, `suggested_exams`, `suggested_videos`, `bookmarks`, `course_progress`) — out of scope

## Decisions

### 1. Single new DTO: `DashboardResponseDto`

**Decision**: Add a top-level `DashboardResponseDto` that holds all 5 sections. Each section maps to an existing DTO or a new lightweight sub-DTO.

**Rationale**: Keeping it as a single DTO keeps parsing co-located and easy to test. We avoid spreading JSON parsing across 5 separate fromJson calls.

**Alternatives considered**:
- Reuse existing `DashboardContentsDto` for all sections — rejected because `resume_learning` and `completed_learning` now have a structurally different shape (nested relations, not a flat list).

### 2. New sub-DTOs for resume and completed sections

**Decision**: Introduce `ResumeLearningDto` and `CompletedLearningDto` that model the nested API shape, and then flatten them into the existing `DashboardContentDto` / DB companion format inside the repository.

**Rationale**: The mapping complexity lives in the repository (where it always has), not in the DTO itself. DTOs should mirror the API shape; the repository is the right place for business mapping logic.

**Fields used from `resume_learning`**:
- `content_attempts[].chapter_content_id` → lesson ID
- `content_attempts[].content_type` → lesson type
- `user_videos[id].video_content.title` → title
- `user_videos[id].video_content.duration` → total duration
- `user_videos[id].remaining_duration` → remaining duration
- `user_videos[id].watched_percentage` → progress
- `chapter_contents[id].cover_image_medium` → cover image
- `courses[id].title` → course name (used as chapter title fallback)
- `chapters[id].name` → chapter name

**Fields used from `completed_learning`**:
- Same structure as `resume_learning`, filtering `content_attempts` where `state == "Completed"`

### 3. New endpoint constant: `ApiEndpoints.dashboard`

**Decision**: Add `static const String dashboard = '/api/v3/dashboard/';` and remove the 5 old dashboard-specific constants: `bannerAds`, `resumeLearning`, `whatsNewFeed`, `recentlyCompleted`.

**Note**: `leaderboard` and `myRank` constants are kept because they are also used by the full leaderboard screen (not just dashboard bootstrap).

### 4. Single `getDashboard()` method on `DataSource`

**Decision**: Add `Future<DashboardResponseDto> getDashboard()` and remove `getDashboardBanners()`, `getWhatsNewFeed()`, `getResumeLearningFeed()`, `getRecentlyCompletedFeed()`.

**Rationale**: Clean separation — one server concept = one method.

### 5. Single `refreshDashboard()` on `DashboardRepository`

**Decision**: Replace `refreshHeroBanners()`, `refreshWhatsNewFeed()`, `refreshResumeLearningFeed()`, `refreshRecentlyCompletedFeed()` with a single `refreshDashboard()` that fetches once and writes all sections to the DB.

**Rationale**: Atomic refresh — either all sections update or none do (via a single try/catch). Simpler to reason about.

### 6. `DashboardSectionType.recentlyCompleted` → `completedLearning`

**Decision**: Rename the enum value to match the new API key. Because this is a Drift-managed enum, all existing DB rows with `recentlyCompleted` will need to be handled via a DB migration or re-seeded on next boot.

**Migration approach**: On app boot, the dashboard refresh will wipe and re-insert all sections via `wipeAndInsertDashboardSection`. No manual migration is needed — stale rows under the old enum value simply won't be read (the watch query filters by section type), and they'll be cleaned up on next full refresh.

### 7. `whats_new` response shape

The `whats_new` key returns a nested object with `content_attempts`, `user_videos`, `courses`, `chapters` — same shape as `resume_learning`. The existing `DashboardContentsDto.fromJson` flat-list approach cannot be reused. We'll use the same mapping logic as resume/completed.

## Risks / Trade-offs

| Risk | Mitigation |
|------|-----------|
| New endpoint is not yet deployed in staging | Use mock data source (already in place) during development; gate behind `AppConfig` if needed |
| `DashboardSectionType.recentlyCompleted` rename could leave orphan DB rows | Wipe-and-insert strategy on every boot ensures stale rows are never shown |
| `resume_learning` mapping relies on join between `content_attempts` and `user_videos` by ID | Null-safe join logic; if a `user_video_id` is missing, skip that attempt |
| Removing `getDashboardBanners()` etc. may break mock data source | Must update `MockDataSource` to implement `getDashboard()` with `mockWhatsNewFeed`, `mockResumeLearningFeed`, `mockRecentlyCompletedFeed` |

## Migration Plan

1. Add new endpoint, DTO, DataSource method, Repository method
2. Update `dashboardBootstrap` to call `repository.refreshDashboard()` only
3. Remove old per-section methods from DataSource interface + both implementations
4. Remove old endpoint constants
5. Rename `DashboardSectionType.recentlyCompleted` → `completedLearning`
6. Run `flutter pub run build_runner build` to regenerate Drift and Riverpod code
7. Verify dashboard loads correctly with mock data source
8. No rollback needed — the old endpoints remain available server-side

## Open Questions

- None — API response shape is confirmed from `dashboard_api_res_sample.json`.
