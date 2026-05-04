# Integration Tasks: What's New Dashboard Section

## Phase 1: Database Infrastructure (Generic Section Support) [COMPLETE]
- [x] 1.1 Define **`DashboardSectionType`** enum (whatsNew, resumeLearning, etc.) in `dashboard_tables.dart`.
- [x] 1.2 Define **`DashboardContentType`** enum (video, pdf, course, etc.) in `dashboard_tables.dart`.
- [x] 1.3 Implement **`DashboardContentsTable`** as a generic mapping table using these enums.
- [x] 1.4 Register table in `AppDatabase` and update migration logic to **v14**.
- [x] 1.5 Implement transactional generic helpers in `AppDatabase` for watching and wiping sections.

## Phase 2: Data Models & API Integration
- [x] 2.1 Add `whatsNewFeed` endpoint to `ApiEndpoints` (`/api/v2.4/whats-new/`).
- [x] 2.2 Create **`DashboardContentsDto`** in `packages/core/lib/data/models/dashboard_contents_dto.dart`.
    - This DTO should be reusable for other dashboard sections in the future.
- [x] 2.3 Implement parsing logic for dashboard contents.
- [x] 2.4 Update **`DataSource`** and **`HttpDataSource`** to return `DashboardContentsDto`.
- [x] 2.5 Add mock data for "What's New" in `mock_data.dart` and implement in `MockDataSource`.

## Phase 3: Repository Logic
- [x] 3.1 Implement **`watchWhatsNewFeed()`** to stream hydrated dashboard content from the database.
- [x] 3.2 Implement **`refreshWhatsNewFeed()`** to fetch and persist dashboard content.

## Phase 4: UI & State Management
- [x] 4.1 Create Riverpod provider **`whatsNewFeedProvider`**.
- [x] 4.2 Replace `dummyWhatsNewLessons` hardcoded list in `PaidActiveHomeScreen` with the provider.
- [x] 4.3 Verify visual correctness (icons, duration, chapter labels) and flicker-free updates.

## Phase 5: Centralized Navigation
- [x] 5.1 Define `AppRouteNames` constants in `packages/core/lib/navigation/route_names.dart`.
- [x] 5.2 Assign names to routes in `packages/testpress/lib/navigation/app_router.dart`.
- [x] 5.3 Implement `LessonRouter.navigateToLesson` helper in `app_router.dart`.
- [x] 5.4 Refactor `LessonCardsSectionWidget` to use `LessonRouter`.
- [x] 5.5 Refactor `ChaptersListPage` to use `LessonRouter`.
- [x] 5.6 Refactor `ChapterDetailPage` (in `app_router.dart`) to use `LessonRouter`.
