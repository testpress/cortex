## Why

When navigating to the Ask Doubt screen directly from the Dashboard "Resume Learning" feed on a fresh app start, the hierarchical breadcrumbs used for the "Ask Doubt" FAB are missing or blank. This occurs because the initial data fetch expects the user to have already synced the entire Course and Chapter lists. Because these tables are empty locally on a fresh start, the SQLite `innerJoin` fails and returns `null`, hiding the breadcrumb completely.

## What Changes

Instead of relying on UI route arguments to pass data from the Dashboard, we will implement a robust **Self-Healing Cache** pattern inside `CourseRepository`. By enforcing the Repository as the Single Source of Truth, the flow is updated as follows:

- **Query Local DB:** MUST attempt `_db.getLessonDetails(lessonId)` using the strict `innerJoin`.
- **Background Hydration:** If the joined tables fail or are missing, `CourseRepository.refreshLesson` MUST perform a non-blocking background fetch.
- **API Extension:** It MUST parse the `chapter_slug` from the lesson payload, call a new `getChapterDetail(slug)` endpoint, and silently upsert the missing chapter to the database.

## Capabilities

### Modified Capabilities
- `ui-ask-doubt-breadcrumb`: MUST display the breadcrumb correctly by relying on the repository's background hydration to populate the missing parent tables.

## Impact

- **Affected Code**: `CourseRepository.refreshLesson` hydration logic, `LessonDto` parsing, `DoubtContextBadge` component, and data sources.
- **UI/UX**: Users will now consistently see the correct hierarchical breadcrumbs (Course > Chapter, or Subject Name) in the Ask Doubt context badge, regardless of whether they navigate from the Dashboard, Push Notifications, or Deep Links.
