## Context

The Ask Doubt screen fetches `courseTitle` and `chapterTitle` using the `getLessonDetails(lessonId)` database query. This query currently uses a strict `innerJoin` between the `lessonsTable`, `chaptersTable`, and `coursesTable`. Because lessons loaded from the Dashboard "Resume Learning" feed haven't synced their parent courses/chapters yet, the `innerJoin` fails, returning `null` entirely and rendering a blank breadcrumb.

## Goals / Non-Goals

**Goals:**
- Guarantee the `innerJoin` query succeeds by ensuring the local database tables are pre-populated with the parent course and chapter data.
- Update `LessonDto` data structures (like `mergeWith` and `toJson`) to properly retain parsing of `chapterSlug` for data consistency and hydration fetching.

**Non-Goals:**
- No changes to UI components or external fetching logic.
- Do not change `innerJoin` to `leftOuterJoin`, keeping the SQL query strict and fast.

## Design Decisions

**Decision 1: Background Hydration (Self-Healing Cache)**
We will add `_hydrateParentsBackground` and `_hydrateNestedChapterBackground` inside `CourseRepository.refreshLesson`. Because `refreshLesson` is called instantly when the user opens the lesson, these non-blocking fetches will grab the missing parent chapters from the API using `chapterSlug` and upsert them into the database. By the time the user opens the Ask Doubt screen, the local tables will be hydrated, and the pure SQLite `innerJoin` will successfully return the breadcrumbs.
*Rationale:* This approach enforces the Repository as the single source of truth, avoids polluting the UI layer with network fallbacks, and keeps the database UI query perfectly fast and network-free.
