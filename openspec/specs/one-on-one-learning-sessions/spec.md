# one-on-one-learning-sessions Specification

## Purpose
TBD - created by archiving change feat-one-on-one-live-session. Update Purpose after archive.
## Requirements
### Requirement: Upfront 1-on-1 Session Routing
The system SHALL identify 1-on-1 sessions from the `session_type` field and query `/api/v3/live-classes/learning-sessions/<id>/` directly.

#### Scenario: Student opens 1-on-1 live session
- **WHEN** student taps on a live class item with `session_type == "one_on_one"`
- **THEN** system requests details from `/api/v3/live-classes/learning-sessions/<id>/`
- **AND** successfully renders the session lobby without querying `/contents/`

### Requirement: Fallback on 404 for Direct Navigation
The system SHALL fall back to `/api/v3/live-classes/learning-sessions/<id>/` if querying `/api/v3/live-classes/contents/<id>/` returns HTTP 404.

#### Scenario: Student opens 1-on-1 session via direct link or push notification
- **WHEN** student navigates directly to a 1-on-1 session before live class list is cached
- **AND** the `/contents/<id>/` endpoint returns 404 Not Found
- **THEN** system falls back to `/learning-sessions/<id>/`
- **AND** successfully resolves session detail without throwing an error screen

