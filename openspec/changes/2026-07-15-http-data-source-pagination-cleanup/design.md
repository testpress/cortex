## Context

`HttpDataSource` is the network data source for the app. It wraps Dio calls with `performNetworkRequest` for standardized error handling. Four methods contain duplicated pagination logic:

- `getSubjectAnalytics` and `getReviewItems` — page-number pagination: parse a response that can be either a raw `List` or a paginated `Map` with `results`, `next`, `count`, and `per_page`, compute total pages, fetch remaining pages in parallel.
- `getOfflineExamQuestions` and `_fetchFullCurriculum` — cursor-based pagination: follow the `next` URL in a while-loop, resolving relative URLs by prepending `AppConfig.apiBaseUrl`.

## Goals / Non-Goals

**Goals:**
- Extract both pagination strategies into reusable utility functions.
- Eliminate code duplication across the four methods.
- Keep `HttpDataSource` focused on transport (HTTP calls, query params, error handling).

**Non-Goals:**
- Changing the `DataSource` abstract interface.
- Refactoring other `HttpDataSource` methods that use simple `fromJson` closures (these are acceptable — they're one-shot transformations, not pagination orchestration).
- Refactoring `getCourseContents` (a `Stream` that yields per-page — different pattern).

## Decisions

### 1. Two utilities in one file
`fetchAllPaginatedPages` (page-number) and `fetchAllCursorPages` (cursor-based) live together in `packages/core/lib/network/pagination_fetcher.dart`.

- **Rationale:** Both are pagination strategies operating on Dio and raw HTTP responses. One file keeps them cohesive.

### 2. Return `List<Map<String, dynamic>>` (raw JSON)
Both utilities return unparsed JSON. DTO conversion stays in the calling `HttpDataSource` method.

- **Rationale:** Keeps the utilities generic and reusable. Callers decide how to map the raw data.

### 3. Cursor helper handles sequential fetching
`fetchAllCursorPages` fetches pages sequentially (not in parallel) because each page's `next` URL depends on the previous response.

- **Rationale:** Cursor-based pagination is inherently sequential — you can't know page 2's URL until you fetch page 1.

### 4. `resolveNextUrl` as a shared helper
Both cursor-based methods had identical relative URL resolution logic (`if (!next.startsWith('http')) prepend apiBaseUrl`). Extracted into `resolveNextUrl`.

- **Rationale:** Eliminates duplication and makes the URL resolution behavior explicit and testable.

## Risks / Trade-offs

- **Risk:** `fetchAllPaginatedPages` assumes a standard Django-style pagination envelope (`count`, `per_page`, `next`, `results`).
  - **Mitigation:** Both callers already use this exact envelope. If future endpoints differ, new utilities can be added without modifying this one.
- **Risk:** `getCourseContents` still has its own cursor loop (it's a Stream).
  - **Mitigation:** Accepted as a non-goal. The Stream pattern is fundamentally different from Future-based accumulation.
