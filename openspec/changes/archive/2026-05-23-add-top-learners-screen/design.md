## Context

Users want a full screen to view top learners, expanded from the `TopLearnersSection` widget on the dashboard. They also need a way to track their direct competitors (users ranked immediately above and below them). The dashboard widget already exists in `packages/courses`, and the `LearnerDto` data model resides in `packages/core`. We need to define where the new screen lives, how the dashboard navigates to it, and how we handle the competitors data flow.

## Goals / Non-Goals

**Goals:**
- Implement a `TopLearnersScreen` with a dual-tab architecture (Rank List and Competitors).
- Establish a dedicated `leaderboard` folder structure in `packages/courses/lib/screens/` and `packages/courses/lib/widgets/`.
- Expand the core data layer (`LeaderboardRepository`, `DataSource`) to fetch competitor targets and threats.
- Wire navigation from the existing `TopLearnersSection`'s "View All" button to this new screen.

**Non-Goals:**
- Do not refactor existing `LearnerDto` properties unless strictly required for competitors tracking.
- Do not change how the dashboard `TopLearnersSection` fetches its preview data.

## Decisions

- **Location of the UI Components**: We decided to place the `TopLearnersScreen` inside `packages/courses/lib/screens/leaderboard/` and corresponding widgets in `packages/courses/lib/widgets/leaderboard/`.
  *Rationale*: The existing `TopLearnersSection` is inside the courses package, and metrics like "courses completed" closely align with the courses domain.
- **Competitors Tab Architecture**: The UI will feature subtabs switching between a general rank list and a specific competitors list (`CompetitorsBody`). The repository will assemble the list by combining current user, target, and threat endpoints.
  *Rationale*: Keeps the leaderboard engaging and highly personalized for the user without cluttering the global list.
- **Navigation Flow**: The `AppRoute` will be used in `paid_active_home_screen.dart` (testpress package) or inside `top_learners_section.dart` to push to `TopLearnersScreen`.
  *Rationale*: We follow platform-neutral routing (`Navigator.of(context).push(AppRoute(page: ...))`) per `ai_context.md`.
- **UI Architecture Constraints**:
  *Rationale*: The screen will be constructed entirely using core primitives (`AppText`, `AppCard`, `AppHeader`, `AppScroll`) in compliance with `ai_context.md` (no Material or Cupertino widgets).

## Risks / Trade-offs

- [Risk] If the leaderboard dataset grows huge, rendering a massive list could impact performance.
  → Mitigation: The UI should use lazy-rendering widgets (like `ListView.builder` or optimized `AppScroll` configurations) to maintain 60fps scrolling.
- [Risk] Fetching targets and threats requires multiple concurrent API requests.
  → Mitigation: Use `Future.wait` in `LeaderboardRepository.getCompetitors()` to parallelize data fetching without blocking UI rendering unnecessarily.
