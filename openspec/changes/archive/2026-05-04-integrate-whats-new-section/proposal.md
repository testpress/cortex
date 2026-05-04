## Why

Currently, the "What's New" section on the dashboard uses hardcoded mock data. This change aims to integrate the real-time `/api/v2.4/whats-new/` feed to provide students with a unified, up-to-date view of the latest lessons and contents across all their enrolled courses.

## What Changes

- **API Integration**: Implementation of the `/api/v2.4/whats-new/` endpoint using the specialized `DashboardContentsDto`.
- **Reusable Data Models**: Introduction of `DashboardContentsDto` as a standard container for normalized dashboard feeds (Lessons, Chapters, Courses), enabling future reuse for "Resume Learning" and "Trending" sections.
- **Hydration & Enrichment**: Enhanced `CurriculumParser` logic to resolve metadata (like Chapter Names) and map granular `DashboardContentType` enums.
- **Centralized Navigation Architecture**: Implementation of a unified `LessonRouter` system to eliminate duplicated routing logic and ensure consistent navigation across the app using Named Routes.
- **Offline-First Persistence**: Introduction of a dedicated `DashboardContentsTable` to manage ordered dashboard sections (e.g., 'whats_new'). This allows for instant UI hydration and flicker-free updates when the app is launched or offline.
- **UI Connectivity**: Transition the `PaidActiveHomeScreen` to use a reactive `whatsNewLessonsProvider` instead of static dummy data.

## Capabilities

### New Capabilities
- `dashboard-sync-engine`: Handles the fetching and "hydration" of normalized content items, resolving chapter metadata in-memory, and persisting mappings to the local DB for offline access.
- `generic-dashboard-infrastructure`: A database-backed mapping system that supports multiple sections (Whats New, Resume, etc.) and granular content types.

### Modified Capabilities
- `lms-home-paid-active`: Update the home screen to consume the new `whatsNew` data stream.

## Impact

- **Database**: New table `DashboardContentsTable` and migration (v14).
- **Core Package**: New repository methods in `DashboardRepository` and endpoint in `ApiEndpoints`.
- **Courses Package**: New Riverpod provider for the dashboard feed.
- **UI**: High-fidelity cards updated to reflect real lesson progress, chapter names, and content types.
