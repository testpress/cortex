## 1. Setup

- [x] 1.1 Create `leaderboard` directory in `packages/courses/lib/screens/`
- [x] 1.2 Create `leaderboard` directory in `packages/courses/lib/widgets/`
- [x] 1.3 Add localization keys for competitors UI in `app_en.arb` and `app_ar.arb`

## 2. Data Layer Implementation

- [x] 2.1 Add `competitorTargets` and `competitorThreats` to `ApiEndpoints`
- [x] 2.2 Implement `fetchCompetitorTargets` and `fetchCompetitorThreats` in `DataSource` (Mock & HTTP)
- [x] 2.3 Implement `getCompetitors()` logic in `LeaderboardRepository` using `Future.wait` for parallel fetching

## 3. UI Implementation

- [x] 3.1 Implement `TopLearnersScreen` with dual-tab logic (Rank List & Competitors) in `packages/courses/lib/screens/leaderboard/`
- [x] 3.2 Create `CompetitorListItem` and `CompetitorsBody` for the new tab
- [x] 3.3 Construct the screen UI using core primitives (`AppText`, `AppScroll`, `AppHeader`, `AppCard`)
- [x] 3.4 Refactor or extract shared learner list item UI from `top_learners_section.dart` to `packages/courses/lib/widgets/leaderboard/` if reusable

## 4. Navigation Wiring

- [x] 4.1 Update `packages/courses/lib/widgets/top_learners_section.dart` (or the dashboard orchestrator) to handle the "View All" tap
- [x] 4.2 Add `AppRoute` navigation pushing to `TopLearnersScreen`
