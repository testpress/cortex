## 1. DTO and Database Setup

- [x] 1.1 Move `LearnerDto` to `packages/core/lib/data/models/learner_dto.dart` and add `fromJson` serialization. **Delete `LearnerBadgeDto` entirely** (remove from model and UI) as it is not supported by the backend.
- [x] 1.2 Create `LearnersTable` definition in `packages/core/lib/data/db/tables/learners_table.dart` with `id`, `name`, `avatar`, `points`, `rank`.
- [x] 1.3 Register `LearnersTable` in `AppDatabase` and add migration logic to schema versioning.

## 2. Network and Repository Layer

- [x] 2.1 Add leaderboard endpoint (`/api/v2.3/leaderboard/`) to `ApiEndpoints`.
- [x] 2.2 Add `getLearners()` to `DataSource` and implement in `HttpDataSource`.
- [x] 2.3 Implement `watchLearners()` and `refreshLearners()` in `DashboardRepository`, using a transaction to delete and insert the fresh top 10 learners.

## 3. UI and State Refactoring

- [x] 3.1 Delete `topLearnersProvider`, `otherLearnersProvider`, and the hardcoded mock arrays (`mockTopLearners`, `mockOtherLearners`) in `packages/courses/lib/providers/dashboard_providers.dart` and `mock_data.dart`.
- [x] 3.2 Create a single `learnersProvider` that delegates to `DashboardRepository.watchLearners()`.
- [x] 3.3 Rename `TopLearnersSection` to `LearnersSection`, update parameters, and remove all UI code responsible for rendering badges.
- [x] 3.4 Update `PaidActiveHomeScreen` to watch the single `learnersProvider` and manually partition the list into top 3 (podium) and the rest (4-10) for the `LearnersSection`.
