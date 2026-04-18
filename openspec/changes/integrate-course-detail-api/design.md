# Design: Course Detail API Integration V3

## Context
The current implementation uses a generic course list. To provide a rich and performant learning experience, we use a **Lazy-Loading** architecture that fetches hierarchical curriculum data on-demand. This design ensures instant page loads using local cache while maintaining data freshness via silent background refreshes.

## Goals / Non-Goals

**Goals:**
- Implement **Lazy Synchronization**: Fetch chapters only when entering a course or folder using `?parent_id={id}`.
- Standardize on **isChaptersSynced** flags in `CoursesTable` and `ChaptersTable` for state persistence.
- Implement **Leaf-Node Navigation**: Decoupled `chapterDetail` lookup that resolves any chapter by ID regardless of depth.
- Support **Hierarchical UI**: Custom navigation for drilling down into nested curriculum without Material dependencies.
- Optimize Data Flow: **Stale-While-Revalidate** pattern using Stream providers and `.ignore()` for background refreshes.

**Non-Goals:**
- Bulk-loading the entire curriculum tree at startup.
- Manual "Pull-to-Refresh" (replaced by automatic silent background sync).
- Direct Material library dependencies in the core curriculum UI.

## Decisions

### 1. Lazy-Loading Strategy
Instead of fetching the full curriculum tree, the system calls `/api/v3/courses/{id}/chapters/?parent_id={parentId}`.
- If `parentId` is null, it fetches top-level subjects.
- If `parentId` is provided, it fetches specific sub-folders.
- The local database stores the `isChaptersSynced` flag at each node to prevent redundant initial loads.

### 2. Silent Synchronization (SWR)
- **First Load**: If `isChaptersSynced` is false, the system awaits the API call (User sees spinner).
- **Subsequent Loads**: If `isChaptersSynced` is true, the system emits DB data immediately and triggers a background refresh via `.ignore()`. If changes are detected, the UI updates reactively.

### 3. Unified Repository Interface
- `isChaptersSynced(courseId, {parentId})`: Unified check for both course and folder sync status.
- `refreshChapters(courseId, {parentId})`: Standardized fetch-and-save routine.
- `watchChapter(id)`: direct database watcher for individual chapters to support deep-linking.

## Risks / Trade-offs

- **User Perceived Latency**: The very first time a folder is opened, there will be a brief API delay. This is an intentional trade-off to save massive bandwidth and startup time for large courses.
- **Background Sync Noise**: Multiple background refreshes might fire if a user navigates rapidly. This is mitigated by the repository's debounce/concurrency handling in the future if needed.

## Open Questions
- Should we implement a global cache expiry for `isChaptersSynced` (e.g., auto-expire after 24 hours)? Currently, it relies on silent re-validation on every visit.
