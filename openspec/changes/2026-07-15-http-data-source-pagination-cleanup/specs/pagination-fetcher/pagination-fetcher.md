## pagination-fetcher

Two reusable utilities for fetching all pages of paginated API endpoints.

### `fetchAllPaginatedPages` — Page-number pagination

```dart
Future<List<Map<String, dynamic>>> fetchAllPaginatedPages({
  required Dio dio,
  required String url,
  required dynamic firstPageData,
}) async { ... }
```

**Behavior:**
1. Accepts the raw first-page response data (already fetched by the caller).
2. Normalizes the response — handles both raw `List` and paginated `Map` with `results`, `count`, `per_page`, `next`.
3. Calculates total pages from `count / perPage`.
4. Fetches remaining pages (2..N) in parallel using `Future.wait`.
5. Returns a flat `List<Map<String, dynamic>>` of all items across all pages.

**Constraints:**
- Assumes a Django-style pagination envelope: `{ count, per_page, next, results }`.
- Returns empty list for unrecognized response shapes.

### `fetchAllCursorPages` — Cursor-based pagination

```dart
Future<List<Map<String, dynamic>>> fetchAllCursorPages({
  required Dio dio,
  required String initialUrl,
  Map<String, dynamic>? queryParameters,
}) async { ... }
```

**Behavior:**
1. Starts from `initialUrl` and fetches the first page (with optional `queryParameters`).
2. Extracts `results` list from each page response.
3. Follows the `next` field in each response, resolving relative URLs via `resolveNextUrl`.
4. Continues until `next` is null.
5. Returns a flat `List<Map<String, dynamic>>` of all items across all pages.

**Constraints:**
- Fetches pages sequentially (cursor-based — each `next` URL depends on the previous response).
- Assumes `{ next, results }` response shape.

### `resolveNextUrl` — Relative URL helper

```dart
String? resolveNextUrl(String? next) { ... }
```

Prepends `AppConfig.apiBaseUrl` to relative URLs. Returns absolute URLs as-is. Returns null for null input.
