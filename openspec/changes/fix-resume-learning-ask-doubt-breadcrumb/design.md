## Context

The Ask Doubt screen fetches `courseTitle` and `chapterTitle` using the `getLessonDetails(lessonId)` database query. This query currently uses a strict `innerJoin` between the `lessonsTable`, `chaptersTable`, and `coursesTable`. Because lessons loaded from the Dashboard "Resume Learning" feed haven't synced their parent courses/chapters yet, the `innerJoin` fails, returning `null` entirely and rendering a blank breadcrumb.

## Goals / Non-Goals

**Goals:**
- Prevent blank breadcrumbs by proactively hydrating missing chapter data.
- Update `LessonDto` data structures to properly retain parsing of `chapterSlug` for data consistency.
- Keep `getLessonDetails` as a pure, fast SQLite `innerJoin` by ensuring the underlying tables are populated via background hydration.

**Non-Goals:**
- No changes to UI components or external fetching logic.

## Design Decisions

**Decision 1: Self-Healing Cache (Background Hydration)**
Instead of changing the SQL query or polluting the UI with fallback logic, we will keep `innerJoin` in `getLessonDetails`. To populate the missing data, `CourseRepository.refreshLesson` will parse `chapter_slug` from the lesson payload and perform a non-blocking background fetch (`getChapterDetail`) to silently hydrate the database.
*Rationale:* This enforces the Repository as the Single Source of Truth and maintains a strict database schema while ensuring the missing relational data is fetched properly.
