## 1. API & Model Updates (`packages/core`)

- [x] 1.1 Add `liveClassLearningSessionDetail` endpoint in `ApiEndpoints`.
- [x] 1.2 Parse `session_type` and add `isOneOnOne` property in `LiveClassDto`.
- [x] 1.3 Update `HttpDataSource` to cache session types and route 1-on-1 sessions directly to `learning-sessions` API.
- [x] 1.4 Add 404 fallback to `liveClassLearningSessionDetail` on `HttpDataSource.getLiveClassDetail` for cache misses and deep links.

## 2. Verification & Testing

- [x] 2.1 Add unit tests in `live_class_dto_test.dart` verifying `session_type` parsing and `isOneOnOne` evaluation.
- [x] 2.2 Add unit tests for `HttpDataSource.getLiveClassDetail` endpoint dispatch, cache hit, and 404 fallback.
