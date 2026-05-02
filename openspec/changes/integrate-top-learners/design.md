## Context
The Learners dashboard feature currently relies on hardcoded mock data and multiple providers in `packages/courses`. To move to a production-ready state, we need to integrate the real Testpress API (`/api/v2.3/leaderboard/`), enforce strict naming conventions ("Learners"), and implement persistent caching via Drift to ensure a fast, offline-first user experience.

## Goals / Non-Goals

**Goals:**
- Implement real-time learners fetching.
- Cache learners data locally using a new `LearnersTable` in Drift.
- Simplify state management by using a single `learnersProvider` that returns data sorted by points.
- Formalize `LearnersDto` in `packages/core` for shared access and JSON serialization.

**Non-Goals:**
- Implementing "View All" or pagination for the full learners list.
- Supporting multiple timeframes (Monthly/Overall) in the initial dashboard version.
- Rendering badges. Since the backend does not provide badge data, `LearnerBadgeDto` and all related UI code will be entirely removed.

## Decisions

### 1. Unified State Management
**Decision**: Replace `topLearnersProvider` and `otherLearnersProvider` with a single `learnersProvider`.
**Rationale**: The API returns a single list of learners. Managing it as a single source of truth in Riverpod is cleaner. The UI component (`TopLearnersSection`) will be updated to take a single list and internally partition it (Top 3 for the podium, 4-10 for the standard list).

### 2. DTO Relocation and Renaming
**Decision**: Move the existing `LearnerDto` from `packages/courses` to `packages/core/lib/data/models/`, rename it to `LearnersDto`, and add `fromJson` factories.
**Rationale**: The `DashboardRepository` lives in `core` and needs access to these models to manage persistence and state. 

### 3. Database Schema
**Decision**: Create a `LearnersTable` in `AppDatabase` with the following columns:
- `id` (Text, Primary Key)
- `name` (Text)
- `avatar` (Text)
- `points` (Real/Double)
- `rank` (Int)
**Rationale**: A dedicated table ensures instant loading on subsequent app launches, satisfying the offline-first requirement.

## Risks / Trade-offs

- **[Risk] Missing Fields**: The current API does not provide `coursesCompleted` or `streakDays`.
- **[Mitigation]**: We will keep these fields in the `LearnersDto` but mark them as optional (defaulting to 0) during JSON parsing to ensure the UI doesn't crash while gracefully hiding empty stats.
