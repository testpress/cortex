# Proposal: Integrate Course Detail API V3

## Goal
Integrate the V3 Course Detail, Chapters, and Contents APIs into the LMS SDK using a **Lazy-Loading synchronization strategy** to support performant, hierarchical curriculum views.

## What Changes
- Add `courseDetail`, `courseChapters`, and `courseContents` endpoints to `ApiEndpoints`.
- Implement **On-Demand (Lazy) Synchronization**: Chapters and contents are fetched only when a user navigates into a course or folder.
- Implement **isChaptersSynced** flags in the local database to track synchronization status at every node (Course and Chapter).
- Implement a **"Stale-While-Revalidate"** data flow: Display cached data immediately and perform a silent background refresh.
- Refactor `CourseRepository` and `subChaptersProvider` to support hierarchical lookup by `parentId`.

## Capabilities

### New Capabilities
- `lms-course-detail-v3`: Capability to fetch full metadata for a single course via `/api/v3/courses/{id}/`.
- `lms-course-chapters-lazy-v3`: Capability to lazily fetch hierarchical chapters via `/api/v3/courses/{id}/chapters/?parent_id={id}`.
- `lms-course-contents-v3`: Capability to fetch a flat list of all lessons in a course via `/api/v3/courses/{id}/contents/`.

### Modified Capabilities
- `lms-study-chapters-list`: Updated to use recursive, ID-based chapter resolution, allowing deep-link navigation to any leaf node.

## Impact
- `packages/core/lib/data/db`: Schema update (Version 9) for sync flags.
- `packages/core/lib/data/models/course_dto.dart`: Integrated v3 detail fields and `isChaptersSynced` flag.
- `packages/core/lib/data/models/chapter_dto.dart`: Integrated `isChaptersSynced` flag and `parentId` support.
- `packages/courses`: Refactored providers to handle independent, hierarchical data fetching.
