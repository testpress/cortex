# 0008: Centralize LearnLens Data and Network Layer

## Status
Accepted

## Context
LearnLens AI capabilities (interactive tutoring and MCQ generation) were initially built directly inside `packages/courses` to support video lesson learning. However, the roadmap introduces an organization-wide Generic AI Chat screen accessible globally across Cortex. 

Both features interface with the same LearnLens backend infrastructure:
1. Session token acquisition (`/api/v3/ai-chat/sessions/create/` and `/contents/<id>/ai-sessions/create/`).
2. Authentication via the `X-Session-Token` HTTP header.
3. Chat turn orchestration, status polling, and error normalization.

Duplicating this networking, session management, and DTO layer across multiple packages would introduce divergent logic, redundant token refreshes, and conflicting session caches. In alignment with Cortex's SDK-first monorepo architecture (ADR 0002), shared platform capabilities and network abstractions belong in `packages/core`.

## Decision
We centralize the entire LearnLens data, networking, and session management layer in `packages/core`:

1. **Unified Session Manager (`LearnLensSessionManager`)**:
   - Manages token lifecycle for both organization-level sessions and content-level lesson sessions.
   - Implements in-flight request coalescing to prevent stampeding session creation requests.
   - Binds to `userIdProvider` to automatically purge cached tokens on user switch or logout.

2. **Session Interceptor (`LearnLensSessionInterceptor`)**:
   - Injects the `X-Session-Token` header into outgoing LearnLens HTTP requests.
   - Provides transparent single-attempt 401 Unauthorized retry for managed sessions.
   - Skips 401 retries when callers provide their own explicit tokens (such as content-specific lesson tokens) to prevent scope clobbering.
   - Safely propagates errors to prevent deadlocks in queued interceptor pipelines.

3. **Consolidated DTOs & Exception Handling**:
   - Consolidates all LearnLens DTOs in `packages/core/lib/data/models/learnlens_dto.dart`.
   - Normalizes Dio transport errors, quota exhaustion (429), and session expiry into a standard `LearnLensException`.

4. **Courses Integration**:
   - Refactors `packages/courses` to remove redundant local network clients and repositories, delegating all LearnLens calls directly to `packages/core`.

## Consequences
- **Positive**: Single source of truth for AI session lifecycles, caching, and token refresh logic across the entire app.
- **Positive**: Prevents duplicate token requests through request coalescing.
- **Positive**: Clean separation between low-level network/session management (in `core`) and feature UI (in `courses` and the upcoming generic chat package/feature).
- **Positive**: High automated test coverage for token expiry, 401 recovery, and error mapping in `packages/core/test/`.
