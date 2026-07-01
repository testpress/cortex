## Why

When navigating to the Ask Doubt screen directly from the Dashboard "Resume Learning" feed on a fresh app start, the breadcrumbs used for the "Ask Doubt" FAB (Course Name and Chapter Name) are missing or blank. This occurs because the initial data fetch expects the user to have already synced the entire Course and Chapter lists. Because these tables are empty locally on a fresh start, the SQLite `innerJoin` fails and returns `null`, hiding the breadcrumb completely.

## What Changes

Instead of relying on UI route arguments to pass data from the Dashboard, we will implement a resilient data fetching architecture inside `CourseRepository` using a Self-Healing Cache pattern.
- **Background Hydration (Self-Healing):** `CourseRepository.refreshLesson` will perform a non-blocking fetch of missing parent Course and Chapter data using the API and upsert them into the database.
- **Data Model Updates:** We will update `LessonDto` to accurately parse `chapter_slug` to enable the hydration of nested chapters.
- **Pure SQL Joins:** By ensuring the data is pre-fetched and hydrated before the user opens Ask Doubt, we can keep the `AppDatabase.getLessonDetails` query as a pure, lightning-fast `innerJoin` with zero network blocking.

## Capabilities

### Modified Capabilities
- `ui-ask-doubt-breadcrumb`: The system SHALL successfully display the course and chapter titles regardless of the entry point by ensuring upstream parent tables are hydrated.

## Impact

- **Affected Code**: `CourseRepository.refreshLesson` hydration logic, and `LessonDto` parsing.
- **UI/UX**: Users will now consistently see the Course and Chapter names in the Ask Doubt context badge, regardless of whether they navigate from the Dashboard, Push Notifications, or Deep Links.
