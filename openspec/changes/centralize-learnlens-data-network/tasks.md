## 1. DTO & Exception Consolidation in Core

- [x] 1.1 Consolidate all LearnLens data transfer objects in `packages/core/lib/data/models/learnlens_dto.dart` (`AiChatSessionDto`, `AiChatPolicyDto`, `AiGenerationDto`, `AiConversationDto`, `AiMessageDto`, `AiChatTurnResponseDto`, `AiChatQuotaErrorDto`, `PendingTurnRequest`, `AiMessagePageResult`).
- [x] 1.2 Define normalized `LearnLensException` with status code, machine-readable error code, quota limits, retry timestamps, and cancellation detection.
- [x] 1.3 Add factory constructor `AiChatSessionDto.fromContentSession` to parse content-scoped lesson sessions.

## 2. Session Management & Interceptor

- [x] 2.1 Implement `LearnLensSessionManager` in `packages/core/lib/network/learnlens_session_manager.dart` supporting organization sessions and content sessions.
- [x] 2.2 Implement in-flight request coalescing to prevent concurrent refresh storms.
- [x] 2.3 Implement proactive token expiry checks (60s buffer) and explicit `clearSession()` on logout.
- [x] 2.4 Implement `LearnLensSessionInterceptor` to attach `X-Session-Token` headers and handle HTTP 401 retry renewal.
- [x] 2.5 Ensure interceptor skips 401 retry when caller supplied its own content-scoped session token.
- [x] 2.6 Wire `learnLensSessionManagerProvider` to auto-dispose and purge cached tokens when `userIdProvider` changes.

## 3. Unified Network Client & Repository

- [x] 3.1 Implement `LearnLensNetworkClient` in `packages/core/lib/network/learnlens_network_client.dart` supporting both generic chat routes and asset chat/quiz routes.
- [x] 3.2 Implement `LearnLensRepository` in `packages/core/lib/data/repositories/learnlens_repository.dart` coordinating validation, deduplication, and session acquisition.
- [x] 3.3 Add RFC 4122 v4 UUID generator in `packages/core/lib/network/uuid_utils.dart` for request idempotency tracking.
- [x] 3.4 Add generic chat API endpoint constants in `packages/core/lib/network/api_endpoints.dart`.

## 4. Courses Package Integration & Cleanup

- [x] 4.1 Update `packages/courses/lib/providers/learnlens_provider.dart` to re-export `learnLensRepositoryProvider` and `learnLensNetworkClientProvider` from `packages/core`.
- [x] 4.2 Delete redundant `packages/courses/lib/network/learnlens_network_client.dart` and `packages/courses/lib/repositories/learnlens_repository.dart`.
- [x] 4.3 Remove dead `createAiSession` from `DataSource` and mock implementations.
- [x] 4.4 Verify video lesson tutoring (`AITab`) and MCQ quiz (`VideoMcqTab`) compile and function without regressions.

## 5. Automated Tests & Static Analysis

- [x] 5.1 Add unit tests for DTO parsing and default fallback policies in `packages/core/test/data/models/learnlens_dto_test.dart`.
- [x] 5.2 Add unit tests for session acquisition, caching, concurrent coalescing, 401 retries, and user change cleanup in `packages/core/test/network/learnlens_session_manager_test.dart`.
- [x] 5.3 Add unit tests for network endpoints, pagination cursors, rate-limit error mapping, and deduplication in `packages/core/test/network/learnlens_network_client_test.dart`.
- [x] 5.4 Run static analysis across `packages/core` and `packages/courses` to verify 0 errors and 0 warnings.
