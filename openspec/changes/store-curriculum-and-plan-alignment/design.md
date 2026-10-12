## Context

The store product detail screen in Cortex currently exhibits two differences from the web LMS:
1. It displays all associated courses directly in the Curriculum tab instead of distinguishing between base product courses and courses bundled into subscription tiers.
2. It displays only count statistics (`chapters_count`, `videos_count`) rather than the actual chapter and lesson hierarchy.
3. The subscription sheet presents a flat list of duration/price pairs, omitting plan names and bundled course inclusions.

## Goals / Non-Goals

**Goals:**
- Dynamically scope the Curriculum tab to display base courses (excluding subscription plan add-on courses).
- Fetch and render real chapters and lessons inside expandable store course cards.
- Restructure the subscription plan selection bottom sheet into distinct plan cards showing plan titles, duration pricing, and bundled course tags.
- Maintain generic platform support for all product types (simple products, multi-course products, subscription passes).

**Non-Goals:**
- Modifying backend endpoints or DB schemas (all needed data exists in v3 endpoints).
- Persistent offline caching of store preview courses into local SQLite (preview courses belong in memory).
- Replacing checkout / payment gateway orchestration.

## Decisions

### D1: In-Memory Store Chapters & Contents Caching
Existing `courseChaptersProvider` writes through `CourseRepository` into SQLite tables (`CoursesTable`, `ChaptersTable`), which are designed for enrolled courses in the student's Study tab.
For store preview browsing, `StoreRepository` maintains bounded in-memory caches (`_courseChaptersCache` and `_chapterContentsCache`) with synchronous inspection methods (`getCachedCourseChapters` and `getCachedChapterContents`). Auto-disposing Riverpod providers (`storeCourseChaptersProvider` and `storeChapterContentsProvider`) delegate to `StoreRepository`.

*Rationale*: Prevents polluting the local offline student database with unenrolled preview courses, guarantees fresh curriculum state when browsing the store, and eliminates microtask skeleton flickering on collapse/re-expand without requiring global `keepAlive: true`.
*Alternative Considered*: Reusing `courseChaptersProvider` or writing preview data to Drift SQLite — rejected because storing non-enrolled courses in Drift violates offline sync constraints and pollutes the student's My Courses list.

### D2: Course Scoping via Plan Course Exclusion
In Testpress v3, `/api/v3/products/{slug}/` serializes courses from both the direct product relationship and attached subscription plans into `courses`.
To determine base curriculum courses:
```dart
final planCourseIds = {for (final plan in product.plans) ...plan.courseIds};
final baseCurriculumCourses = product.coursesDetails
    .where((course) => !planCourseIds.contains(course.id))
    .toList();
```
Fallback: If `baseCurriculumCourses` is empty (e.g. a pure subscription pass bundling multiple courses with no separate base course), the curriculum displays the courses for the active/selected plan, or all bundle courses if no plan is selected.

*Rationale*: Matches the exact template behavior on web LMS while remaining fully data-driven.

### D3: Structured Subscription Sheet Layout
`ProductSubscriptionSheet` is refactored from a flat list of `planDetails` to iterate over `product.plans` (`SubscriptionPlanDto`):
- Each plan renders as a distinct card with `plan.name` and description.
- Courses bundled into each plan are resolved by matching `plan.courseIds` with `product.coursesDetails` and displayed as badge chips.
- Duration options (`plan.planDetails`) render under each plan card with radio selection.
- Initially unselected by default if multiple plans/tiers exist.

### D4: Hierarchical Chapter & Lesson Rendering in Course Card
`ProductExpandableCourseCard` is updated to replace the count summary chips with a reactive chapter list:
- Watches `storeCourseChaptersProvider(course.id.toString())`.
- Displays skeleton shimmer while loading.
- On success, renders root chapters in order with title and expand icon using `StoreChapterTile`.
- Tapping a leaf chapter reveals its contents/lessons showing content type icons (video, doc, exam) and locked badge ("Buy to Unlock").
- Synchronous cache checks in `StoreChapterTile` ensure that re-expanding already fetched chapters renders instantly with zero skeleton flash.

## Risks / Trade-offs

- **[Risk] Multiple simultaneous chapter network calls if user expands multiple courses** → *Mitigation*: Chapters are loaded on-demand only when a course card is expanded, and `StoreRepository` caches them in memory.
- **[Risk] Products without base courses showing empty curriculum** → *Mitigation*: Fallback to active/selected plan courses ensures curriculum is never empty if courses exist.
- **[Risk] Memory growth from unbounded preview cache** → *Mitigation*: `StoreRepository` bounds curriculum caches with LRU-style eviction (`_maxCurriculumCacheSize = 200`) and flushes caches upon purchase or manual refresh.
