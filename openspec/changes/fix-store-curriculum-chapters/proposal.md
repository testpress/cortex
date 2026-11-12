## Why

In the Store section of the app, expanding a course's curriculum fails to show chapters and contents (instead displaying the fallback count badges, e.g. "1 Chapter, 1 Exam") because `HttpDataSource.getCourseChapters` calls the backend endpoint `/api/v3/courses/{id}/chapters/` without specifying `parent_id`. Testpress's v3 chapters endpoint requires `parent_id=null` to retrieve root chapters. Consequently, users cannot access or attempt free preview exams and lessons from the store curriculum.

## What Changes

- Update `HttpDataSource.getCourseChapters` to recursively traverse and fetch the complete course chapter tree starting from root chapters (`parent_id=null`) down through any non-leaf sub-chapters (`!isLeaf`).
- Ensure `ProductExpandableCourseCard` receives the complete chapter tree so that root chapters, sub-chapters, and chapter contents (including free preview items) render correctly.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `store-curriculum`: Update course curriculum retrieval requirements so all course chapters (both root and nested sub-chapters) are fetched and rendered in the Store curriculum view.

## Impact

- `packages/core/lib/data/sources/http_data_source.dart`: `getCourseChapters` implementation updated to recursively query chapters.
- Unit and widget test suites in `packages/core` and `packages/courses`: verify recursive chapter fetching and store expandable card rendering.

