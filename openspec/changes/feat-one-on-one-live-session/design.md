## Context

Testpress v3 distinguishes between course chapter live contents (`/api/v3/live-classes/contents/<id>/`) and standalone learning sessions (`/api/v3/live-classes/learning-sessions/<id>/`). 1-on-1 sessions are created with `session_type: "one_on_one"` and target individual students.

## Architecture Decisions

1. **Direct Routing by Session Type with Resilient Fallback**:
   When a session is identified as 1-on-1 via `item.isOneOnOne` from the live classes list, `HttpDataSource` records its ID via `LiveSessionRoutingCache` to dispatch immediately to `/api/v3/live-classes/learning-sessions/<id>/` without trial-and-error latency. For cold-starts, direct navigation, or deep-links where the session type is unknown and querying `/contents/<id>/` yields HTTP 404, `HttpDataSource` gracefully falls back to `/learning-sessions/<id>/` and records the ID in the cache.

   *Note on In-Memory Routing Cache & Error Handling*:
   - `LiveSessionRoutingCache` in `HttpDataSource` encapsulates intentional, non-authoritative in-memory routing hints (capped at 500 entries with FIFO eviction) rather than an authoritative caching layer or source of truth, keeping `HttpDataSource` focused on network communication.
   - Non-existent IDs are tracked in `LiveSessionRoutingCache` only on a confirmed 404 from the fallback so repeated lookups do not repeat the fallback request, while transient errors (5xx, timeouts) rethrow to allow retry.
   - If both the primary endpoint and the fallback fail with 404, the original contents-endpoint `ApiException` is rethrown to ensure Sentry and debug logs remain accurate without misleading traces.
   - *Stale positive routing failure mode*: An ID recorded in `LiveSessionRoutingCache` routes directly to `/learning-sessions/<id>/` without reverse fallback to `/contents/<id>/`. If a session type ever mutated on the backend during an active process, subsequent lookups would fail until process restart. This is accepted as session types are immutable in practice.
   - Because live stream participation is an online-only operation and live class details are historically routed via `CourseRepository`, persisting `session_type` in the local Drift SQLite database is unnecessary for this feature. Correctness for cold-starts and deep-links is fully guaranteed by the 404 fallback.
   - A complete architectural decoupling of all live class details from `CourseRepository` into `LiveClassesRepository` (including dedicated SQLite columns and explicit route paths) will be addressed in a dedicated follow-up PR, at which point `LiveSessionRoutingCache` can be removed.

2. **Clean Domain Model Integration**:
   `LiveClassDto` parses `session_type` and provides an `isOneOnOne` boolean getter without requiring breaking Drift database table changes or schema migrations.
