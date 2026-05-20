## Context

The recent shift to "Lazy Discovery" (in the `eliminate-recursive-sync-loops` change) was necessary to prevent backend instability and 429 errors. However, this architectural change introduced "Ancestry Blindness"—lessons in the local database only know their immediate parent chapter, making it impossible to perform hierarchical or course-level filtering without expensive recursive traversals.

## Goals / Non-Goals

**Goals:**
- Enable $O(log N)$ filtering performance for lessons at any hierarchy level (Course, Chapter, or Sub-chapter).
- Maintain "Lazy Discovery" principles (never fetch the full tree just for filtering).
- Support robust offline filtering for all content that has been locally discovered.
- Ensure the data model is "Append-Only" to support progressive hydration of the hierarchy.

**Non-Goals:**
- Synchronizing the entire course subtree for every filter action.
- Changing the backend API response structure.

## Decisions

### 1. Data Structure: List Column for Ancestors
- **Decision**: Add an `ancestorourceIds` column directly to the `LessonsTable` (stored as a comma-separated string).
- **Rationale**: This approach prioritizes simplicity and maintainability over theoretical performance gains. By avoiding an extra join table, we keep the schema flat and the repository logic straightforward. For the current scale of the app, a string-based membership check (LIKE) provides acceptable performance while reducing "over-engineering."
- **Implementation**: IDs will be stored with delimiters (e.g., `,101,102,`) to ensure exact matches during `LIKE` queries.

### 2. Schema Change: Denormalized `courseId` on Lessons
- **Decision**: Add a `courseId` column directly to the `LessonsTable`.
- **Rationale**: This enables the Study Screen (Home) to perform a flat, indexed query for "All Videos in this Course" without joining the chapters table or traversing the tree. This is a critical optimization for the most frequent filter operation in the app.

### 3. Synchronization: The "Ancestry Accumulator"
- **Decision**: The `CourseRepository` will implement an "Ancestry Stack" during curriculum parsing. 
- **Rationale**: As the repository parses the heterogeneous API response (which mixed chapters and lessons), it can maintain the current "Parent Chain" and associate it with every lesson found in that specific branch. This allows us to enrich the `LessonAncestorsTable` progressively as the user explores the tree.

## Risks / Trade-offs

- **[Risk] Ancestor Desynchronization**: If a chapter is moved to a different parent on the server, the local ancestor list might become stale.
    - **Mitigation**: The `refreshCourseContents` call will perform a "Sync-and-Clear" for the specific branch it is updating, ensuring the local ancestry for those lessons is refreshed to match the server's state.
- **[Trade-off] Database Growth**: A join table increases the number of rows in the database.
    - **Mitigation**: The chapter IDs are lightweight strings. The performance benefit of instant filtering far outweighs the minor increase in disk usage.

## Next Step: Progressive Ancestor Seeding

When a filter API call is made with a specific `chapterId`, we persist the returned lessons and progressively seed that `chapterId` into `ancestorChapterIds` to build a search-friendly ancestry list.

### Requirements & Merger Logic
1. **Existing DB State Preservation**: Before writing filter response lessons to the database, we must fetch the existing lesson records from the DB to read their cached `ancestorChapterIds`.
2. **Safe Token Merging**: The scoped calling `chapterId` is merged into the existing ancestry string using a dedupe-safe format (e.g., `,A,` + `B` -> `,A,B,`). This prevents overwriting previously cached parent chapters when subsequent scoped filter requests are made.
3. **Canonical Format**: All ancestry strings must be stored with boundary delimiters (e.g., `,chapterId1,chapterId2,`) to support exact matches during `LIKE '%,id,%'` queries.

### 4. Semantic API Translation via Repository Anti-Corruption Layer
- **Decision**: The `CourseRepository` is the sole owner of domain-to-API terminology translation. A private `_getApiCompatibleType` helper maps internal filter values (`test` → `exams`, `assessment` → `quiz`) before they are passed to the data source. The `HttpDataSource` remains a transparent HTTP adapter with no domain awareness.
- **Rationale**: Architecture cleanliness. The data source should never make decisions based on domain concepts — it simply fires the request it receives. Centralizing translation in the repository makes the mapping easy to find, test, and extend without touching infrastructure code.

### 5. Progressive Metadata Enrichment via LEFT JOIN
- **Decision**: The local database query for filtered lessons uses a `LEFT OUTER JOIN` with the `chaptersTable` to inject the `chapterTitle`.
- **Rationale**: The backend's flat `/contents/` filter endpoint omits chapter metadata. Sourcing the chapter title from the local database ensures immediate, offline-first UI fidelity without waiting for network tree synchronization.

### 6. Lazy Pagination via Native Stream Backpressure
- **Decision**: Pagination is handled by native Dart `StreamSubscription` pause/resume mechanics linked directly to a `ScrollController`.
- **Rationale**: Instead of building complex paginators or fetching all pages greedily, the UI listens to the repository's `async*` stream, pauses it immediately upon receiving a chunk, and resumes it only when the user scrolls near `maxScrollExtent`. This is elegant, highly performant, and preserves the stream-based data flow.

### 7. Unified Component Proportions
- **Decision**: The `LessonListItem` used in flat filter views is explicitly constrained to match the spacing, padding, and compact layout of the `ChapterContentItem` used in the hierarchical tree views.
- **Rationale**: Prevents jarring visual inconsistencies between "tree browsing" and "flat filtering", ensuring a cohesive user experience regardless of the navigation path.

