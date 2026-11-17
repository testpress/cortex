## Context

Testpress v3 distinguishes between course chapter live contents (`/api/v3/live-classes/contents/<id>/`) and standalone learning sessions (`/api/v3/live-classes/learning-sessions/<id>/`). 1-on-1 sessions are created with `session_type: "one_on_one"` and target individual students.

## Architecture Decisions

1. **Direct Routing by Session Type with Resilient Fallback**:
   When `session_type` is known (`one_on_one`) from the live classes list, `HttpDataSource` dispatches immediately to `/api/v3/live-classes/learning-sessions/<id>/` without trial-and-error latency. For cold-starts, direct navigation, or deep-links where the session type is unknown and querying `/contents/<id>/` yields HTTP 404, `HttpDataSource` gracefully falls back to `/learning-sessions/<id>/` and caches the resolution.

2. **Clean Domain Model Integration**:
   `LiveClassDto` parses `session_type` and provides an `isOneOnOne` boolean getter without requiring breaking Drift database table changes or schema migrations.
