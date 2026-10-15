# Proposal: Centralize LearnLens Data & Network Layer

## Why

Currently, LearnLens AI capabilities only exist within `packages/courses` to support video lesson tutoring and MCQ quizzes. However, the upcoming organization-wide Generic AI Chat requires accessing the same LearnLens AI backend infrastructure (session management, token lifecycle, Dio networking, and DTO parsing). 

Duplicating this networking and session management layer across packages would create code divergence, redundant token refreshes, and conflicting session caches. Centralizing the LearnLens data and network layer into `packages/core` establishes a single source of truth for all AI features across Cortex, allowing both `packages/courses` and future feature packages to consume a unified client.

This proposal represents **Part 1 of the 2-part Generic AI Chat integration**:
1. **Part 1 (This Change)**: Centralize LearnLens networking, session management, and DTOs in `packages/core`.
2. **Part 2**: Implement Generic AI Chat providers (state management, polling service, message mappers), UI screens (`AiScreen`, immersive chat, history drawer), settings toggles, and routing.

## What Changes

- **Move LearnLens Client & Repository into `packages/core`**:
  - Relocate HTTP communication methods (`submitChat`, `fetchQuiz`, `listConversations`, `startConversation`, `sendFollowUpMessage`, `getMessages`, `getConversationStatus`) into a unified `LearnLensNetworkClient`.
  - Create `LearnLensRepository` in `packages/core` coordinating session acquisition and request execution.
  - Refactor `packages/courses` to consume the unified client and repository directly from `packages/core`, eliminating duplicate network and repository definitions.

- **Unified Session Management**:
  - Introduce `LearnLensSessionManager` in `packages/core` to handle both organization-scoped generic chat sessions (`/api/v3/ai-chat/sessions/create/`) and content-scoped video lesson sessions (`/contents/<id>/ai-sessions/create/`).
  - Provide an interceptor (`LearnLensSessionInterceptor`) that injects the `X-Session-Token` header and transparently handles 401 token refresh retries.
  - Bound session cache invalidation to user authentication changes (`userIdProvider`) so tokens purge on user switch or logout.

- **Centralized DTO Models & Error Handling**:
  - Consolidate all LearnLens DTOs in `packages/core/lib/data/models/learnlens_dto.dart` (sessions, turns, conversations, messages, quota errors, and policies).
  - Define a normalized `LearnLensException` mapping Dio errors, 401 token refresh errors, and 429 rate-limiting responses.

- **Automated Test Coverage**:
  - Add comprehensive unit tests in `packages/core/test/` covering DTO deserialization, session lifecycle, 401 interceptor retries, error mappings, and request idempotency.

## Capabilities

### New Capabilities
- `learnlens-data-network`: Platform-level data models, network client, session token manager, and repository in `packages/core` for communicating with LearnLens and Testpress AI session endpoints.

### Modified Capabilities
- `video-ai-chat`: Refactor video lesson AI in `packages/courses` to delegate networking and repository calls to `packages/core`.

## Impact

- `packages/core/lib/data/models/learnlens_dto.dart`: Unified DTOs and `LearnLensException`.
- `packages/core/lib/network/learnlens_network_client.dart`: Unified HTTP client for LearnLens routes.
- `packages/core/lib/network/learnlens_session_manager.dart`: Session manager and 401 retry interceptor.
- `packages/core/lib/data/repositories/learnlens_repository.dart`: Unified repository exposing AI chat and quiz operations.
- `packages/core/lib/network/uuid_utils.dart`: RFC 4122 v4 UUID generator for request idempotency.
- `packages/core/lib/network/api_endpoints.dart`: Shared endpoints for generic chat and session creation.
- `packages/courses/lib/providers/learnlens_provider.dart`: Delegates to core providers.
- `packages/courses/lib/network/learnlens_network_client.dart`: Removed in favor of core client.
- `packages/courses/lib/repositories/learnlens_repository.dart`: Removed in favor of core repository.
