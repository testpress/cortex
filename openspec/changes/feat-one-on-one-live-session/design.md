## Context

Testpress v3 distinguishes between course chapter live contents (`/api/v3/live-classes/contents/<id>/`) and standalone learning sessions (`/api/v3/live-classes/learning-sessions/<id>/`). 1-on-1 sessions are created with `session_type: "one_on_one"` and target individual students.

## Architecture Decisions

1. **Direct Routing by Session Type with Resilient Fallback**:
   When a session is identified as 1-on-1 via `item.isOneOnOne` from the live classes list, `HttpDataSource` records its ID in an in-memory `Set<String> _oneOnOneSessionIds` to dispatch immediately to `/api/v3/live-classes/learning-sessions/<id>/` without trial-and-error latency. For cold-starts, direct navigation, or deep-links where the session type is unknown and querying `/contents/<id>/` yields HTTP 404, `HttpDataSource` gracefully falls back to `/learning-sessions/<id>/` and records the ID in the set.

   *Note on In-Memory Routing Cache & Error Handling*:
   - `_oneOnOneSessionIds` in `HttpDataSource` is an intentional, lightweight in-memory optimization to avoid the 404 round-trip latency when opening 1-on-1 sessions from the live class list.
   - If both the primary endpoint and the fallback fail, the original contents-endpoint `ApiException` is rethrown to ensure Sentry and debug logs remain accurate without misleading traces.
   - Non-existent IDs are tracked in `_nonexistentSessionIds` so repeated lookups or retries do not repeat the fallback request.
   - Because live stream participation is an online-only operation and live class details are historically routed via `CourseRepository`, persisting `session_type` in the local Drift SQLite database is unnecessary for this feature. Correctness for cold-starts and deep-links is fully guaranteed by the 404 fallback.
   - A complete architectural decoupling of all live class details from `CourseRepository` into `LiveClassesRepository` (including dedicated SQLite columns and explicit route paths) will be addressed in a dedicated follow-up PR.

2. **Clean Domain Model Integration**:
   `LiveClassDto` parses `session_type` and provides an `isOneOnOne` boolean getter without requiring breaking Drift database table changes or schema migrations.
