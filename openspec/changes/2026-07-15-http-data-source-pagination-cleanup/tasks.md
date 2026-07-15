## 1. Create Pagination Fetcher Utilities

- [x] 1.1 Create `packages/core/lib/network/pagination_fetcher.dart` with `fetchAllPaginatedPages` (page-number) and `fetchAllCursorPages` (cursor-based) functions.
- [x] 1.2 Add `resolveNextUrl` helper for relative URL resolution.

## 2. Simplify HttpDataSource Methods

- [x] 2.1 Refactor `getSubjectAnalytics` to use `fetchAllPaginatedPages` + DTO mapping.
- [x] 2.2 Refactor `getReviewItems` to use `fetchAllPaginatedPages` + DTO mapping + sorting.
- [x] 2.3 Refactor `getOfflineExamQuestions` to use `fetchAllCursorPages` + `QuestionDto.parseOfflineQuestions`.
- [x] 2.4 Refactor `_fetchFullCurriculum` to use `fetchAllCursorPages` + `CurriculumParser`.

## 3. Verify

- [x] 3.1 Run `dart analyze` on `packages/core`.
- [x] 3.2 Confirm no regressions in existing tests.
