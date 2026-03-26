## Context

The current architecture in `packages/core` separates network concerns by creating distinct `Dio` instances for authentication (`AuthApiService`) and general data fetching (`HttpDataSource`). This fragmentation causes:
- Inconsistent application of interceptors.
- Separate connection pools (resource waste).
- Difficulty in implementing global side-effects like automatic logout on `401 Unauthorized` responses.

## Goals / Non-Goals

### Goals
- Establish a single `dioProvider` as the source of truth for all HTTP requests.
- Implement a "Smart" `AuthInterceptor` that handles both token injection (with path exclusions) and global session invalidation.
- Ensure zero circular dependencies between `Dio`, `AuthInterceptor`, and `AuthRepository`.

### Non-Goals
- Migrating to a different HTTP client (staying with `Dio`).
- Implementing complex retry/backoff logic (can be a separate future change).

## Decisions

### 1. Riverpod Managed Singleton
We will use a `Provider<Dio>` in `packages/core/lib/network/` to manage the lifecycle.
- **Rationale**: Riverpod handles the lazy-loading and caching (memoization) automatically, ensuring only one instance exists.
- **Alternative**: A static singleton class (e.g., `NetworkProvider.instance`). Rejected because it makes testing and overriding in mock environments harder than Riverpod.

### 2. Path-Exclusion in AuthInterceptor
The interceptor will maintain a list of `publicPaths` (e.g., `['/auth/login', '/auth/otp']`).
- **Rationale**: This is the cleanest way to allow the same `Dio` instance to perform "Public" auth requests without attempting to attach a (potentially expired or missing) JWT.
- **Alternative**: Using multiple `Dio` instances (current approach). Rejected due to fragmentation.

### 3. Circularity Break via Agnostic Callbacks
The `AuthInterceptor` will not depend on any specific Repository or Data Source. Instead, it will accept a `Future<String?> Function() getToken` callback.
- **Rationale**: This enforces a strict architectural boundary. The interceptor is a "Pure utility" that doesn't care about your Domain or Data layer logic.
- **Implementation**: The `dioProvider` will resolve this callback by reading from `authRepositoryProvider`. Since the resolution happens inside the callback (lazy execution), it safely breaks the circular dependency loop.

### 4. Global 401 Hook
The `AuthInterceptor` will override `onError` to detect `401` status codes.
- **Rationale**: Centralizing this in the network layer ensures that any "Unauthorized" response anywhere in the app triggers a consistent "Session Expired" flow.

### 5. Consolidated User-Agent Infrastructure
The `UserAgentHelper` logic will be moved into a private method within `UserAgentInterceptor`.
- **Rationale**: The helper was a single-method class only used by the interceptor. Merging them reduces file-count and boilerplate while keeping the logic encapsulated where it's used.

## Risks / Trade-offs

- **[Risk]** Forgetting to add a new public route to the exclusion list → **[Mitigation]** The interceptor will log a warning if it tries to fetch a token for a request that fails with a 401.
- **[Risk]** Overhead of `ref.read` inside every request → **[Mitigation]** Negligible. A Riverpod lookup takes < 0.01ms, whereas a typical disk read for a token or a network request takes 100ms+. The delay is physically invisible.
