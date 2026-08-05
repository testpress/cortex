## 1. DTOs — Add unified response model

- [x] 1.1 Add `DashboardResponseDto` to `packages/core/lib/data/models/dashboard_dto.dart` with fields: `bannerAds`, `resumeLearning`, `whatsNew`, `completedLearning`, `leaderboard`
- [x] 1.2 Add `ResumeLearningDto` with fields: `contentAttempts`, `userVideos`, `courses`, `chapters`, `chapterContents`
- [x] 1.3 Add `CompletedLearningDto` with same fields as `ResumeLearningDto` (same shape, different key)
- [x] 1.4 Add `WhatsNewDto` with same fields as `ResumeLearningDto` (same shape, different key)
- [x] 1.5 Add sub-DTOs: `ContentAttemptDto`, `UserVideoDto`, `VideoContentDto`, `CourseSummaryDto`, `ChapterSummaryDto`, `ChapterContentSummaryDto`
- [x] 1.6 Implement `DashboardResponseDto.fromJson` parsing all 5 sections from the unified response keys: `banner_ads`, `resume_learning`, `whats_new`, `completed_learning`, `leaderboard`
- [x] 1.7 Remove old `DashboardContentsDto` and `DashboardContentDto` classes if they become unused after migration (verify first)


## 2. API Endpoint — Update endpoint constants

- [x] 2.1 Add `static const String dashboard = '/api/v3/dashboard/';` to `ApiEndpoints` in `packages/core/lib/network/api_endpoints.dart`
- [x] 2.2 Remove `bannerAds`, `resumeLearning`, `whatsNewFeed`, `recentlyCompleted` constants from `ApiEndpoints` (keep `leaderboard` and `myRank` — used by leaderboard screen)

## 3. DataSource Interface — Replace 4 methods with 1

- [x] 3.1 Add `Future<DashboardResponseDto> getDashboard();` to `DataSource` abstract class in `packages/core/lib/data/sources/data_source.dart`
- [x] 3.2 Remove `getDashboardBanners()`, `getWhatsNewFeed()`, `getResumeLearningFeed()`, `getRecentlyCompletedFeed()` from the `DataSource` interface

## 4. HTTP Data Source — Implement new method, remove old ones

- [x] 4.1 Implement `getDashboard()` in `HttpDataSource` (`packages/core/lib/data/sources/http_data_source.dart`): single GET to `ApiEndpoints.dashboard`, parse with `DashboardResponseDto.fromJson`
- [x] 4.2 Remove `getDashboardBanners()`, `getWhatsNewFeed()`, `getResumeLearningFeed()`, `getRecentlyCompletedFeed()` implementations from `HttpDataSource`
- [x] 4.3 Remove `fetchMyRank()` if only called from dashboard bootstrap (verify it is not used on leaderboard screen first)

## 5. Mock Data Source — Implement mock

- [x] 5.1 Implement `getDashboard()` in `MockDataSource` (`packages/core/lib/data/sources/mock_data_source.dart`) returning a `DashboardResponseDto` using existing mock data
- [x] 5.2 Remove mock implementations of `getDashboardBanners()`, `getWhatsNewFeed()`, `getResumeLearningFeed()`, `getRecentlyCompletedFeed()` from `MockDataSource`

## 6. DB Layer — Rename enum value

- [x] 6.1 Rename `DashboardSectionType.recentlyCompleted` → `DashboardSectionType.completedLearning` in `packages/core/lib/data/db/tables/dashboard_tables.dart`
- [x] 6.2 Update all references to `DashboardSectionType.recentlyCompleted` across the codebase to `completedLearning` (search and replace)
- [x] 6.3 Verify `app_database.dart` `watchDashboardSection` and `wipeAndInsertDashboardSection` work with the renamed enum (no changes needed if they use the enum value directly)

## 7. Dashboard Repository — Replace refresh methods with unified refresh

- [x] 7.1 Add `refreshDashboard()` method to `DashboardRepository` in `packages/core/lib/data/repositories/dashboard_repository.dart`
  - Calls `_dataSource.getDashboard()` once
  - Maps `bannerAds` → `upsertDashboardBanners()`
  - Maps `resumeLearning` → `wipeAndInsertDashboardSection(DashboardSectionType.resumeLearning, ...)`
  - Maps `whatsNew` → `wipeAndInsertDashboardSection(DashboardSectionType.whatsNew, ...)`
  - Maps `completedLearning` → `wipeAndInsertDashboardSection(DashboardSectionType.completedLearning, ...)`
  - Maps `leaderboard` → `saveLeaderboardPage(LeaderboardTimeline.thisWeek, ...)`
- [x] 7.2 Implement the join logic for `resume_learning` / `completed_learning` / `whats_new`: join `content_attempts` with `user_videos` (by `user_video_id`), `chapter_contents` (by `chapter_content_id`), `courses` (by `course_id`), `chapters` (by `chapter_id`)
- [x] 7.3 Remove `refreshHeroBanners()`, `refreshWhatsNewFeed()`, `refreshResumeLearningFeed()`, `refreshRecentlyCompletedFeed()` from `DashboardRepository`
- [x] 7.4 Keep `watchHeroBanners()`, `watchWhatsNewFeed()`, `watchResumeLearningFeed()`, `watchRecentlyCompletedFeed()` stream methods — UI depends on them (rename `watchRecentlyCompletedFeed` → `watchCompletedLearningFeed` if needed)

## 8. Providers — Update bootstrap

- [x] 8.1 Update `dashboardBootstrap` in `packages/courses/lib/providers/dashboard_providers.dart` to call `repository.refreshDashboard()` only (remove the 4 old calls + `leaderboardRepository.refreshLeaderboard()`)
- [x] 8.2 Run `flutter pub run build_runner build --delete-conflicting-outputs` in `packages/courses` to regenerate `.g.dart` files
- [x] 8.3 Run `flutter pub run build_runner build --delete-conflicting-outputs` in `packages/core` to regenerate Drift DB code if any table changes were made

## 9. Cleanup — Remove dead code

- [x] 9.1 Search for any remaining references to the 4 removed DataSource methods and fix compile errors
- [x] 9.2 Search for any remaining references to the 4 removed `ApiEndpoints` constants and fix compile errors
- [x] 9.3 Search for `recentlyCompleted` (old enum value) and confirm all are replaced with `completedLearning`
- [x] 9.4 Remove `refreshLeaderboard` call from dashboard bootstrap (already done in 8.1 — verify it's gone)
- [x] 9.5 Delete `dashboard_api_res_sample.json` from the repo root (was used for exploration only)

## 10. Verification

- [x] 10.1 Run `flutter analyze` in `packages/core`, `packages/courses`, `packages/testpress` — no errors
- [x] 10.2 Verify dashboard loads with mock data source: banners, resume learning, what's new, and completed learning sections all display
- [x] 10.3 Verify leaderboard top learners still renders on the dashboard (data from DB stream)
- [x] 10.4 Verify `recentlyCompletedFeedProvider` still works (or is updated to `completedLearningFeedProvider`) in `lesson_cards_section_wrapper.dart`

