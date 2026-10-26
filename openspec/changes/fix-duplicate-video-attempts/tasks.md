## 1. Network and Data Layer

- [x] 1.1 Add `userVideo` endpoint to `ApiEndpoints`
- [x] 1.2 Define `getVideoAttemptId` and `updateUserVideo` on `DataSource` interface
- [x] 1.3 Implement `getVideoAttemptId` and `updateUserVideo` in `HttpDataSource` with `object_id` fallback
- [x] 1.4 Provide mock implementations in `MockDataSource`
- [x] 1.5 Prevent fall-through to POST in `HttpDataSource.getVideoAttemptId` when `results` is non-empty, and report errors to Sentry

## 2. Repository and State Orchestration

- [x] 2.1 Add attempt ID caching and routing to `updateUserVideo` in `CourseRepository`
- [x] 2.2 Wire attempt ID initialization and sync integration in `VideoAttemptNotifier`
- [x] 2.3 Evict cached attempt ID from `_videoAttemptIds` on `updateUserVideo` failure

## 3. Verification

- [x] 3.1 Add unit tests for `CourseRepository` routing and caching
- [x] 3.2 Add unit test for cache eviction on `updateUserVideo` failure
- [x] 3.3 Add unit test for fallback to updateVideoAttempt when attempt ID is null
- [x] 3.4 Add unit tests for `HttpDataSource.getVideoAttemptId` covering non-empty parsing failure, empty POST, and fallback
- [x] 3.5 Run test suites across `packages/courses` and `packages/core`
