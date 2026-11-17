## Why

1-on-1 live sessions (such as personal mentorship or faculty consultation) are created in Testpress as standalone `LearningSession` models with `session_type: "one_on_one"`. When students open these sessions in Cortex, the app previously hardcoded detail resolution to `/api/v3/live-classes/contents/<id>/`, which only resolves course chapter contents. Because 1-on-1 sessions are not chapter contents, the endpoint returned HTTP 404, stranding students on an error screen.

## What Changes

- Add `liveClassLearningSessionDetail` endpoint (`/api/v3/live-classes/learning-sessions/$id/`) to `ApiEndpoints`.
- Parse `session_type` on `LiveClassDto` from `/api/v3/live-classes/` list payload and expose `isOneOnOne` property.
- Cache session type mappings in `HttpDataSource` during live class list fetching.
- Route live class detail lookups directly to `liveClassLearningSessionDetail` when `session_type == 'one_on_one'`, avoiding 404 error cascades and latency.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `live-classes`: Live class detail lookup routes 1-on-1 sessions directly to the `learning-sessions` API endpoint.

## Impact

- `packages/core/lib/network/api_endpoints.dart`: Added `liveClassLearningSessionDetail` endpoint.
- `packages/core/lib/data/models/live_class_dto.dart`: Added `sessionType` and `isOneOnOne` property.
- `packages/core/lib/data/sources/http_data_source.dart`: Cached session types and routed `getLiveClassDetail` based on `session_type`.
- `packages/core/test/data/models/live_class_dto_test.dart`: Added unit test coverage for `session_type` parsing.
