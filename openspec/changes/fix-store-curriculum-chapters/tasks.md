## 1. Data Source Implementation

- [x] 1.1 Implement recursive chapter traversal in `HttpDataSource.getCourseChapters` using `getChapters` to fetch root chapters (`parentId: null`) and child chapters (`parentId: chapter.id`) for non-leaf chapters
- [x] 1.2 Safeguard against cyclical parent references by tracking visited chapter IDs during recursion

## 2. Test Verification

- [x] 2.1 Add unit tests in `packages/core` to verify `HttpDataSource.getCourseChapters` retrieves root and nested sub-chapters
- [x] 2.2 Verify existing tests in `packages/courses` pass with the updated chapter traversal
