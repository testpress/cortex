# Design: Centralize LearnLens Data & Network Layer

## Context

The Cortex architecture follows an SDK-first, platform-neutral structure where `packages/core` provides fundamental shared infrastructure (primitives, design tokens, network infrastructure, repositories) consumed by domain packages (`packages/courses`, `packages/exams`) and the application shell (`app`). 

LearnLens AI was originally introduced only inside `packages/courses` for video lesson tutoring. With the introduction of an organization-level generic AI assistant, the underlying network client, session token management, and data transfer models must become platform-level capabilities residing in `packages/core`.

## Goals / Non-Goals

**Goals:**
- Centralize all LearnLens network communication, session acquisition, and DTO definitions into `packages/core`.
- Maintain 100% backward compatibility for existing video lesson tutoring (`AITab`) and MCQ quizzes (`VideoMcqTab`) in `packages/courses`.
- Support dual session models: organization-scoped generic chat sessions and content-scoped video lesson sessions.
- Implement proactive and reactive session token renewal with 401 retry interceptor logic.
- Ensure strict session cleanup on user logout or user change.
- Provide comprehensive test coverage with zero regressions across `packages/core` and `packages/courses`.

**Non-Goals:**
- Implementing Riverpod controllers, message mappers, polling services, and UI screens (`AiScreen`, immersive chat, history drawer) — deferred to Part 2.
- Changing video lesson UI widget layouts or user flows in `packages/courses`.

## Decisions

### Decision 1: Single Unified Network Client in `packages/core`
Create a unified `LearnLensNetworkClient` in `packages/core` that handles both asset-scoped routes (`/v2/<org>/assets/<assetId>/chats/`) and organization-scoped routes (`/chats/`, `/chats/<id>/messages/`).
- *Rationale*: Avoids having two distinct Dio clients and duplicate configuration for the same LearnLens backend.
- *Alternatives considered*: Keeping a separate `GenericAiChatNetworkClient` alongside `LearnLensNetworkClient`. Rejected because it duplicates ~70% of network logic, headers, and exception handling.

### Decision 2: Unified Session Manager for Org and Content Scopes
Implement `LearnLensSessionManager` to handle:
1. Organization sessions via `POST /api/v3/ai-chat/sessions/create/` (used by generic chat).
2. Content sessions via `POST /contents/<id>/ai-sessions/create/` (used by video lessons).
- *Rationale*: Consolidates token cache lifecycle, in-flight coalescing, and expiry tracking into a single tested manager.
- *Token Expiry*: Caches tokens and refreshes proactively within a 60-second expiry window, or reactively via a Dio interceptor upon encountering HTTP 401.

### Decision 3: Skip 401 Interceptor Retry When Caller Supplies Manual Token
In `LearnLensSessionInterceptor`, only automatically renew and retry requests that rely on the organization session cache. If a request was dispatched with a caller-supplied content token, skip the generic auto-refresh to prevent overwriting content tokens with org tokens.
- *Rationale*: Preserves proper security scoping between content-specific tokens and organization-wide tokens.

### Decision 4: Safe Session Disposal on User Change
Bind `learnLensSessionManagerProvider` to `userIdProvider` in Riverpod. When `userIdProvider` changes value or emits `null` (logout), the session manager is automatically recreated and all cached session tokens are purged from memory.
- *Rationale*: Prevents cross-user token leaks when multiple accounts use the same device.

### Decision 5: Normalized `LearnLensException`
Consolidate all error mapping into `LearnLensException`, capturing:
- HTTP status code
- Machine-readable error code (e.g., `hourly_message_limit`, `session_expired`, `invalid_message`)
- Quota limits and `retry_at` timestamps for 429 rate-limiting responses.
- Original underlying DioException for cancellation detection.

## Risks / Trade-offs

- [Risk] Re-exporting core client in `packages/courses` might conflict if provider names collide.
  -> *Mitigation*: Define providers in `packages/core` and have `packages/courses` re-export them cleanly, avoiding re-declaring duplicate providers with `@riverpod`.
- [Risk] Concurrent requests during token expiry trigger a storm of refresh requests.
  -> *Mitigation*: Use a shared `Completer` in `LearnLensSessionManager` to coalesce multiple simultaneous `getSession()` calls into a single network call.
