## Why

`HttpDataSource` contains duplicated pagination logic across four methods. Two use page-number pagination (`getSubjectAnalytics`, `getReviewItems`) and two use cursor-based pagination (`getOfflineExamQuestions`, `_fetchFullCurriculum`). Each method reimplements the same while-loop, URL resolution, and DTO conversion pattern. This violates separation of concerns — a network class should handle transport, not pagination orchestration — and creates a maintenance burden from the duplication.

## What Changes

- Extract `fetchAllPaginatedPages` — handles page-number pagination (parallel fetch using `count`/`per_page`).
- Extract `fetchAllCursorPages` — handles cursor-based pagination (sequential fetch following `next` URL).
- Add `resolveNextUrl` helper for relative URL resolution.
- Simplify four `HttpDataSource` methods to delegate pagination to the utilities and only perform DTO conversion.
- No changes to the `DataSource` interface, repository layer, or consumers.

## Capabilities

### New Capabilities
- `pagination-fetcher`: Two reusable pagination utilities — one for page-number endpoints, one for cursor-based endpoints.

### Modified Capabilities
- None.

## Impact

- **Data Layer**: `HttpDataSource` methods become thinner — they call the utility and map results.
- **No interface changes**: `DataSource` contract remains identical. Repositories and providers are unaffected.
- **Eliminates ~150 lines of duplicated pagination code** across four methods.
