## Why

The current course synchronization architecture (Lazy Discovery) effectively prevents backend overloads but leaves a functional gap in **Global Filtering**. Currently, lessons only know their immediate parent chapter. This "Ancestry Blindness" makes it impossible to filter lessons at a mid-level or course-level hierarchy without performing expensive recursive traversals, which defeats the purpose of the lazy loading strategy.

We need a scalable solution that allows for instant, offline-capable filtering across deeply nested hierarchies without requiring the full subtree to be hydrated in memory, while maintaining a unified and cohesive user experience.

## What Changes

We will decouple navigation from content lookup by introducing ancestry metadata directly into the lesson data model and implement robust UI-driven data loading.

1.  **Schema Update**: The `LessonsTable` will be updated to include `courseId` and a collection of `ancestorChapterIds`.
2.  **Progressive Enrichment**: During the existing "Lazy Discovery" navigation flow, we will progressively build and persist the `ancestorChapterIds` for lessons as their branch of the tree is explored.
3.  **Indexed Filtering**: Filtering at the Course level will become a flat lookup (using `courseId`), and filtering at any Chapter level will become a membership check (using `ancestorChapterIds`), eliminating the need for recursion.
4.  **Metadata Join Resolution**: Filter results will seamlessly join with the `ChaptersTable` locally to retrieve missing chapter titles omitted by the backend filtering APIs.
5.  **Reactive Lazy Loading**: Data fetching will be driven completely by user scroll events using native Dart stream backpressure.

## Capabilities

### New Capabilities
- `lesson-ancestry-tracking`: Implementation of an unordered membership list for lessons to track all parent/ancestor chapters.
- `hierarchical-lesson-filtering`: High-performance local filtering logic that uses ancestor membership checks instead of tree traversal.
- `course-level-content-indexing`: Flat, indexed lookup capability for filtering content at the global course library level.
- `semantic-api-translation`: Repository-level anti-corruption layer mapping internal models to backend-specific API parameter quirks.
- `stream-based-pagination`: UI-driven native lazy loading utilizing `StreamSubscription` pause/resume mechanics.

## Impact

- **Core Package**: Database schema modification for `LessonsTable` and data source parameter switching logic.
- **Courses Package**: Refactoring of `CourseRepository` to handle progressive metadata enrichment, `LEFT JOIN` aggregations, and scroll-driven stream fetching.
- **UI Architecture**: Implementation of `ScrollController` listeners to drive pagination, and synchronization of `LessonListItem` proportions.
